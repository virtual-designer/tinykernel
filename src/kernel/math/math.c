#include "math.h"

uint64_t
ullpow (uint64_t base, uint64_t exp)
{
    uint64_t result = 1;

    while (exp)
    {
        if (exp & 1)
            result *= base;
        base *= base;
        exp >>= 1;
    }

    return result;
}

double
floor (double value)
{
    uint64_t uvalue = (uint64_t) value;
    return (double) uvalue;
}

double
ceil (double value)
{
    double fv = floor (value);
    return fv >= value ? value : (1.0 + fv);
}
