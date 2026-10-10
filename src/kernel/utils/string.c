#include "string.h"
#include "stddef.h"
#include "stdint.h"

#undef memcpy
#undef memmove
#undef memset
#undef memcmp

void
memcpy (void *dest, const void *src, size_t len)
{
    while (len--)
        *((char *) dest++) = *((const char *) src++);
}

void
memmove (void *dest, const void *src, size_t len)
{
    if (dest > src)
    {
        while (len--)
            ((char *) dest)[len] = ((const char *) src)[len];
    }
    else
    {
        while (len--)
            *((char *) dest++) = *((const char *) src++);
    }
}

void
memset (void *dest, int c, size_t len)
{
    while (len--)
        *((char *) dest++) = (char) c;
}

volatile int
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
