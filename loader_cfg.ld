ENTRY(_start)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS
{
    . = 0x7c00;

    .text : 
    {
        *(.text*)
    }

    .data : 
    {
        *(.data*)
    }

    /DISCARD/ : { 
        *(.comment) 
        *(.note*) 
        *(.eh_frame*) 
    }
}
