#ifndef KERNEL_STDIO_H
#define KERNEL_STDIO_H

#include "kprintf.h"

void stdio_init (void);
void putc_noflush (int c);
void putc (int c);
int puts (const char *str);
int puts_raw (const char *str);
int puts_raw_noflush (const char *str);
void flush_stdout (void);

#endif /* KERNEL_STDIO_H */
