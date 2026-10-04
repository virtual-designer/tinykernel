#include <kernel/init/boot.h>

.macro halt
100:
    hlt
    jmp 100b
.endm

.code16
.text

RM16_STACK_TOP = 0x5000

.globl _start_stage2
_start_stage2:
    # Read first argument (struct boot_params *)
    movl 4(%esp), %ebx
    movl %ebx, boot_params_ptr
    movb 5(%ebx), %dl
    movb %dl, boot_drive_id
    movl $RM16_STACK_TOP, %esp

    # Disable NMI and enable A20 gate
    cld
    call nmi_disable
    call a20_enable

    # Load GDT
    cli
    leal gdtr, %eax
    lgdtl (%eax)

    # Enable PR flag
    movl %cr0, %eax
    orl $0x01, %eax
    movl %eax, %cr0

    ljmpl $0x08, $1f
.code32
1:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    movl $stack_top, %esp
    
    sti
    call stage2_main

.code16
boot_params_ptr:
    .long 0

boot_drive_id:
    .byte 0

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
    testb $1, %al
    jz a20_wait_write
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

.align 4
read_kernel_dpkt:
    .byte 0x10
    .byte 0x00
    .word 0x20
    .long 0x00000000
    .quad 0x07

.code16
.type read_kernel_from_disk, @function
read_kernel_from_disk:
    movb %bl, %al
    call putc
    ret

.code32
call_rm16_esp:
    .long 0

.type call_rm16, @function
call_rm16:
    cli
    movl %esp, call_rm16_esp
    movl 4(%esp), %edx
    
    leaw gdtr16, %si
    lgdtw (%si)

    ljmpl $0x08, $1f
.code16
1:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    movl $RM16_STACK_TOP, %esp

    movl %cr0, %eax
    andl $~0x01, %eax
    movl %eax, %cr0

    ljmpw $0x00, $2f
2:
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    movl $RM16_STACK_TOP, %esp

3:
    call *%dx

4:
    leal gdtr, %eax
    lgdtl (%eax)

    movl %cr0, %eax
    orl $0x01, %eax
    movl %eax, %cr0

    ljmpl $0x08, $6f
.code32
6:
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    movl call_rm16_esp, %esp
    ret

#include "common.S"

.code32
.type stage2_main, @function
stage2_main:
    cli

    movb $'H', %bl
    pushw $0
    pushw $read_kernel_from_disk
    call call_rm16

    movb $'i', %bl
    pushw $0
    pushw $read_kernel_from_disk
    call call_rm16

    movb $'!', %bl
    pushl $read_kernel_from_disk
    call call_rm16
    
1:
    hlt
    jmp 1b

.data
.align 4
kernel_exec_err_msg:
    .string "kexec: general error\r\n"

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

.align 8
gdt16:
    .quad 0x00

    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0b10011010
    .byte 0b00000000
    .byte 0x00
    
    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0b10010010
    .byte 0b00000000
    .byte 0x00
gdt16_end:

.align 8
gdtr16:
    .word (gdt16_end - gdt16 - 1)
    .long gdt16

.bss
.align 4
.skip (8 * 1024)
stack_top:

