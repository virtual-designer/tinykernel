#ifndef KERNEL_ACPI_H
#define KERNEL_ACPI_H

#include "init/boot.h"
#include "init/e820.h"
#include "stdint.h"

struct acpi_rsdp
{
    char signature[8];
    uint8_t checksum;
    char oemid[6];
    uint8_t revision;
    uint32_t rsdt_addr;
};

struct acpi_xsdp
{
    char signature[8];
    uint8_t checksum;
    char oemid[6];
    uint8_t revision;
    uint32_t rsdt_addr;

    uint32_t length;
    uint64_t xsdt_addr;
    uint8_t extended_checksum;
    uint8_t reserved[3];
} __attribute__ ((packed));

const struct acpi_rsdp *acpi_try_get_rsdp (const struct boot_params *kargs);

#endif /* KERNEL_ACPI_H */
