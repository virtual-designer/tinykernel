#ifndef KERNEL_UTILS_H
#define KERNEL_UTILS_H

#include "stdint.h"
#include "compiler.h"

struct register_state
{
    uint64_t rdi, rsi;
    uint64_t rbp, rsp;
    uint64_t rbx, rdx, rcx, rax;
    uint64_t rip;
    uint64_t rflags;
    uint16_t cs, ds, es, fs, gs, ss;
} __attribute__ ((packed));

_Noreturn void shutdown (void);
_Noreturn void __attribute__((format(printf, 1, 2))) panic (const char *format, ...);
_Noreturn void halt (void);
void outb (uint16_t port, uint8_t value);
void save_registers (struct register_state *out);

#endif /* KERNEL_UTILS_H */
