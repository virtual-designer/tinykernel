.code32
.section .text.boot, "ax", @progbits

.extern kmain

.globl _start
_start:    
    movl $stack_top, %esp

    /* %esi holds the (struct boot_params *) pointer,
       passed by loader2 during handoff. */
    push %esi
    call kmain

    cli
1:
    hlt
    jmp 1b

.bss
.align 4
.skip (1024 * 128)
stack_top:
