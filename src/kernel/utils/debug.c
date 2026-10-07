#include "debug.h"
#include "stdio/stdio.h"
#include "utils.h"

#define PRINT_REGISTER_GAP "    "

void
print_registers (const struct register_state *rstate)
{
    kprintf ("******* Begin register state *******\n");
    kprintf ("|     rax=0x%0x" PRINT_REGISTER_GAP "rcx=0x%0x" PRINT_REGISTER_GAP
             "rdx=0x%0x" PRINT_REGISTER_GAP "rbx=0x%0x\n",
             rstate->rax, rstate->rcx, rstate->rdx, rstate->rbx);
    kprintf ("|     rbp=0x%0x" PRINT_REGISTER_GAP "rsp=0x%0x\n", rstate->rbp,
             rstate->rsp);
    kprintf ("|     rsi=0x%0x" PRINT_REGISTER_GAP "rdi=0x%0x\n", rstate->rsi,
             rstate->rdi);
    kprintf ("|     rip=0x%0x" PRINT_REGISTER_GAP "rflags=0x%0x\n", rstate->rip,
             rstate->rflags);
    kprintf ("|     ds=0x%0hx" PRINT_REGISTER_GAP "es=0x%0hx" PRINT_REGISTER_GAP
             "      fs=0x%0hx" PRINT_REGISTER_GAP "gs=0x%0hx\n",
             rstate->ds, rstate->es, rstate->fs, rstate->gs);
    kprintf ("|     cs=0x%0hx" PRINT_REGISTER_GAP "ss=0x%0hx\n", rstate->cs,
             rstate->ss);
    kprintf ("******** End register state ********\n");
}
