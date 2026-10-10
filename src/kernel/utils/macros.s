REG_SAVE_COUNT = 16
REG_SAVE_SIZE = REG_SAVE_COUNT * 8
REG_SAVE_FULL_SIZE = REG_SAVE_SIZE + (8 * 2) + (2 * 6)

.macro pushaq
    pushq %r8
    pushq %r9
    pushq %r10
    pushq %r11
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15
    pushq %rax
    pushq %rcx
    pushq %rdx
    pushq %rbx
    pushq %rsp
    addq $(13 * 8), (%rsp)
    pushq %rbp
    pushq %rsi
    pushq %rdi
.endm

.macro popaq
    popq %rdi
    popq %rsi
    popq %rbp
    popq %rsp
    subq $(13 * 8), %rsp
    popq %rbx
    popq %rdx
    popq %rcx
    popq %rax
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    popq %r11
    popq %r10
    popq %r9
    popq %r8
.endm
