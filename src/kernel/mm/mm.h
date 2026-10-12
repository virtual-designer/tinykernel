#ifndef KERNEL_MM_H
#define KERNEL_MM_H

#include "compiler.h"
#include "init/e820.h"

struct kmem_manager;
struct kmem_manager *kmm_init_with_e820_table (const struct e820_table *table);
void kmm_print (const struct kmem_manager *kmm);

#endif /* KERNEL_MM_H */
