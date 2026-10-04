ENTRY(_start)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS
{
    . = 0x7c00;

    .text : ALIGN(2)
    {
        *(.text.boot*)
        ASSERT(. <= 0x1fe, "boot sector is too large");
        . = 0x1fe;
        BYTE(0x55);
        BYTE(0xAA);
    }

    .data : ALIGN(2)
    {
        *(.data*)
    }

    .rodata : ALIGN(2)
    {
        *(.rodata*)
    }

    .bss : ALIGN(4)
    {
        *(COMMON)
        *(.bss*)
    }

    /DISCARD/ : { 
        *(.comment) 
        *(.note*) 
        *(.eh_frame*) 
    }
}