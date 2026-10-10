#include <kernel/init/boot.h>

.macro halt
100:
    hlt
    jmp 100b
.endm

.code16
.text

RM16_STACK_TOP = 0x5000

.globl _start
_start:
    # Read and set members of first argument (struct boot_params *)
    movl 4(%esp), %ebx
    movl %ebx, boot_params_ptr
    movb 9(%ebx), %dl
    movb %dl, boot_drive_id

    # Read BIOS EBDA addesss
    movl $0x40E, %ecx
    movw (%ecx), %ax
    movw %ax, 10(%ebx)

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
    movl $0x500000, %esp

    call stage2_main

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

.code64
.align 8
gdt64:
    .quad 0x00

    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0b10011010
    .byte 0b10101111
    .byte 0x00

    .word 0xffff
    .word 0x0000
    .byte 0x00
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x00
gdt64_end:

.align 8
gdtr64:
    .word (gdt64_end - gdt64 - 1)
    .quad gdt64

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

KERNEL_LOAD_ADDR = 0x100000
KERNEL_LOAD_SECTORS = 50
KERNEL_LOAD_LBA_START = 0x20

.align 4
read_kernel_dpkt:
    .byte 0x10
    .byte 0x00
    .word 0x01
    .long read_kernel_buffer
    .quad KERNEL_LOAD_LBA_START

.align 2
read_kernel_buffer:
    .fill 512

.align 2
read_kernel_errmsg:
    .string "kexec: disk I/O error\r\n"

.code16
.type read_kernel_from_disk, @function
read_kernel_from_disk:
    leaw read_kernel_dpkt, %si
    movb $0x42, %ah
    movb boot_drive_id, %dl
    int $0x13
    jc 1f
    test %ah, %ah
    jnz 1f
    xorw %bx, %bx
    ret

1:
    leaw read_kernel_errmsg, %si
    call puts16
    movw $-1, %bx
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
    xorl %ecx, %ecx

1:
    pushl %ecx

    pushw $0
    pushw $read_kernel_from_disk
    call call_rm16
    addl $4, %esp
    cmpw $0, %bx
    jne 2f
    
    popl %ecx
    
    leal read_kernel_buffer, %esi
    movl $KERNEL_LOAD_ADDR, %edi

    movl $512, %eax
    mull %ecx
    addl %eax, %edi

    cld
    pushl %ecx
    movl $512, %ecx
    rep movsb
    popl %ecx

    leal read_kernel_dpkt, %eax
    movl 8(%eax), %ebx
    incl %ebx
    movl %ebx, 8(%eax)

    incl %ecx
    cmpl $KERNEL_LOAD_SECTORS, %ecx
    jne 1b
    jmp 3f
2:
    halt
3:
    call enter_long_mode
    halt

CPUID_EXTENSIONS = 0x80000000
CPUID_EXTENDED_FEATURES = 0x80000001
CPUID_EDX_EXT_FEAT_LM = 1 << 29
MSR_EFER = 0xC0000080
MSR_EFER_LM_ENABLE = 1 << 8

.type enter_long_mode, @function
enter_long_mode:
    cli

    # Check whether cpuid supports extended features
    movl $CPUID_EXTENSIONS, %eax
    cpuid
    cmpl $CPUID_EXTENDED_FEATURES, %eax
    jb 2f

    # Check long mode support
    movl $CPUID_EXTENDED_FEATURES, %eax
    cpuid
    testl $CPUID_EDX_EXT_FEAT_LM, %edx
    jz 2f
    
1:
    leal long_mode_supported_str, %esi
    call puts

    # Build page tables
    call stage2_build_page_tables

    # Enable PAE
    movl %cr4, %eax
    orl $0x20, %eax
    movl %eax, %cr4
    
    # Load PML4
    leal stage2_pml4, %edi
    movl %edi, %cr3

    # Turn on long mode bit
    movl $MSR_EFER, %ecx
    rdmsr
    orl $MSR_EFER_LM_ENABLE, %eax
    wrmsr

    # Enable CR0.PG
    movl %cr0, %eax
    orl $(1 << 31), %eax
    movl %eax, %cr0

    # Load 64-bit GDT
    leal gdtr64, %eax
    lgdtl (%eax)

    # Long-jump to 64-bit code
    ljmpl $0x08, $3f

    halt
