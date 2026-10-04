#include "e820.h"
#include "stdio.h"

static const char *e820_type_lut[] = {
    [MEM_USABLE] = "Usable Memory",
    [MEM_RESV] = "Firmware Reserved Memory",
    [MEM_ACPI_RECLAIMABLE] = "ACPI Reclaimable Memory",
    [MEM_ACPI_NVS] = "ACPI NVS Memory",
    [MEM_BAD] = "Bad Memory Region",
};

void
e820_init (const struct e820_table *table)
{
    const uint16_t entry_size = table->size / table->entry_count;

    kprintf ("e820: probing system memory information\n");
    kprintf ("e820: ptr=%p, size=%hu, count=%hu, entry_size=%hu\n",
             table->entries, table->size, table->entry_count, entry_size);

    for (uint16_t i = 0; i < table->entry_count; i++)
    {
        const struct e820_entry *entry = &table->entries[i];

        if (!entry->length)
            continue;

        const char *type_str = e820_type_lut[entry->type];
        kprintf ("e820: #%hu: [0x%0llx-0x%0llx]: %s [%u]\n", i, entry->base,
                 entry->base + entry->length, type_str, entry->type);
    }
}
