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

.globl save_registers
.type save_registers, @function
save_registers:
    movq %rdi, %rdx
    pushaq
    movq %rsp, %rbp
    addq $REG_SAVE_SIZE, %rbp
    movq %rsp, %rsi
    movq $REG_SAVE_SIZE, %rcx
1:
    lodsb
    stosb
    loop 1b

    movq $REG_SAVE_SIZE, %rcx

    # %rip
    movq (%rbp), %rax
    movq %rax, (%rdx, %rcx)
    addq $8, %rcx

    # %rflags
    pushfq
    popq %rax
    movq %rax, (%rdx, %rcx)
    addq $8, %rcx

    # %cs
    movw %cs, %ax
    movw %ax, (%rdx, %rcx)
    addq $2, %rcx

    # %ds
    movw %ds, %ax
    movw %ax, (%rdx, %rcx)
    addq $2, %rcx

    # %es
    movw %es, %ax
    movw %ax, (%rdx, %rcx)
    addq $2, %rcx

    # %fs
    movw %fs, %ax
    movw %ax, (%rdx, %rcx)
    addq $2, %rcx

    # %gs
    movw %gs, %ax
    movw %ax, (%rdx, %rcx)
    addq $2, %rcx

    # %ss
    movw %ss, %ax
    movw %ax, (%rdx, %rcx)
    addq $2, %rcx
    
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
    .fill REG_SAVE_FULL_SIZE
