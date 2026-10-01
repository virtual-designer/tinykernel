#ifndef KERNEL_BOOT_H
#define KERNEL_BOOT_H

#define KLOADER_SIGNATURE 0x3C

#ifndef __ASM__
    #include "stdint.h"

struct boot_params
{
    struct e820_table *e820;
    uint8_t signature;
} __attribute__ ((packed));
#endif /* __ASM__ */

#endif /* KERNEL_BOOT_H */
