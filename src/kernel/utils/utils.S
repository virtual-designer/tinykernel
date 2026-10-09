#include <kernel/utils/macros.s>

.code64
.text

.globl shutdown
.type shutdown, @function
shutdown:
    movw $0x604, %dx
    movw $0x2000, %ax
    outw %ax, %dx
1:
    hlt
    jmp 1b

.globl halt
.type halt, @function
halt:
1:
    hlt
    jmp 1b

.globl outb
.type outb, @function
outb:
    movw %di, %dx
    movw %si, %ax
    outb %al, %dx
    ret

.globl inb
.type inb, @function
inb:
    movw %di, %dx
    inb %dx, %al
    ret

.globl cpu_relax
cpu_relax:
    pause
    ret

.globl save_registers
.type save_registers, @function
save_registers:
    movq %rdi, %rdx
    pushaq
    movq %rsp, %rbp
    addq $64, %rbp
    movq %rsp, %rsi
    movq $64, %rcx
1:
    lodsb
    stosb
    loop 1b

    # %rip
    movq (%rbp), %rax
    movq %rax, 64(%rdx)

    # %rflags
    pushfq
    popq %rax
    movq %rax, 72(%rdx)

    # %cs
    movw %cs, %ax
    movw %ax, 80(%rdx)

    # %ds
    movw %ds, %ax
    movw %ax, 82(%rdx)

    # %es
    movw %es, %ax
    movw %ax, 84(%rdx)

    # %fs
    movw %fs, %ax
    movw %ax, 86(%rdx)

    # %gs
    movw %gs, %ax
    movw %ax, 88(%rdx)

    # %ss
    movw %ss, %ax
    movw %ax, 90(%rdx)
    
    popaq
    ret

.extern panic_message_kprintf
.extern print_registers

.globl panic
.type panic, @function
panic:
    addq $4, %rsp
    pushaq
    leaq panic_reg_state, %rdi
    call save_registers
    leaq panic_reg_state, %rbx
    movq %rsp, %rax
    movq %rax, 24(%rbx)
    popaq
    call panic_message_kprintf
    leaq panic_reg_state, %rdi
    call print_registers
    call halt

.data
panic_reg_state:
    .fill 92
