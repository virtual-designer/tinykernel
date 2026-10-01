#include <kernel/init/boot.h>

.code16
.text

.globl _start
_start:
    movw $0x8000, %ax
    movw %ax, %sp
    xorw %ax, %ax
    movw %ax, %bp
    movw $0x00, %ax
    movw %ax, %ds
    movw %ax, %es
    
    call probe_mem
    leal e820_mem_table_ptr, %edi
    movl %eax, (%edi)
    movw %bp, 4(%edi)
    movw %si, 6(%edi)
    call kernel_exec

.type kernel_exec, @function
kernel_exec:
    # Verify BIOS Extended Mode
    movb $0x41, %ah
    movw $0x55AA, %bx
    movb $0x80, %dl
    int $0x13
    jc 2f
    cmpw $0xAA55, %bx
    jne 2f
    testw $1, %cx
    jz 2f

    leaw read_kernel_bios_extended_msg, %si
    call puts

    leaw read_kernel_dpkt, %si
    movb $0x42, %ah
    movb $0x80, %dl
    int $0x13
    jc 3f
    test %ah, %ah
    jnz 3f

    leaw read_kernel_dpkt, %si
    movl 4(%si), %eax
    movw %cs, %bx
    pushw %bx
    pushw %ax
    movl %esp, %eax
    leal boot_params, %edi
    pushl %edi
    movb $KLOADER_SIGNATURE, 4(%edi)
    lcallw *(%eax)
    leaw exec_kernel_errmsg, %si
    call puts
    jmp 1f

2:
    leaw read_kernel_bios_errmsg, %si
    call puts
    jmp 1f
3:
    leaw read_kernel_read_errmsg, %si
    call puts
1:
    hlt
    jmp 1b

.align 4
read_kernel_dpkt:
    .byte 0x10
    .byte 0x00
    .word 0x20
    .long 0x00008000
    .quad 0x01

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

/* %esi - entry count
   %ebp - total size
   %eax - the beginning pointer */
MEM_PROBE_ADDR = 0x7f00
MEM_SMAP_SIGNATURE = 0x534D4150

.type probe_mem, @function
probe_mem:
    xorl %ebx, %ebx
    xorl %ebp, %ebp
    xorl %esi, %esi
    xorl %edi, %edi
    pushw %es
    pushw %ds
    movw %bx, %es
    movw %bx, %ds
    movl $MEM_PROBE_ADDR, %edi

    pushl %edi
    pushl %esi
    pushl %ebp
1:
    movl $0xE820, %eax
    movl $20, %ecx
    movl $MEM_SMAP_SIGNATURE, %edx
    int $0x15

    jc .probe_mem_err
    cmpl $MEM_SMAP_SIGNATURE, %eax
    jne .probe_mem_err
    testl %ecx, %ecx
    jz 1b

    popl %ebp
    popl %esi
    popl %edi

    addl %ecx, %edi
    addl %ecx, %ebp
    incl %esi
    
    pushl %edi
    pushl %esi
    pushl %ebp
    
    testl %ebx, %ebx
    jz .probe_mem_ret
    jmp 1b

.probe_mem_ret:
    popl %ebp
    popl %esi
    popl %eax
    subl %ebp, %eax
    popw %ds
    popw %es
    ret
    
.probe_mem_err:
    addl $12, %esp
    popw %ds
    popw %es
    xorl %eax, %eax
    xorl %ebp, %ebp
    xorl %esi, %esi
    lea probe_mem_errmsg, %si
    call puts


    cli
    hlt
    
    ret

.align 2
exec_kernel_errmsg:
    .string "Kernel exec failure: Returned to loader"

.align 2
read_kernel_read_errmsg:
    .string "Disk read failure"

.align 2
read_kernel_read_done_msg:
    .string "Disk read successful"

.align 2
read_kernel_bios_errmsg:
    .string "BIOS doesn't support extended mode"

.align 2
read_kernel_bios_extended_msg:
    .string "BIOS supports extended mode"

.align 2
probe_mem_errmsg:
    .string "Memory probe failed"

.align 2
e820_mem_table_ptr:
    .long 0
    .word 0
    .word 0

.align 2
boot_params:
    .long e820_mem_table_ptr
    .byte 0x0

proglen = . - _start
.fill 510 - proglen
.byte 0x55
.byte 0xAA
