#ifndef KERNEL_BOOT_H
#define KERNEL_BOOT_H

#define KLOADER_STAGE1_SIGNATURE 0x41
#define KLOADER_STAGE2_SIGNATURE 0x3C
#define KLOADER_SIGNATURE KLOADER_STAGE2_SIGNATURE
#define MEM_PROBE_ADDR 0x7f00
#define MEM_SMAP_SIGNATURE 0x534D4150

#ifndef __ASM__
    #include "stdint.h"
    #include "compiler.h"

struct boot_params
{
    struct e820_table *e820_table;
    uint8_t signature;
    uint8_t bios_boot_disk;
    uint16_t bios_ebda_loc;
} __attribute__ ((packed));
#endif /* __ASM__ */

#endif /* KERNEL_BOOT_H */
