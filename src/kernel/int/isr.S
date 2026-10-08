#include <kernel/utils/macros.s>

.extern idt_handlers
.extern idtr

.code64
.text

.globl isr_entry_0x00
.type isr_entry_0x00, @function
isr_entry_0x00:
    pushaq
    cld
    leaq idt_handlers, %rdi
    movq (%rdi), %rsi
    callq *%rsi
    popaq
    iretq

.globl idt_load
.type idt_load, @function
idt_load:
    leaq idtr, %rdi
    lidt (%rdi)
    ret

str:
    .string "Handling interrupt"
