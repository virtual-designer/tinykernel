ENTRY(_start)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS
{
    . = 0x100000;

    .text : ALIGN(4)
    {
        *(.text.boot*)
        *(.text*)
    }

    .data : ALIGN(4)
    {
        *(.data*)
    }

    .rodata : ALIGN(4)
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
