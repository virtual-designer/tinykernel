#include "pg.h"
#include "mm.h"
#include "regions.h"
#include "stdbool.h"

struct pg_pdpt_entry_ps pg_kernel_pdpt_mapping[] = {
    /* Starts at index 508 */

    {
        .present = true,
        .access_mode = PG_RDONLY,
        .privilege_mode = PG_PRIV_SUPERVISOR_USER,
        .global = true,
        .accessed = false,
        .dirty = false,
        .exec_disable = false,
        .ign_0 = 0,
        .ign_1 = 0,
        .page_cache_disable = false,
        .page_write_through = false,
        .page_size = true,
        .pat = 0,
    },
    {
        .present = true,
        .access_mode = PG_RDONLY,
        .privilege_mode = PG_PRIV_SUPERVISOR_USER,
        .global = true,
        .accessed = false,
        .dirty = false,
        .exec_disable = false,
        .ign_0 = 0,
        .ign_1 = 0,
        .page_cache_disable = false,
        .page_write_through = false,
        .page_size = true,
        .pat = 0,
    },
    {
        .present = true,
        .access_mode = PG_RDONLY,
        .privilege_mode = PG_PRIV_SUPERVISOR_USER,
        .global = true,
        .accessed = false,
        .dirty = false,
        .exec_disable = false,
        .ign_0 = 0,
        .ign_1 = 0,
        .page_cache_disable = false,
        .page_write_through = false,
        .page_size = true,
        .pat = 0,
    },
    {
        .present = true,
        .access_mode = PG_RDONLY,
        .privilege_mode = PG_PRIV_SUPERVISOR_USER,
        .global = true,
        .accessed = false,
        .dirty = false,
        .exec_disable = false,
        .ign_0 = 0,
        .ign_1 = 0,
        .page_cache_disable = false,
        .page_write_through = false,
        .page_size = true,
        .pat = 0,
    },
};

void
pg_load_pml4 (struct pg_pml4 *pml4)
{
    __asm__ volatile ("movq %0, %%cr3" ::"r"(pml4) : "memory");
}

void
pg_kernel_mappings_init (void)
{
    const uint64_t kload_addr_page_start
        = PG_ALIGN_DOWN ((uint64_t) __KERNEL_LOAD_ADDR_START, PG_PAGE_1G_SIZE)
          >> PG_PAGE_1G_SIZE_SHIFT;

    for (uint64_t i = 0; i < sizeof (pg_kernel_pdpt_mapping)
                                 / sizeof (pg_kernel_pdpt_mapping[0]);
         i++)
        pg_kernel_pdpt_mapping[i].addr = kload_addr_page_start + i;
}
