ENTRY(_start)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS
{
    __KERNEL_LOAD_ADDR_START_SYM = 0x100000;
    . = __KERNEL_LOAD_ADDR_START_SYM;

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

    __KERNEL_LOAD_ADDR_END_SYM = .;
    __KERNEL_LOAD_RUNTIME_SIZE_SYM = __KERNEL_LOAD_ADDR_END_SYM - __KERNEL_LOAD_ADDR_START_SYM;

    /DISCARD/ : { 
        *(.comment) 
        *(.note*) 
        *(.eh_frame*) 
    }
}
