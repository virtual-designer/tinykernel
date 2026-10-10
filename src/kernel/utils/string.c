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

int
memcmp (const void *src1, const void *src2, size_t len)
{
    for (size_t i = 0; i < len; i++)
    {
        const uint8_t c1 = ((const char *) src1)[i];
        const uint8_t c2 = ((const char *) src2)[i];
        const uint8_t diff = c1 - c2;

        if (diff)
            return diff;
    }

    return 0;
}
