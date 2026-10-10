#ifndef KERNEL_STRING_H
#define KERNEL_STRING_H

#include "stddef.h"
#include "compiler.h"

void memcpy(void *dest, const void *src, size_t len);
void memmove(void *dest, const void *src, size_t len);
void memset(void *dest, int c, size_t len);
int memcmp(const void *src1, const void *src2, size_t len);

#if defined(__GNUC__) || defined(__clang__)
#define memcpy(...) ((void) __builtin_memcpy(__VA_ARGS__))
#define memmove(...) ((void) __builtin_memmove(__VA_ARGS__))
#define memset(...) ((void) __builtin_memset(__VA_ARGS__))
#define memcmp(...) (__builtin_memcmp(__VA_ARGS__))
#endif

#endif /* KERNEL_STRING_H */
