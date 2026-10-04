ENTRY(_start)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS
{
    . = 0x1000;

    .text : ALIGN(2)
    {
        __STAGE2_LOAD_ADDR = .;
        *(.text*)
        ASSERT(ABSOLUTE(.) < 0x10000, "Code segment is too large");
    }

    .data : ALIGN(2)
    {
        *(.data*)
    }

    .rodata : ALIGN(2)
    {
        *(.rodata*)
    }

    __IMAGE_FILE_END = ABSOLUTE(.);
    __STAGE2_SECTORS = (__IMAGE_FILE_END - __STAGE2_LOAD_ADDR + 511) / 512;

    .bss : ALIGN(4)
    {
        *(COMMON)
        *(.bss*)
    }

    __IMAGE_END = ABSOLUTE(.);
    ASSERT(__IMAGE_END <= 0x10000, "stage2 image must end below 0x10000")

    /DISCARD/ : { 
        *(.comment) 
        *(.note*) 
        *(.eh_frame*) 
    }
}
