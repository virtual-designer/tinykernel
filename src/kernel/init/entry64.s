.code64
.section .text.boot, "ax", @progbits

.extern kmain

BOOT_PARAMS_SIZE = 12

.globl _start
_start:
    cld
    movq $stack_top, %rsp

    /* %rsi holds the (struct boot_params *) pointer,
       passed by loader2 during handoff. */
    movq %rsi, %rdi
    call kmain

    cli
1:
    hlt
    jmp 1b

.section .stack, "aw", @nobits
.align 16
.skip (1024 * 1024 * 2)
stack_top:
