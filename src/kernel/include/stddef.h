#ifndef KERNEL_STDDEF_H
#define KERNEL_STDDEF_H

#define NULL ((void *) 0x00)
typedef unsigned long int size_t;

#define SIZE_MAX (~(SIZE_C (0)))
#define SIZE_MIN SIZE_C (0)
#define SIZE_C(c) ((size_t) c##ULL)

#endif /* KERNEL_STDDEF_H */
