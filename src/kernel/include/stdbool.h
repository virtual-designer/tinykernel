#ifndef KERNEL_STDBOOL_H
#define KERNEL_STDBOOL_H

typedef enum
{
    ktrue = 1,
    kfalse = 0
} kbool_t;

#define bool kbool_t
#define true ktrue
#define false kfalse

#endif /* KERNEL_STDBOOL_H */