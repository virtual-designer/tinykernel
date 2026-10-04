#include <kernel/init/boot.h>

.extern putc
.extern puts

STAGE2_LOAD_ADDR = 0x1000

.code16
.section .text.boot, "ax", @progbits

.globl _start
_start:
    movw $0x8000, %ax
    movw %ax, %sp
    xorw %ax, %ax
    movw %ax, %bp
    movw $0x00, %ax
    movw %ax, %ds
    movw %ax, %es

    movb %dl, boot_drive_id
    
    call probe_mem
    leal e820_mem_table_ptr, %edi
    movl %eax, (%edi)
    movw %bp, 4(%edi)
    movw %si, 6(%edi)
    call stage2_exec

.type stage2_exec, @function
stage2_exec:
    # Verify BIOS Extended Mode
    movb $0x41, %ah
    movw $0x55AA, %bx
    movb boot_drive_id, %dl
    int $0x13
    jc 2f
    cmpw $0xAA55, %bx
    jne 2f
    testw $1, %cx
    jz 2f

    leaw read_stage2_bios_extended_msg, %si
    call puts
    
    leaw read_stage2_dpkt, %si
    movl $STAGE2_LOAD_ADDR, %eax
    movl %eax, 4(%si)

    leaw read_stage2_dpkt, %si
    movb $0x42, %ah
    movb boot_drive_id, %dl
    int $0x13
    jc 3f
    test %ah, %ah
    jnz 3f

    leaw read_stage2_dpkt, %si
    movl 4(%si), %eax
    movw %cs, %bx
    pushw %bx
    pushw %ax
    movl %esp, %eax

    leal boot_params, %edi
    movb $KLOADER_STAGE1_SIGNATURE, 4(%edi)
    movb boot_drive_id, %dl
    movb %dl, 5(%edi)
    
    pushl %edi
    lcallw *(%eax)
    leaw exec_stage2_errmsg, %si
    call puts
    jmp 1f

2:
    leaw read_stage2_read_errmsg, %si
    call puts
    jmp 1f
3:
    leaw read_stage2_read_errmsg, %si
    call puts
1:
    hlt
    jmp 1b

#include "common.S"

/* %esi - entry count
   %ebp - total size
   %eax - the beginning pointer */

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
1:
    hlt
    jmp 1b

.align 2
exec_stage2_errmsg:
    .string "exec2 failure: returned to stage1 loader\r\n"

.align 2
read_stage2_read_errmsg:
    .string "exec2 failure: disk read failed\r\n"

.align 2
read_stage2_bios_extended_msg:
    .string "BIOS supports extended mode\r\n"

.align 2
probe_mem_errmsg:
    .string "Memory probe failed\r\n"

.align 2
e820_mem_table_ptr:
    .long 0
    .word 0
    .word 0

.align 2
boot_params:
    .long e820_mem_table_ptr
    .byte 0x0
    .byte 0x0

.align 2
boot_drive_id:
    .byte 0

.align 4
read_stage2_dpkt:
    .byte 0x10
    .byte 0x00
    .word 0x06
    .long 0x00000000
    .quad 0x01
