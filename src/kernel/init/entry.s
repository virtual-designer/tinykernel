.code16
.section .text.boot, "ax", @progbits

.extern kmain

.globl _start
_start:
    movl 4(%esp), %ebx

    # Switch to 16-bit protected mode
    cld
    call nmi_disable
    call a20_enable
    
    cli
    xorl %eax, %eax
    leal gdtr, %eax
    lgdtl (%eax)

    movl %cr0, %eax
    orl $0x01, %eax
    mov %eax, %cr0

    ljmpl $0x08, $enter32

.code32
enter32:
    cld
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    movl $stack_top, %esp
    pushl %ebx
    call kmain
1:
    hlt
    jmp 1b

.code16
.type a20_enable, @function
a20_enable:
    cli
    cld

    call a20_wait_clear
    movb $0xAD, %al
    outb %al, $0x64

    call a20_wait_clear
    movb $0xD0, %al
    outb %al, $0x64

    call a20_wait_write
    inb $0x60, %al
    pushl %eax

    call a20_wait_clear
    movb $0xD1, %al
    outb %al, $0x64

    call a20_wait_clear
    popl %eax
    orb $2, %al
    outb %al, $0x60
    
    call a20_wait_clear
    movb $0xAE, %al
    outb %al, $0x64

    call a20_wait_clear

    sti
    ret

.type a20_wait_clear, @function
a20_wait_clear:
    inb $0x64, %al
    testb $2, %al
    jnz a20_wait_clear
    ret

.type a20_wait_write, @function
a20_wait_write:
    inb $0x64, %al
    testb $2, %al
    jz a20_wait_clear
    ret

.type nmi_enable, @function
nmi_enable:
    cli
    inb $0x70, %al
    andb $0x7f, %al
    outb %al, $0x70
    inb $0x71, %al
    sti
    ret

.type nmi_disable, @function
nmi_disable:
    cli
    inb $0x70, %al
    orb $0x80, %al
    outb %al, $0x70
    inb $0x71, %al
    sti
    ret

.type putc, @function
putc:
    movb $0x0E, %ah
    xorw %bx, %bx
    int $0x10
    ret

.type puts, @function
puts:
1:
    lodsb
    testb %al, %al
    jz 2f
    call putc
    jmp 1b
2:
    ret

.align 8
gdt:
    .quad 0x00
    
    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x00
    
    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x00
gdt_end:

.align 8
gdtr:
    .word (gdt_end - gdt - 1)
    .long gdt

.bss
.align 4
.skip (1024 * 128)
stack_top:
