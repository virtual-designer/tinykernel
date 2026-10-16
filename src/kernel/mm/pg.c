#include "pg.h"
#include "falloc.h"
#include "init/e820.h"
#include "regions.h"
#include "stdbool.h"
#include "stdio.h"
#include "utils/string.h"
#include "utils/utils.h"

#define PG_KERNEL_SHADOW_PML4_INDEX_START 256
#define PG_KERNEL_CODE_PML4_INDEX 511
#define PG_KERNEL_CODE_PDPT_INDEX_START 510

extern char __KERNEL_PGTABLES_SHADOW_START[];
extern char __KERNEL_PGTABLES_SHADOW_END[];

__attribute__ ((aligned (4096))) static struct pg_pml4 pg_kernel_pml4 = { 0 };
__attribute__ ((aligned (4096))) static struct pg_pdpt pg_kernel_top_code_pdpt
    = { 0 };

static inline uint64_t
pg_get_current_pml4_phy_addr (void)
{
    return util_read_cr3 () & ~0xFFFULL;
}

static inline void
pg_set_current_pml4_phy_addr (uint64_t phy_addr)
{
    phy_addr &= ~0xFFFULL;
    util_write_cr3 (phy_addr);
}

static inline void
pg_reload_pml4 (void)
{
    pg_set_current_pml4_phy_addr (
        (uint64_t) pg_kcode_virt_to_phy (&pg_kernel_pml4));
}

void
pg_kernel_code_map_init (void)
{
    const uint64_t kload_addr_page_start
        = PG_ALIGN_DOWN ((uint64_t) __KERNEL_LOAD_PHY_ADDR_START,
                         PG_PAGE_1G_SIZE)
          >> PG_PAGE_1G_SIZE_SHIFT;

    for (size_t i = PG_KERNEL_CODE_PDPT_INDEX_START; i < PG_PDPT_ENTRY_COUNT;
         i++)
    {
        struct pg_pdpt_entry_ps *e
            = (struct pg_pdpt_entry_ps *) &pg_kernel_top_code_pdpt.entries[i];

        e->present = true;
        e->access_mode = PG_RDONLY;
        e->privilege_mode = PG_PRIV_SUPERVISOR_ONLY;
        e->global = true;
        e->page_size = true;
        e->addr = kload_addr_page_start + (i - PG_KERNEL_CODE_PDPT_INDEX_START);
    }

    struct pg_pml4_entry *top_pml4e
        = &pg_kernel_pml4.entries[PG_KERNEL_CODE_PML4_INDEX];

    top_pml4e->present = true;
    top_pml4e->access_mode = PG_RDWR;
    top_pml4e->privilege_mode = PG_PRIV_SUPERVISOR_ONLY;
    top_pml4e->pdpt_addr
        = ((uint64_t) pg_kcode_virt_to_phy ((uint64_t) &pg_kernel_top_code_pdpt)
           >> PG_PAGE_SIZE_SHIFT);
}

void
pg_kernel_mem_shadow_map_init (const struct e820_table *e820_table)
{
    uint64_t pml4e_index = PG_KERNEL_SHADOW_PML4_INDEX_START;
    struct pg_pml4_entry *pml4e = NULL;
    struct pg_pdpt *pdpt = (struct pg_pdpt *) __KERNEL_PGTABLES_SHADOW_START;

    for (uint16_t i = 0; i < e820_table->entry_count; i++)
    {
        const struct e820_entry *e = &e820_table->entries[i];

        if (e->type != MEM_USABLE && e->type != MEM_ACPI_RECLAIMABLE)
            continue;

        uint64_t base = PG_ALIGN_DOWN (e->base, PG_PAGE_1G_SIZE);

        for (uint64_t g = 0;; g++)
        {
            if (g && !(g & 0x1FF))
            {
                pml4e_index++;
                pdpt++;
                kprintf ("pg: move to next PDPT & PML4E\n");
            }

            if ((void *) pdpt >= (void *) __KERNEL_PGTABLES_SHADOW_END
                || pml4e_index >= PG_PML4_ENTRY_COUNT)
                goto end;

            pml4e = &pg_kernel_pml4.entries[pml4e_index];

            if (!pml4e->present)
            {
                pml4e->present = true;
                pml4e->access_mode = PG_RDONLY;
                pml4e->privilege_mode = PG_PRIV_SUPERVISOR_ONLY;
                pml4e->pdpt_addr
                    = ((uint64_t) pg_kcode_virt_to_phy ((uint64_t) pdpt)
                       >> PG_PAGE_SIZE_SHIFT);
                kprintf ("pg: initialize PML4E %llu\n", pml4e_index);
            }

            uint64_t base_1g = base + (g << 30);

            if (base_1g - base >= e->length)
                break;

            uint64_t pdpt_index = (base_1g >> PG_PAGE_1G_SIZE_SHIFT) & 0x1FF;
            struct pg_pdpt_entry_ps *pdpte
                = (struct pg_pdpt_entry_ps *) &pdpt->entries[pdpt_index];

            if (!pdpte->present)
            {
                pdpte->present = true;
                pdpte->access_mode = PG_RDONLY;
                pdpte->privilege_mode = PG_PRIV_SUPERVISOR_ONLY;
                pdpte->global = true;
                pdpte->page_size = true;
                pdpte->addr = base_1g >> PG_PAGE_1G_SIZE_SHIFT;
                kprintf (
                    "Initialize PDPTE %llu on PML4E %llu: 0x%0llx - 0x%0llx\n",
                    pdpt_index, pml4e_index, base_1g, base_1g + ((g + 1) << 30));
            }
        }

        kprintf ("pg: finished mapping entry: %u\n", i);
    }

    kprintf ("pg: finished building tables\n");
    
end:
    return;
}

void
pg_kernel_map_init (const struct e820_table *e820_table)
{
    pg_kernel_code_map_init ();
    pg_kernel_mem_shadow_map_init (e820_table);
}
