#include <kernel/utils/macros.s>

.extern idtr
.extern isr_handler_invoke

.code64
.text

.globl isr_main
.type isr_main, @function
.align 8
isr_main:
    pushaq
    cld
    movl %eax, %edi
    call isr_handler_invoke
    popaq
    iretq

.globl idt_load
.type idt_load, @function
idt_load:
    leaq idtr, %rdi
    lidt (%rdi)
    xorb %al, %al
    leaq idt_loaded_str, %rdi
    call kprintf
    ret

.section rodata, "a", @progbits
idt_loaded_str:
    .string "isr: interrupt handlers registered\n"

