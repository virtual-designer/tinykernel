#include "boot.h"
#include "e820.h"
#include "stddef.h"
#include "stdio/stdio.h"
#include "utils/debug.h"
#include "utils/utils.h"

static void
print_boot_info (const struct boot_params *kargs)
{
    kprintf ("\nBoot Information:\n");
    kprintf ("  BIOS Boot Disk:   0x%x\n", kargs->bios_boot_disk);
    kprintf ("  Loader signature: 0x%x\n", kargs->signature);
    kprintf ("\n");
}

void
kmain (const struct boot_params *kargs)
{
    stdio_init ();
    kprintf ("TinyKernel version 1.0.0 -- Booting\n");

    if (kargs->signature != KLOADER_SIGNATURE)
        panic ("Boot signature mismatch: 0x%x: Error occurred during "
               "bootloader-to-kernel handoff\n",
               kargs->signature);

    print_boot_info (kargs);
    e820_init (kargs->e820);
    halt ();
}
