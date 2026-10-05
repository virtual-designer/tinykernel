#ifndef KERNEL_COMPILER_H
#define KERNEL_COMPILER_H

#if defined(__GNUC__) || defined(__clang__)
#else
#define __attribute__(x)
#endif

#endif /* KERNEL_COMPILER_H */
