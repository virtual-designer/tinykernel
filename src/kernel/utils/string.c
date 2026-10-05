#include "string.h"
#include "stddef.h"
#include "stdint.h"

#undef memcpy
#undef memmove
#undef memset

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
