#include "acpi.h"
#include "init/boot.h"
#include "stdbool.h"
#include "stddef.h"
#include "stdio.h"
#include "utils/string.h"

const struct acpi_rsdp *
acpi_try_get_rsdp (const struct boot_params *kargs)
{
    struct acpi_rsdp_region
    {
        void *base;
        size_t len;
    };

    const struct acpi_rsdp_region regions[] = {
        { .base = (void *) (((uint64_t) kargs->bios_ebda_addr) << 4),
          .len = 1024 },
        { .base = (void *) 0x000E0000, .len = 0x1FFFF },
    };

    for (int i = 0; i < sizeof (regions) / sizeof (regions[0]); i++)
    {
        char *ptr = (char *) regions[i].base;
        kprintf ("ptr=%p\n", (void *) ptr);

        for (size_t j = 0; j + 8 < regions[i].len; j += 16)
        {
            if (!memcmp ((void *) (ptr + j), "RSD PTR ", 8))
            {
                const struct acpi_rsdp *rsdp = (struct acpi_rsdp *) (ptr + j);
                const struct acpi_xsdp *xsdp = (struct acpi_xsdp *) (ptr + j);
                const bool is_acpi_v2 = rsdp->revision == 2;

                kprintf ("acpi: possible RSDP found at: addr=%p, rev=%u\n",
                         rsdp, rsdp->revision);

                uint8_t sum = 0;
                size_t length = is_acpi_v2 ? xsdp->length : sizeof (*rsdp);

                for (size_t k = 0; k < length; k++)
                    sum += ((uint8_t *) xsdp)[k];

                if (sum)
                    kprintf ("acpi: RSDP checksum mismatch: addr=%p, sum=%u\n",
                             rsdp, sum);

                kprintf ("acpi: RSDP discovered: addr=%p\n", rsdp);
                kprintf ("acpi: RSDT discovered: addr=%p\n",
                         (void *) (size_t) rsdp->rsdt_addr);

                return rsdp;
            }
        }
    }

    return NULL;
}
