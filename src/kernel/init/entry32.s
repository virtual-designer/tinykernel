.code16
.section .text.boot, "ax", @progbits

.extern kmain

.globl _start
_start:
    .byte 0xde
    .byte 0xad
    .byte 0xbe
    .byte 0xef
    movl $stack_top, %esp
    // cli
    hlt

.bss
.align 4
.skip (1024 * 128)
stack_top:
