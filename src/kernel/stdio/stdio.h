#ifndef KERNEL_STDIO_H
#define KERNEL_STDIO_H

#include "kprintf.h"

void stdio_init (void);
void kputc_noflush (int c);
void kputc (int c);
int kputs (const char *str);
int kputs_raw (const char *str);
int kputs_raw_noflush (const char *str);
void flush_stdout (void);

#endif /* KERNEL_STDIO_H */
