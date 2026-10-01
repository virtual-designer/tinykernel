#ifndef KERNEL_DEBUG_H
#define KERNEL_DEBUG_H

#include "stdint.h"
#include "utils.h"

void print_registers (const struct register_state *rstate);

#endif /* KERNEL_DEBUG_H */
