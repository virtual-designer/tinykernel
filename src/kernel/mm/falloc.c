#include "falloc.h"
#include "init/e820.h"
#include "pg.h"
#include "regions.h"
#include "stdbool.h"
#include "stddef.h"
#include "stdint.h"
#include "stdio.h"
#include "utils/string.h"
#include "utils/utils.h"

#define FALLOC_START_ADDR 0x00

struct falloc_region
{
    uint64_t base;
    uint64_t length;
    uint64_t offset;
};

struct falloc
{
    struct falloc_region *regions;
    size_t region_count;
    size_t region_current;
};

static struct falloc_region fl_regions[512] = { 0 };
static struct falloc fl = { 0 };

static inline bool
falloc_addr_range_overlap (uint64_t addr1_begin, uint64_t addr1_end,
                           uint64_t addr2_begin, uint64_t addr2_end)
{
    return addr1_begin < addr2_end && addr2_begin < addr1_end;
}

struct falloc *
falloc_init_with_e820_table (const struct e820_table *table)
{
    size_t region_count = 0;

    uint64_t kbegin = (uint64_t) (size_t) __KERNEL_LOAD_PHY_ADDR_START;
    uint64_t kend = __KERNEL_LOAD_RUNTIME_SIZE
                    + (uint64_t) (size_t) __KERNEL_LOAD_PHY_ADDR_START;

    for (size_t i = 0; i < table->entry_count; i++)
    {
        if (table->entries[i].type != MEM_USABLE)
            continue;

        uint64_t base = table->entries[i].base;
        uint64_t length = table->entries[i].length;
        uint64_t end = base + length;

        if (falloc_addr_range_overlap (base, base + length, 0,
                                       FALLOC_START_ADDR))
        {
            base = FALLOC_START_ADDR;

            if (end <= base)
                continue;

            length = end - base;
        }

        if (falloc_addr_range_overlap (kbegin, kend, base, end))
        {
            if (kbegin >= base && kend <= end)
            {
                if (kbegin > base)
                {
                    fl_regions[region_count].base = base;
                    fl_regions[region_count].length = kbegin - base;
                    fl_regions[region_count].offset = 0;
                    region_count++;

                    if (region_count >= 512)
                        break;
                }

                if (end > kend)
                {
                    fl_regions[region_count].base = kend;
                    fl_regions[region_count].length = end - kend;
                    fl_regions[region_count].offset = 0;
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

        fl_regions[region_count].base = base;
        fl_regions[region_count].length = length;
        fl_regions[region_count].offset = 0;

        region_count++;

        if (region_count >= 512)
            break;
    }

    for (size_t i = 0; i < region_count; i++)
    {
        fl_regions[i].base
            = PG_ALIGN_UP (fl_regions[i].base, (uint64_t) PG_PAGE_SIZE);
        fl_regions[i].length
            = PG_ALIGN_DOWN (fl_regions[i].base + fl_regions[i].length,
                             (uint64_t) PG_PAGE_SIZE)
              - fl_regions[i].base;
    }

    if (!region_count)
        return NULL;

    fl.regions = fl_regions;
    fl.region_count = region_count;
    fl.region_current = 0;

    /* Skip over the first page (4K). */
    falloc_page ();
    return &fl;
}

void
falloc_print (void)
{
    kprintf ("Kernel Memory Manager Information:\n");
    kprintf ("  Allocated at:       %p\n", (void *) &fl);
    kprintf ("  Kernel loaded at:   %p\n",
             (void *) __KERNEL_LOAD_VIRT_ADDR_START);
    kprintf ("  Kernel Image Size:  %zu bytes\n", __KERNEL_LOAD_RUNTIME_SIZE);

    size_t total_mapped_size = 0;

    for (size_t i = 0; i < fl.region_count; i++)
        total_mapped_size += fl.regions[i].length;

    kprintf ("  Usable memory size: %zu bytes\n", total_mapped_size);
    kprintf ("  Regions:            %zu\n", fl.region_count);
    kprintf ("  Region Map:\n");

    for (size_t i = 0; i < fl.region_count; i++)
    {
        kprintf (
            "    [0x%0llx-0x%0llx]: length %llu bytes, offset %llu bytes\n",
            fl.regions[i].base, fl.regions[i].base + fl.regions[i].length,
            fl.regions[i].length, fl.regions[i].offset);
    }

    kprintf ("\n");
}

uint64_t
falloc (size_t size)
{
    for (size_t i = fl.region_current; i < fl.region_count; i++)
    {
        struct falloc_region *r = &fl.regions[i];

        if (r->offset + size > r->length)
            continue;

        uint64_t ptr = r->base + r->offset;
        r->offset += size;
        return ptr;
    }

    return (uint64_t) NULL;
}

uint64_t
falloc_page (void)
{
    return falloc (PG_PAGE_SIZE);
}

void
ffree (void *ptr)
{
    (void) ptr;
}
