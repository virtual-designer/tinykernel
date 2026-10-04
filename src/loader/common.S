.code16
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

.type shutdown, @function
shutdown:
    movw $0x604, %dx
    movw $0x2000, %ax
    outw %ax, %dx
1:
    hlt
    jmp 1b
