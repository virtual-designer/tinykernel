.code16
.type putc16, @function
putc16:
    movb $0x0E, %ah
    xorw %bx, %bx
    int $0x10
    ret

.type puts16, @function
puts16:
1:
    lodsb
    testb %al, %al
    jz 2f
    call putc16
    jmp 1b
2:
    ret

.type shutdown16, @function
shutdown16:
    movw $0x604, %dx
    movw $0x2000, %ax
    outw %ax, %dx
1:
    hlt
    jmp 1b
