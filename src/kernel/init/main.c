#include "boot.h"
#include "e820.h"
#include "mm/mman.h"
#include "stddef.h"
#include "stdio/stdio.h"
#include "utils/debug.h"
#include "utils/string.h"
#include "utils/utils.h"

extern char __KERNEL_BSS_START[];
extern char __KERNEL_BSS_END[];

static void
print_boot_info (const struct boot_params *kargs)
{
    kprintf ("\nBoot Information:\n");
    kprintf ("  BIOS Boot Disk:   0x%x\n", kargs->bios_boot_disk);
    kprintf ("  Loader signature: 0x%x\n", kargs->signature);
    kprintf ("\n");
}

static void
mm_init (const struct boot_params *kargs)
{
    struct kmman *mm = kmman_init_with_e820_table (kargs->e820_table);

    if (!mm)
        panic ("Failed to initialize kernel memory manager\n");

    kprintf ("\n");
    kmman_print (mm);
}

void
kmain (const struct boot_params *kargs)
{
    /* Zero-initialize the .bss section. */
    memset ((void *) __KERNEL_BSS_START, 0,
            __KERNEL_BSS_END - __KERNEL_BSS_START);

    stdio_init ();
    kprintf ("TinyKernel version 1.0.0 -- Booting\n");

    if (kargs->signature != KLOADER_SIGNATURE)
        panic ("Boot signature mismatch: 0x%x: Error occurred during "
               "bootloader-to-kernel handoff\n",
               kargs->signature);

    print_boot_info (kargs);
    e820_init (kargs->e820_table);
    mm_init (kargs);
    halt ();
}
