#include "acpi.h"
#include "stddef.h"
#include "stdio.h"
#include "utils/string.h"

struct acpi_xsdp *
acpi_try_get_xsdp (const struct e820_table *table)
{
    for (uint16_t i = 0; i < table->entry_count; i++)
    {
        if (table->entries[i].type != MEM_RESV)
            continue;

        char *ptr = (char *) table->entries[i].base;

        for (size_t i = 0; i < table->entries[i].length; i += 8)
        {
            if (!memcmp (ptr + i, "RSD PTR", 7))
                kprintf ("acpi: rsd ptr found at: %p\n", ptr + i);
        }
    }

    return NULL;
}
