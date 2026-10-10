#include "acpi.h"
#include "init/boot.h"
#include "stddef.h"
#include "stdio.h"
#include "utils/string.h"

struct acpi_xsdp *
acpi_try_get_xsdp (const struct boot_params *kargs)
{
    struct acpi_rsdp_region
    {
        void *base;
        size_t len;
    };

    struct acpi_rsdp_region regions[] = {
        { .base = (void *) (((uint64_t) kargs->bios_ebda_loc) << 4),
          .len = 1024 },
        { .base = (void *) 0x000E0000, .len = 0x1FFFF },
    };

    for (int i = 0; i < sizeof (regions) / sizeof (regions[0]); i++)
    {
        volatile char *ptr = (char *) regions[i].base;
        kprintf ("ptr=%p\n", (void *) ptr);

        for (size_t j = 0; j + 8 < regions[i].len; j += 16)
        {
            if (!memcmp ((void *) (ptr + j), "RSD PTR ", 8))
            {
                kprintf ("acpi: possible rsd ptr found at: %p\n", ptr + j);
                const struct acpi_xsdp *xsdp = (struct acpi_xsdp *) (ptr + j);
                char str[7] = {0};
                memcpy(str, xsdp->oemid, 6);

                kprintf("OEM: %s\n", xsdp->oemid);
            }
        }
    }

    return NULL;
}
