#include "debug.h"
#include "stdio/stdio.h"
#include "utils.h"

#define GAP "    "

/* clang-format off */

void
print_registers (const struct register_state *rstate)
{
    kprintf ("******* Begin register state *******\n");
    kprintf ("|     rax=0x%0x" GAP "rcx=0x%0x" GAP "rdx=0x%0x" GAP "rbx=0x%0x\n", rstate->rax, rstate->rcx, rstate->rdx, rstate->rbx);
    kprintf ("|     rbp=0x%0x" GAP "rsp=0x%0x\n", rstate->rbp, rstate->rsp);
    kprintf ("|     rsi=0x%0x" GAP "rdi=0x%0x\n", rstate->rsi, rstate->rdi);
    kprintf ("|     r8=0x%0x" GAP "r9=0x%0x" GAP "r10=0x%0x" GAP "r11=0x%0x\n", rstate->r8, rstate->r9, rstate->r10, rstate->r11);
    kprintf ("|     r12=0x%0x" GAP "r13=0x%0x" GAP "r14=0x%0x" GAP "r15=0x%0x\n",  rstate->r12, rstate->r13, rstate->r14, rstate->r15);
    kprintf ("|     rip=0x%0x" GAP "rflags=0x%0x\n", rstate->rip, rstate->rflags);
    kprintf ("|     ds=0x%0hx" GAP "es=0x%0hx" GAP "      fs=0x%0hx" GAP "gs=0x%0hx\n", rstate->ds, rstate->es, rstate->fs, rstate->gs);
    kprintf ("|     cs=0x%0hx" GAP "ss=0x%0hx\n", rstate->cs, rstate->ss);
    kprintf ("******** End register state ********\n");
}

/* clang-format on */
