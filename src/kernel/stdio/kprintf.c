#include "kprintf.h"
#include "stdbool.h"
#include "stddef.h"
#include "stdint.h"
#include "stdio/stdio.h"
#include "utils/utils.h"
#include "utils/debug.h"

enum kp_state
{
    KP_STATE_DEFAULT,
    KP_STATE_LENGTH,
    KP_STATE_TYPE,
    KP_STATE_PRINT
};

enum kp_length
{
    KP_LEN_DEFAULT,
    KP_LEN_SHORT,
    KP_LEN_LONG,
    KP_LEN_LONG_LONG,
    KP_LEN_SIZE,
    KP_LEN_PTR
};

enum kp_type
{
    KP_TYPE_SIGNED_DECIMAL,
    KP_TYPE_UNSIGNED_DECIMAL,
    KP_TYPE_UNSIGNED_HEX,
    KP_TYPE_UNSIGNED_OCT,
    KP_TYPE_UNSIGNED_BIN,
    KP_TYPE_UNSIGNED_SIZE,
    KP_TYPE_UNSIGNED_PTR,
    KP_TYPE_CHAR,
    KP_TYPE_STRING,
};

enum kp_err
{
    KP_ERR_INVALID_TYPE = 1,
    KP_ERR_UNEXPECTED_END,
    KP_ERR_INVALID_STATE
};

static const size_t int_type_size_lut[] = {
    [KP_LEN_DEFAULT] = sizeof (int),
    [KP_LEN_SHORT] = sizeof (short int),
    [KP_LEN_LONG] = sizeof (long int),
    [KP_LEN_LONG_LONG] = sizeof (long long int),
    [KP_LEN_SIZE] = sizeof (size_t),
    [KP_LEN_PTR] = sizeof (size_t),
};

static int
kprintf_int_decimal (unsigned long long int value, enum kp_length length,
                     bool is_signed)
{
    const size_t size = int_type_size_lut[length];
    int count = 0;

    if (is_signed)
    {
        int flag = value >> ((size << SIZE_C (3)) - 1);

        if (flag)
        {
            putc_noflush ('-');
            count++;
            value = ~value + 1;
        }

        value &= size == 8 ? value : ((1ULL << (size << SIZE_C (3))) - 1);
    }

    char buf[64];
    int buf_len = 0;

    do
    {
        if (buf_len >= sizeof buf)
            return -1;

        uint8_t digit = (uint8_t) (value % 10);
        buf[buf_len++] = '0' + digit;
        value /= 10;
    } while (value);

    count += buf_len;

    while (buf_len--)
        putc_noflush (buf[buf_len]);

    return count;
}

static int
kprintf_int_hex (unsigned long long int value)
{
    int count = 0;
    char buf[64];
    int buf_len = 0;

    do
    {
        if (buf_len >= sizeof buf)
            return -1;

        uint8_t digit = (uint8_t) (value % 16);
        buf[buf_len++] = digit < 0xA ? '0' + digit : ('a' + digit - 10);
        value /= 16;
    } while (value);

    count += buf_len;

    while (buf_len--)
        putc_noflush (buf[buf_len]);

    return count;
}

static int
kprintf_int_oct (unsigned long long int value)
{
    int count = 0;
    char buf[128];
    int buf_len = 0;

    do
    {
        if (buf_len >= sizeof buf)
            return -1;

        uint8_t digit = (uint8_t) (value % 8);
        buf[buf_len++] = '0' + digit;
        value /= 8;
    } while (value);

    count += buf_len;

    while (buf_len--)
        putc_noflush (buf[buf_len]);

    return count;
}

static int
kprintf_int_bin (unsigned long long int value)
{
    int count = 0;
    char buf[128];
    int buf_len = 0;

    do
    {
        if (buf_len >= sizeof buf)
            return -1;

        uint8_t digit = (uint8_t) (value & 0x1);
        buf[buf_len++] = '0' + digit;
        value >>= 1;
    } while (value);

    count += buf_len;

    while (buf_len--)
        putc_noflush (buf[buf_len]);

    return count;
}

static inline int
kprintf_char (char c)
{
    putc_noflush (c);
    return 1;
}

static inline int
kprintf_string (const char *str)
{
    return puts_raw (str);
}

