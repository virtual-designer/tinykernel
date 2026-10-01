#include "debug.h"
#include "stdio/stdio.h"
#include "utils.h"

#define PRINT_REGISTER_GAP "    "

void
print_registers (const struct register_state *rstate)
{
    kprintf ("******* Begin register state *******\n");
    kprintf ("|     eax=0x%0x" PRINT_REGISTER_GAP "ecx=0x%0x" PRINT_REGISTER_GAP
             "edx=0x%0x" PRINT_REGISTER_GAP "ebx=0x%0x\n",
             rstate->eax, rstate->ecx, rstate->edx, rstate->ebx);
    kprintf ("|     ebp=0x%0x" PRINT_REGISTER_GAP "esp=0x%0x\n", rstate->ebp,
             rstate->esp);
    kprintf ("|     esi=0x%0x" PRINT_REGISTER_GAP "edi=0x%0x\n", rstate->esi,
             rstate->edi);
    kprintf ("|     eip=0x%0x" PRINT_REGISTER_GAP "eflags=0x%0x\n", rstate->eip,
             rstate->eflags);
    kprintf ("|     ds=0x%0hx" PRINT_REGISTER_GAP "es=0x%0hx" PRINT_REGISTER_GAP
             "      fs=0x%0hx" PRINT_REGISTER_GAP "gs=0x%0hx\n",
             rstate->ds, rstate->es, rstate->fs, rstate->gs);
    kprintf ("|     cs=0x%0hx" PRINT_REGISTER_GAP "ss=0x%0hx\n", rstate->cs,
             rstate->ss);
    kprintf ("******** End register state ********\n");
}
