#include "string.h"
#include "stddef.h"
#include "stdint.h"

#undef memcpy
#undef memmove
#undef memset
#undef memcmp

void *__attribute__ ((__optimize__ ("-fno-tree-loop-distribute-patterns")))
memcpy (void *dest, const void *src, size_t len)
{
    uint8_t *dest_u8 = (uint8_t *) dest;
    const uint8_t *src_u8 = (const uint8_t *) src;

    while (len--)
        *dest_u8++ = *src_u8++;

    return dest;
}

void *__attribute__ ((__optimize__ ("-fno-tree-loop-distribute-patterns")))
memmove (void *dest, const void *src, size_t len)
{
    uint8_t *dest_u8 = (uint8_t *) dest;
    const uint8_t *src_u8 = (const uint8_t *) src;

    if (dest > src)
    {
        while (len--)
            dest_u8[len] = src_u8[len];
    }
    else
    {
        while (len--)
            *dest_u8++ = *src_u8++;
    }

    return dest;
}

void *__attribute__ ((__optimize__ ("-fno-tree-loop-distribute-patterns")))
memset (void *dest, int c, size_t len)
{
    uint8_t *dest_u8 = (uint8_t *) dest;

    while (len--)
        *dest_u8++ = (uint8_t) c;

    return dest;
}

int __attribute__ ((__optimize__ ("-fno-tree-loop-distribute-patterns")))
memcmp (const void *src1, const void *src2, size_t len)
{
    for (size_t i = 0; i < len; i++)
    {
        const int c1 = (int) ((const uint8_t *) src1)[i];
        const int c2 = (int) ((const uint8_t *) src2)[i];
        const int diff = c1 - c2;

        if (diff)
            return diff;
    }

    return 0;
}
