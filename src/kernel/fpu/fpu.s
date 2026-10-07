.code64
.text

.globl fpu_init
.type fpu_init, @function
fpu_init:
    # Clear CR0.EM and CR0.TS
    movq %cr0, %rax
    andq $~0x0C, %rax
    movq %rax, %cr0

    # Test the FPU
    fninit
    fnstsw fpu_test_word
    movw fpu_test_word, %bx
    testw %bx, %bx
    jnz 2f
1:
    # Set CR0.NE and CR0.MP
    movq %cr0, %rax
    orq $0b100010, %rax
    movq %rax, %cr0

    # Set CR4.OSFXSR (SSE enable), CR4.OSXMMEXCPT, CR4.OSXSAVE
    movq %cr4, %rax
    orq $0b1000000011000000000, %rax
    movq %rax, %cr4

    # Initialize the FPU
    fninit
    subq $8, %rsp
    movl $0x37f, (%rsp)
    fldcw (%rsp)
    movl $0x37e, (%rsp)
    fldcw (%rsp)
    movl $0x37a, (%rsp)
    fldcw (%rsp)
    addq $8, %rsp

    xorl %eax, %eax
    ret
2:
    movzx %bx, %eax
    ret

.data
.align 8
fpu_test_word:
    .word 0xbade
