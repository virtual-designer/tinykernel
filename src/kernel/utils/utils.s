.code32
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
    movl 4(%esp), %edx
    movl 8(%esp), %eax
    outb %al, %dx
    ret

.globl save_registers
.type save_registers, @function
save_registers:
    pushal
    movl 36(%esp), %edi
    leal (%esp), %esi
    movl $32, %ecx
1:
    lodsb
    stosb
    loop 1b

    movl 36(%esp), %edi

    # %eip
    movl 32(%esp), %eax
    movl %eax, 32(%edi)

    # %eflags
    pushfl
    popl %eax
    movl %eax, 36(%edi)

    # %cs
    movw %cs, %ax
    movw %ax, 40(%edi)

    # %ds
    movw %ds, %ax
    movw %ax, 42(%edi)

    # %es
    movw %es, %ax
    movw %ax, 44(%edi)

    # %fs
    movw %fs, %ax
    movw %ax, 46(%edi)

    # %gs
    movw %gs, %ax
    movw %ax, 48(%edi)

    # %ss
    movw %ss, %ax
    movw %ax, 50(%edi)
    
    popal
    ret

.extern panic_message_kprintf
.extern print_registers

.globl panic
.type panic, @function
panic:
    addl $4, %esp
    pushl panic_reg_state
    call save_registers
    popl %ebx
    movl %esp, %eax
    movl %eax, 12(%ebx)
    call panic_message_kprintf
    pushl %ebx
    call print_registers
    call halt

.data
panic_reg_state:
    .fill 52
