#ifndef KERNEL_MMAN_H
#define KERNEL_MMAN_H

#include "compiler.h"
#include "init/e820.h"

struct kmman;
struct kmman *kmman_init_with_e820_table (const struct e820_table *table);
void kmman_print (const struct kmman *mman);

#endif /* KERNEL_MMAN_H */
