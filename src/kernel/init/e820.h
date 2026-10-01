#ifndef KERNEL_E820_H
#define KERNEL_E820_H

#include "stdint.h"

struct e820_entry
{
    uint64_t base;
    uint64_t length;
    uint32_t type;
} __attribute__ ((packed));

struct e820_table
{
    struct e820_entry *entries;
    uint16_t size;
    uint16_t entry_count;
} __attribute__ ((packed));

enum e820_entry_type
{
    MEM_USABLE = 1,
    MEM_RESV,
    MEM_ACPI_RECLAIMABLE,
    MEM_ACPI_NVS,
    MEM_BAD
};

void e820_init (const struct e820_table *table);

#endif /* KERNEL_E820_H */
