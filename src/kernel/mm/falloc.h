#ifndef KERNEL_FALLOC_H
#define KERNEL_FALLOC_H

#include "compiler.h"
#include "init/e820.h"
#include "stddef.h"

struct falloc;
struct falloc *falloc_init_with_e820_table (const struct e820_table *table);
void falloc_print (void);
uint64_t falloc (size_t size);
uint64_t falloc_page (void);

#endif /* KERNEL_FALLOC_H */