static int
kprintf_int_type (const void *ptr, enum kp_type type, enum kp_length length,
                  int *inc)
{
    union
    {
        unsigned long long int llval;
        unsigned long int lval;
        unsigned int ival;
        unsigned short sval;
        size_t szval;
    } value = { .llval = 0 };
    int size = 0;

    switch (length)
    {
        case KP_LEN_DEFAULT:
            value.ival = *(unsigned int *) ptr;
            size = sizeof (int);
            break;

        case KP_LEN_SHORT:
            value.sval = *(unsigned short int *) ptr;
            size = sizeof (short int);
            break;

        case KP_LEN_LONG:
            value.lval = *(unsigned long int *) ptr;
            size = sizeof (long int);
            break;

        case KP_LEN_LONG_LONG:
            value.llval = *(unsigned long long int *) ptr;
            size = sizeof (long long int);
            break;

        case KP_LEN_SIZE:
            value.szval = *(size_t *) ptr;
            size = sizeof (size_t);
            break;

        case KP_LEN_PTR:
            value.llval = (size_t) *(void **) ptr;
            size = sizeof (size_t);
            break;

        default:
            return -1;
    }

    *inc = size < 4 ? 1 : (size / sizeof (size_t));

    switch (type)
    {
        case KP_TYPE_SIGNED_DECIMAL:
            return kprintf_int_decimal (value.llval, length, true);

        case KP_TYPE_UNSIGNED_DECIMAL:
            return kprintf_int_decimal (value.llval, length, false);

        case KP_TYPE_UNSIGNED_HEX:
            return kprintf_int_hex (value.llval);

        case KP_TYPE_UNSIGNED_OCT:
            return kprintf_int_oct (value.llval);

        case KP_TYPE_UNSIGNED_BIN:
            return kprintf_int_bin (value.llval);

        case KP_TYPE_UNSIGNED_SIZE:
            return kprintf_int_decimal (value.llval, KP_LEN_SIZE, false);

        case KP_TYPE_UNSIGNED_PTR:
            putc_noflush ('0');
            putc_noflush ('x');
            return kprintf_int_hex (value.llval) + 2;
    }

    return -1;
}

_Noreturn void
panic (const char *format, ...)
{
    struct register_state state = {0};
    save_registers (&state);

    void **argp = ((void **) &format) + 1;
    puts("***************************************");
    puts("********* KERNEL PANIC: HALT **********");
    puts("***************************************");
    kvprintf(argp, format);
    print_registers (&state);
    halt();
}

int
kprintf (const char *format, ...)
{
    void **argp = ((void **) &format) + 1;
    return kvprintf(argp, format);
}

int
kvprintf (void **argp, const char *format)
{
    int count = 0;
    enum kp_state state = KP_STATE_DEFAULT;
    enum kp_length length = KP_LEN_DEFAULT;
    enum kp_type type = -1;

    while (*format)
    {
        switch (state)
        {
            case KP_STATE_DEFAULT:
                switch (*format)
                {
                    case '%':
                        state = KP_STATE_LENGTH;
                        format++;
                        break;

                    default:
                        putc_noflush (*format++);
                        count++;
                        break;
                }

                break;

            case KP_STATE_LENGTH:
                switch (*format)
                {
                    case '%':
                        putc_noflush ('%');
                        count++;
                        state = KP_STATE_DEFAULT;
                        format++;
                        break;

                    case 'l':
                        format++;

                        if (*format == 'l')
                        {
                            format++;
                            length = KP_LEN_LONG_LONG;
                            break;
                        }

                        length = KP_LEN_LONG;
                        break;

                    case 'h':
                        format++;
                        length = KP_LEN_SHORT;
                        break;

                    case 'z':
                        format++;
                        length = KP_LEN_SIZE;
                        break;

                    default:
                        break;
                }

                state = KP_STATE_TYPE;
                break;

            case KP_STATE_TYPE:
                switch (*format)
                {
                    case 'i':
                    case 'd':
                        type = KP_TYPE_SIGNED_DECIMAL;
                        break;

                    case 'u':
                        type = KP_TYPE_UNSIGNED_DECIMAL;
                        break;

                    case 'x':
                        type = KP_TYPE_UNSIGNED_HEX;
                        break;

                    case 'o':
                        type = KP_TYPE_UNSIGNED_OCT;
                        break;

                    case 'b':
                        type = KP_TYPE_UNSIGNED_BIN;
                        break;

                    case 'z':
                        type = KP_TYPE_UNSIGNED_SIZE;
                        break;

                    case 'p':
                        type = KP_TYPE_UNSIGNED_PTR;
                        break;

                    case 'c':
                        type = KP_TYPE_CHAR;
                        break;

                    case 's':
                        type = KP_TYPE_STRING;
                        break;

                    default:
                        count = -KP_ERR_INVALID_TYPE;
                        goto end;
                }

                format++;
                state = KP_STATE_PRINT;
                break;

            case KP_STATE_PRINT:
                {
                    int ret, inc = 0;

                    switch (type)
                    {
                        case KP_TYPE_CHAR:
                            ret = kprintf_char (*(const char *) (argp++));
                            break;

                        case KP_TYPE_STRING:
                            ret = kprintf_string (*(const char **) (argp++));
                            break;

                        default:
                            ret = kprintf_int_type (argp, type, length, &inc);
                            argp += inc;
                            break;
                    }

                    if (ret < 0)
                    {
                        count = ret;
                        goto end;
                    }

                    count += ret;
                    state = KP_STATE_DEFAULT;
                    length = KP_LEN_DEFAULT;
                    type = -1;
                }

                break;

            default:
                count = -KP_ERR_INVALID_STATE;
                goto end;
        }
    }

    if (state != KP_STATE_DEFAULT)
        count = -KP_ERR_UNEXPECTED_END;

end:
    flush_stdout ();
    return count;
}
