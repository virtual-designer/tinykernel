.code32
.text

.globl fpu_init
.type fpu_init, @function
fpu_init:
    # Clear CR0.EM and CR0.TS
    movl %cr0, %eax
    andl $~0x0C, %eax
    movl %eax, %cr0

    # Test the FPU
    fninit
    fnstsw fpu_test_word
    movw fpu_test_word, %bx
    testw %bx, %bx
    jnz 2f
1:
    # Set CR0.NE and CR0.MP
    movl %cr0, %eax
    orl $0b100010, %eax
    movl %eax, %cr0

    # Set CR4.OSFXSR (SSE enable), CR4.OSXMMEXCPT, CR4.OSXSAVE
    movl %cr4, %eax
    orl $0b1000000011000000000, %eax
    movl %eax, %cr4

    # Initialize the FPU
    fninit
    pushl $0x37f
    fldcw (%esp)
    movl $0x37e, (%esp)
    fldcw (%esp)
    movl $0x37a, (%esp)
    fldcw (%esp)
    addl $4, %esp

    xorl %eax, %eax
    ret
2:
    movzx %bx, %eax
    ret

.data
.align 4
fpu_test_word:
    .word 0xbade
