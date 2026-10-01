#include "debug.h"
#include "stdio/stdio.h"
#include "utils.h"

#define PRINT_REGISTER_GAP "    "

void
print_registers (const struct register_state *rstate)
{
    kprintf ("******* Begin register state *******\n");
    kprintf ("|  eax=0x%x" PRINT_REGISTER_GAP "ecx=0x%x" PRINT_REGISTER_GAP
             "edx=0x%x" PRINT_REGISTER_GAP "ebx=0x%x\n",
             rstate->eax, rstate->ecx, rstate->edx, rstate->ebx);
    kprintf ("|  ebp=0x%x" PRINT_REGISTER_GAP "esp=0x%x\n", rstate->ebp,
             rstate->esp);
    kprintf ("|  esi=0x%x" PRINT_REGISTER_GAP "edi=0x%x\n", rstate->esi,
             rstate->edi);
    kprintf ("|  eip=0x%x\n", rstate->eip);
    kprintf ("|  eflags=0x%x\n", rstate->eflags);
    kprintf ("|  ds=0x%hx" PRINT_REGISTER_GAP "es=0x%hx" PRINT_REGISTER_GAP
             "fs=0x%hx" PRINT_REGISTER_GAP "gs=0x%hx\n",
             rstate->ds, rstate->es, rstate->fs, rstate->gs);
    kprintf ("|  cs=0x%hx" PRINT_REGISTER_GAP "ss=0x%hx\n", rstate->cs,
             rstate->ss);
    kprintf ("******** End register state ********\n");
}
