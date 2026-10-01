#ifndef KERNEL_UTILS_H
#define KERNEL_UTILS_H

#include "stdint.h"

struct register_state
{
    uint32_t edi, esi;
    uint32_t ebp, esp;
    uint32_t ebx, edx, ecx, eax;
    uint32_t eip;
    uint32_t eflags;
    uint16_t cs, ds, es, fs, gs, ss;
} __attribute__ ((packed));

void shutdown (void);
_Noreturn void halt (void);
void outb (uint16_t port, uint8_t value);
void save_registers (struct register_state *out);

#endif /* KERNEL_UTILS_H */
