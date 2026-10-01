#include "boot.h"
#include "stddef.h"
#include "stdio/stdio.h"
#include "utils/debug.h"
#include "utils/utils.h"
#include "e820.h"

void
kmain (struct boot_params *kargs)
{
    stdio_init ();
    kprintf ("TinyKernel version 1.0.0 -- Booting\n");

    if (kargs->signature != KLOADER_SIGNATURE)
        panic ("Boot signature mismatch: Error occurred during "
               "bootloader-to-kernel handoff\n");

    e820_init (kargs->e820);
    halt ();
}
