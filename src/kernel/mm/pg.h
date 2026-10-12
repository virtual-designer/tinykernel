#ifndef KERNEL_PG_H
#define KERNEL_PG_H

#include "stdint.h"

#define PG_PML4_ENTRY_COUNT 512
#define PG_PDPT_ENTRY_COUNT 512
#define PG_PD_ENTRY_COUNT   512
#define PG_PT_ENTRY_COUNT   512

#define PG_PAGE_SIZE_SHIFT    12
#define PG_PAGE_2M_SIZE_SHIFT 21
#define PG_PAGE_1G_SIZE_SHIFT 30

#define PG_PAGE_SIZE        (1U << PG_PAGE_SIZE_SHIFT)
#define PG_PAGE_2M_SIZE     (1U << PG_PAGE_2M_SIZE_SHIFT)
#define PG_PAGE_1G_SIZE     (1U << PG_PAGE_1G_SIZE_SHIFT)

#define PG_ALIGN_DOWN(addr, pg_size) ((addr) & ~((pg_size) - 1))
#define PG_ALIGN_UP(addr, pg_size) (PG_ALIGN_DOWN ((addr) + (pg_size) - 1, pg_size))

enum pg_access_mode
{
    PG_RDONLY = 0,
    PG_RDWR = 1,
};

enum pg_privilege
{
    PG_PRIV_SUPERVISOR_USER = 1,
    PG_PRIV_SUPERVISOR_ONLY = 0
};

enum pg_pdpt_page_size
{
    PG_PDPT_DEFAULT = 0,
    PG_PDPT_1G = 1
};

enum pg_pd_page_size
{
    PG_PD_DEFAULT = 0,
    PG_PD_2M = 1
};

struct pg_pml4_entry
{
    uint8_t present : 1;
    uint8_t access_mode : 1;
    uint8_t privilege_mode : 1;
    uint8_t page_write_through : 1;
    uint8_t page_cache_disable : 1;
    uint8_t accessed : 1;
    uint8_t ign_0 : 1;
    uint8_t resv_0 : 1;
    uint8_t ign_1 : 3;
    uint8_t restart : 1;
    uint64_t pdpt_addr : 40;
    uint16_t ign_2 : 11;
    uint8_t exec_disable : 1;
} __attribute__ ((packed));

struct pg_pdpt_entry
{
    uint8_t present : 1;
    uint8_t access_mode : 1;
    uint8_t privilege_mode : 1;
    uint8_t page_write_through : 1;
    uint8_t page_cache_disable : 1;
    uint8_t accessed : 1;
    uint8_t ign_0 : 1;
    uint8_t page_size : 1;
    uint8_t ign_1 : 3;
    uint8_t restart : 1;
    uint64_t pd_addr : 40;
    uint16_t ign_2 : 11;
    uint8_t exec_disable : 1;
} __attribute__ ((packed));

struct pg_pdpt_entry_ps
{
    uint8_t present : 1;
    uint8_t access_mode : 1;
    uint8_t privilege_mode : 1;
    uint8_t page_write_through : 1;
    uint8_t page_cache_disable : 1;
    uint8_t accessed : 1;
    uint8_t dirty : 1;
    uint8_t page_size : 1;
    uint8_t global : 1;
    uint8_t ign_0 : 2;
    uint8_t restart : 1;
    uint8_t pat : 1;
    uint32_t resv_0 : 17;
    uint64_t addr : 22;
    uint8_t ign_1 : 7;
    uint8_t prot_key : 4;
    uint8_t exec_disable : 1;
} __attribute__ ((packed));

struct pg_pd_entry
{
    uint8_t present : 1;
    uint8_t access_mode : 1;
    uint8_t privilege_mode : 1;
    uint8_t page_write_through : 1;
    uint8_t page_cache_disable : 1;
    uint8_t accessed : 1;
    uint8_t ign_0 : 1;
    uint8_t page_size : 1;
    uint8_t ign_1 : 3;
    uint8_t restart : 1;
    uint64_t pt_addr : 40;
    uint16_t ign_2 : 11;
    uint8_t exec_disable : 1;
} __attribute__ ((packed));

struct pg_pd_entry_ps
{
    uint8_t present : 1;
    uint8_t access_mode : 1;
    uint8_t privilege_mode : 1;
    uint8_t page_write_through : 1;
    uint8_t page_cache_disable : 1;
    uint8_t accessed : 1;
    uint8_t dirty : 1;
    uint8_t page_size : 1;
    uint8_t global : 1;
    uint8_t ign_0 : 2;
    uint8_t restart : 1;
    uint8_t pat : 1;
    uint32_t resv_0 : 8;
    uint64_t addr : 31;
    uint8_t ign_1 : 7;
    uint8_t prot_key : 4;
    uint8_t exec_disable : 1;
} __attribute__ ((packed));

struct pg_pt_entry
{
    uint8_t present : 1;
    uint8_t access_mode : 1;
    uint8_t privilege_mode : 1;
    uint8_t page_write_through : 1;
    uint8_t page_cache_disable : 1;
    uint8_t accessed : 1;
    uint8_t dirty : 1;
    uint8_t pat : 1;
    uint8_t global : 1;
    uint8_t ign_0 : 2;
    uint8_t restart : 1;
    uint64_t addr : 40;
    uint8_t ign_1 : 7;
    uint8_t prot_key : 4;
    uint8_t exec_disable : 1;
} __attribute__ ((packed));

_Static_assert (sizeof (struct pg_pml4_entry) == 8,
                "(struct pg_pml4_entry) size must be 8 bytes");
_Static_assert (sizeof (struct pg_pdpt_entry) == 8,
                "(struct pg_pdpt_entry) size must be 8 bytes");
_Static_assert (sizeof (struct pg_pdpt_entry_ps) == 8,
                "(struct pg_pdpt_entry_ps) size must be 8 bytes");
_Static_assert (sizeof (struct pg_pd_entry) == 8,
                "(struct pg_pd_entry) size must be 8 bytes");
_Static_assert (sizeof (struct pg_pd_entry_ps) == 8,
                "(struct pg_pd_entry_ps) size must be 8 bytes");
_Static_assert (sizeof (struct pg_pt_entry) == 8,
                "(struct pg_pt_entry) size must be 8 bytes");

struct pg_pml4
{
    struct pg_pml4_entry entries[PG_PML4_ENTRY_COUNT];
} __attribute__ ((packed, aligned (4096)));

struct pg_pdpt
{
    struct pg_pdpt_entry entries[PG_PDPT_ENTRY_COUNT];
} __attribute__ ((packed, aligned (4096)));

struct pg_pd
{
    struct pg_pd_entry entries[PG_PD_ENTRY_COUNT];
} __attribute__ ((packed, aligned (4096)));

struct pg_pt
{
    struct pg_pt_entry entries[PG_PT_ENTRY_COUNT];
} __attribute__ ((packed, aligned (4096)));

#endif /* KERNEL_PG_H */
