#ifndef KERNEL_PRINTF_H
#define KERNEL_PRINTF_H

#include "compiler.h"

void kprintf_init (void);
int __attribute__ ((format (printf, 1, 2))) kprintf (const char *format, ...);
int kvprintf (void **argp, const char *format);
void __attribute__ ((format (printf, 1, 2)))
panic_message_kprintf (const char *format, ...);

#endif /* KERNEL_PRINTF_H */
