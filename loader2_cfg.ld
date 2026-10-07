ENTRY(_start)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386:x86-64)

SECTIONS
{
    . = 0x1000;

    .text : ALIGN(8)
    {
        __STAGE2_LOAD_ADDR = .;
        *(.text*)
        ASSERT(ABSOLUTE(.) < 0x7c00, "Code segment is too large");
    }

    .data : ALIGN(8)
    {
        *(.data*)
    }

    .rodata : ALIGN(8)
    {
        *(.rodata*)
    }

    __IMAGE_FILE_END = ABSOLUTE(.);
    __STAGE2_SECTORS = (__IMAGE_FILE_END - __STAGE2_LOAD_ADDR + 511) / 512;

    .bss : ALIGN(8)
    {
        *(COMMON)
        *(.bss*)
    }

    .pml4 : ALIGN(4096)
    {   
        *(.pml4*)
    }

    __IMAGE_END = ABSOLUTE(.);
    ASSERT(__IMAGE_END < 0x7c00, "stage2 image must end below 0x7c00")

    /DISCARD/ : { 
        *(.comment) 
        *(.note*) 
        *(.eh_frame*) 
    }
}
