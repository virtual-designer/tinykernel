#ifndef KERNEL_PRINTF_H
#define KERNEL_PRINTF_H

int __attribute__((format(printf, 1, 2))) kprintf(const char *format, ...);
int kvprintf (void **argp, const char *format);
_Noreturn void __attribute__((format(printf, 1, 2))) panic(const char *format, ...);

#endif /* KERNEL_PRINTF_H */
