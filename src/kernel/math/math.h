#ifndef KERNEL_MATH_H
#define KERNEL_MATH_H

#include "stdint.h"

extern const double INFINITY;

uint64_t ullpow (uint64_t base, uint64_t exp);
double floor (double value);
double ceil (double value);

#endif /* KERNEL_MATH_H */
