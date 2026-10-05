#include "mman.h"
#include "init/e820.h"
#include "stdbool.h"
#include "stddef.h"
#include "stdint.h"
#include "stdio.h"
#include "utils/string.h"
#include "utils/utils.h"

#define KMEM_MAP_BASE_MIN 0x10000
#define KMEM_PAGE_SIZE 4096
#define KMEM_ALIGN_DOWN(addr) ((addr) & ~(KMEM_PAGE_SIZE - 1))
#define KMEM_ALIGN_UP(addr) (KMEM_ALIGN_DOWN ((addr) + KMEM_PAGE_SIZE - 1))

extern const uint8_t __KERNEL_LOAD_ADDR_START_SYM;
extern const uint8_t __KERNEL_LOAD_ADDR_END_SYM;
extern const uint8_t __KERNEL_LOAD_RUNTIME_SIZE_SYM;
static const uint8_t *__KERNEL_LOAD_ADDR_START = &__KERNEL_LOAD_ADDR_START_SYM;
static const uint8_t *__KERNEL_LOAD_ADDR_END = &__KERNEL_LOAD_ADDR_END_SYM;
static const size_t __KERNEL_LOAD_RUNTIME_SIZE
    = (size_t) (void *) &__KERNEL_LOAD_RUNTIME_SIZE_SYM;

struct kmem_region
{
    uint64_t base;
    uint64_t length;
    uint64_t offset;
};

struct kmman
{
    struct kmem_region *regions;
    size_t region_count;
};

static inline __attribute__ ((returns_nonnull)) struct kmman *
kmman_init_with_addr (void *addr)
{
    struct kmman *mman = (struct kmman *) addr;

    mman->region_count = 0;
    mman->regions = NULL;

    return mman;
}

static inline bool
kmman_addr_range_overlap (uint64_t addr1_begin, uint64_t addr1_end,
                          uint64_t addr2_begin, uint64_t addr2_end)
{
    return addr1_begin < addr2_end && addr2_begin < addr1_end;
}

struct kmman *
kmman_init_with_e820_table (const struct e820_table *table)
{
    struct kmem_region regions[512];
    size_t region_count = 0;

    uint64_t kbegin = (uint64_t) (size_t) __KERNEL_LOAD_ADDR_START;
    uint64_t kend = (uint64_t) (size_t) __KERNEL_LOAD_ADDR_END;

    for (size_t i = 0; i < table->entry_count; i++)
    {
        /* FIXME: 32-bit only restriction for now */
        if (table->entries[i].type != MEM_USABLE
            || table->entries[i].base >= SIZE_MAX
            || table->entries[i].base < KMEM_MAP_BASE_MIN)
            continue;

        uint64_t base = table->entries[i].base;
        uint64_t length = table->entries[i].length;
        uint64_t end = base + length;

        if (kmman_addr_range_overlap (kbegin, kend, base, end))
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
        = sizeof (struct kmman) + (sizeof (struct kmem_region) * region_count);

    for (size_t i = 0; i < region_count; i++)
    {
        regions[i].base = KMEM_ALIGN_UP (regions[i].base);
        regions[i].length
            = KMEM_ALIGN_DOWN (regions[i].base + regions[i].length)
              - regions[i].base;

        if (!mman_ptr && regions[i].length >= mman_size)
        {
            mman_ptr = (void *) (size_t) regions[i].base;
            regions[i].offset += mman_size;
        }
    }

    if (!mman_ptr)
        return NULL;

    struct kmman *mman = kmman_init_with_addr (mman_ptr);

    mman->regions = (struct kmem_region *) (mman + 1);
    mman->region_count = region_count;

    memcpy (mman->regions, regions, region_count * sizeof (struct kmem_region));

    return mman;
}

void
kmman_print (const struct kmman *mman)
{
    kprintf ("Kernel Memory Manager Information:\n");
    kprintf ("  Allocated at:      %p\n", (void *) mman);
    kprintf ("  Kernel Image Size: %zS\n", __KERNEL_LOAD_RUNTIME_SIZE);
    kprintf ("  Regions:           %zu\n", mman->region_count);
    kprintf ("  Region Map:\n");

    for (size_t i = 0; i < mman->region_count; i++)
    {
        kprintf (
            "    [0x%0llx-0x%0llx]: length %llu bytes, offset %llu bytes\n",
            mman->regions[i].base,
            mman->regions[i].base + mman->regions[i].length,
            mman->regions[i].length, mman->regions[i].offset);
    }

    kprintf ("\n");
}
