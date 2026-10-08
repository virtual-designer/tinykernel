
.macro pushaq
    pushq %rax
    pushq %rcx
    pushq %rdx
    pushq %rbx
    pushq %rsp
    addq $(5 * 8), (%rsp)
    pushq %rbp
    pushq %rsi
    pushq %rdi
.endm

.macro popaq
    popq %rdi
    popq %rsi
    popq %rbp
    popq %rsp
    subq $(5 * 8), %rsp
    popq %rbx
    popq %rdx
    popq %rcx
    popq %rax
.endm
