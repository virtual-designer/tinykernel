ENTRY(_start)
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386:x86-64)

SECTIONS
{
    __KERNEL_LOAD_ADDR_START_SYM = 0x100000;
    . = __KERNEL_LOAD_ADDR_START_SYM;

    .text : ALIGN(8)
    {
        *(.text.boot*)
        *(.text*)
    }

    .data : ALIGN(8)
    {
        *(.data*)
    }

    .rodata : ALIGN(8)
    {
        *(.rodata*)
    }

    .stack : ALIGN(8)
    {
        *(.stack*)
    }

    .bss : ALIGN(8)
    {
        __KERNEL_BSS_START = ABSOLUTE(.);
        *(COMMON)
        *(.bss*)
        __KERNEL_BSS_END = ABSOLUTE(.);
    }

    __KERNEL_LOAD_ADDR_END_SYM = .;
    __KERNEL_LOAD_RUNTIME_SIZE_SYM = __KERNEL_LOAD_ADDR_END_SYM - __KERNEL_LOAD_ADDR_START_SYM;

    /DISCARD/ : { 
        *(.comment) 
        *(.note*) 
        *(.eh_frame*) 
    }
}
