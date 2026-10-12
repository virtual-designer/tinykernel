#include "mm.h"
#include "init/e820.h"
#include "stdbool.h"
#include "stddef.h"
#include "stdint.h"
#include "stdio.h"
#include "utils/string.h"
#include "utils/utils.h"
#include "regions.h"
#include "pg.h"

struct kmem_region
{
    uint64_t base;
    uint64_t length;
    uint64_t offset;
};

struct kmem_manager
{
    struct kmem_region *regions;
    size_t region_count;
};

static inline __attribute__ ((returns_nonnull)) struct kmem_manager *
kmm_init_with_addr (void *addr)
{
    struct kmem_manager *mman = (struct kmem_manager *) addr;

    mman->region_count = 0;
    mman->regions = NULL;

    return mman;
}

static inline bool
kmm_addr_range_overlap (uint64_t addr1_begin, uint64_t addr1_end,
                          uint64_t addr2_begin, uint64_t addr2_end)
{
    return addr1_begin < addr2_end && addr2_begin < addr1_end;
}

struct kmem_manager *
kmm_init_with_e820_table (const struct e820_table *table)
{
    struct kmem_region regions[512];
    size_t region_count = 0;

    uint64_t kbegin = (uint64_t) (size_t) __KERNEL_LOAD_ADDR_START;
    uint64_t kend = (uint64_t) (size_t) __KERNEL_LOAD_ADDR_END;

    for (size_t i = 0; i < table->entry_count; i++)
    {
        if (table->entries[i].type != MEM_USABLE)
            continue;

        uint64_t base = table->entries[i].base;
        uint64_t length = table->entries[i].length;
        uint64_t end = base + length;

        if (kmm_addr_range_overlap (kbegin, kend, base, end))
        {
            if (kbegin >= base && kend <= end)
            {
                if (kbegin > base)
                {
                    regions[region_count].base = base;
                    regions[region_count].length = kbegin - base;
                    regions[region_count].offset = 0;
                    region_count++;

                    if (region_count >= 512)
                        break;
                }

                if (end > kend)
                {
                    regions[region_count].base = kend;
                    regions[region_count].length = end - kend;
                    regions[region_count].offset = 0;
                    region_count++;

                    if (region_count >= 512)
                        break;
                }

                continue;
            }
            else if (base >= kbegin)
            {
                if (end <= kend)
                    continue;

                base = kend;
                length = end - kend;
            }
            else
            {
                length = kbegin - base;
            }
        }

        regions[region_count].base = base;
        regions[region_count].length = length;
        regions[region_count].offset = 0;

        region_count++;

        if (region_count >= 512)
            break;
    }

    void *mman_ptr = NULL;
    const size_t mman_size
        = sizeof (struct kmem_manager) + (sizeof (struct kmem_region) * region_count);

    for (size_t i = 0; i < region_count; i++)
    {
        regions[i].base = PG_ALIGN_UP (regions[i].base, PG_PAGE_SIZE);
        regions[i].length
            = PG_ALIGN_DOWN (regions[i].base + regions[i].length, PG_PAGE_SIZE)
              - regions[i].base;

        if (!mman_ptr && regions[i].length >= mman_size)
        {
            mman_ptr = (void *) regions[i].base;
            regions[i].offset += mman_size;
        }
    }

    if (!mman_ptr)
        return NULL;

    struct kmem_manager *mman = kmm_init_with_addr (mman_ptr);

    mman->regions = (struct kmem_region *) (mman + 1);
    mman->region_count = region_count;

    memcpy (mman->regions, regions, region_count * sizeof (struct kmem_region));

    return mman;
}

void
kmm_print (const struct kmem_manager *kmm)
{
    kprintf ("Kernel Memory Manager Information:\n");
    kprintf ("  Allocated at:       %p\n", (void *) kmm);
    kprintf ("  Kernel Image Size:  %zu bytes\n", __KERNEL_LOAD_RUNTIME_SIZE);
    
    size_t total_mapped_size = 0;
    
    for (size_t i = 0; i < kmm->region_count; i++)
        total_mapped_size += kmm->regions[i].length;
    
    kprintf ("  Mapped memory size: %zu bytes\n", total_mapped_size);
    kprintf ("  Regions:            %zu\n", kmm->region_count);
    kprintf ("  Region Map:\n");

    for (size_t i = 0; i < kmm->region_count; i++)
    {
        kprintf (
            "    [0x%0llx-0x%0llx]: length %llu bytes, offset %llu bytes\n",
            kmm->regions[i].base,
            kmm->regions[i].base + kmm->regions[i].length,
            kmm->regions[i].length, kmm->regions[i].offset);
    }

    kprintf ("\n");
}