2:
    leal long_mode_not_supported_str, %esi
    call puts
    halt

.code64
3:
    # Now in long mode
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    
    jmp jump_to_kernel
    halt

jump_to_kernel:
    movq $KERNEL_LOAD_ADDR, %rdi
    xorq %rsi, %rsi
    movl boot_params_ptr, %esi
    movb $KLOADER_STAGE2_SIGNATURE, 8(%rsi)
    jmp *%rdi
    halt

.code32
.type stage2_build_page_tables, @function
stage2_build_page_tables:
    # Zero the page table region
    xorl %edx, %edx
    movl stage2_page_tables_size, %eax
    leal stage2_page_tables_begin, %edi
    xorl %eax, %eax
    rep stosb

    # Build PML4[0]
    leal stage2_pml4, %edi
    leal stage2_pdpt, %esi
    orl $0x03, %esi
    movl %esi, (%edi)
    movl $0, 4(%edi)

    # Build PDPT[0]
    leal stage2_pdpt, %edi
    leal stage2_pd, %esi
    orl $0x03, %esi
    movl %esi, (%edi)
    movl $0, 4(%edi)

    # Build PD[0]
    leal stage2_pd, %edi
    leal stage2_pt, %esi
    orl $0x03, %esi
    movl %esi, (%edi)
    movl $0, 4(%edi)

    # Build first PT for PD[0]
    leal stage2_pt, %edi
    addl $8, %edi
    movl $1, %ecx
1:
    # Multiply by PAGE_SIZE (4096)
    movl %ecx, %eax
    shll $12, %eax
    orl $0x03, %eax

    movl %eax, (%edi)
    movl $0, 4(%edi)
    
    incl %ecx
    addl $8, %edi
    cmpl $512, %ecx
    jb 1b

    # Build PD[1] to PD[7]
    leal stage2_pd, %edi
    addl $8, %edi
    movl $1, %ecx
2:
    movl %ecx, %eax
    shll $21, %eax
    orl $0x83, %eax

    movl %eax, (%edi)
    movl $0, 4(%edi)

    incl %ecx
    addl $8, %edi
    cmpl $8, %ecx
    jb 2b

    ret

.type shutdown, @function
shutdown:
    movw $0x604, %dx
    movw $0x2000, %ax
    outw %ax, %dx
    halt

.type puts_clear, @function
puts_clear:
    movb $0x07, %ah
    movb $' ', %al
    movl $0xb8000, %edi
    movl $(80 * 25), %ecx
1:
    movw %ax, (%edi)
    addl $2, %edi
    loop 1b
    ret

.type puts, @function
puts:
    call puts_clear
    movl $0xb8000, %edi
1:
    lodsb
    testb %al, %al
    jz 2f
    movb $0x07, %ah
    stosw
    jmp 1b
2:
    ret

.section .pml4, "aw", @nobits
.balign 4096
stage2_page_tables_begin:
stage2_pml4:
    .skip (512 * 8)

.balign 4096
stage2_pdpt:
    .skip (512 * 8)

.balign 4096
stage2_pd:
    .skip (512 * 8)

.balign 4096
stage2_pt:
    .skip (512 * 8)

stage2_page_tables_end:

.data
.align 8
long_mode_supported_str:
    .string "stage2: long mode is supported"

.align 8
long_mode_not_supported_str:
    .string "stage2: error: long mode is not supported; cannot boot"

.align 8
stage2_page_tables_size:
    .long (stage2_page_tables_end - stage2_page_tables_begin)

.bss
.code32
.align 8
.skip (2 * 1024)
stack_top:
