#include "kprintf.h"
#include "stdbool.h"
#include "stddef.h"
#include "stdint.h"
#include "stdio/stdio.h"
#include "utils/debug.h"
#include "utils/string.h"
#include "utils/utils.h"

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
    KP_LEN_PTR,
    __KP_LEN_COUNT
};

enum kp_type
{
    KP_TYPE_SIGNED_DECIMAL,
    KP_TYPE_UNSIGNED_DECIMAL,
    KP_TYPE_UNSIGNED_STORAGE_SIZE,
    KP_TYPE_UNSIGNED_HEX,
    KP_TYPE_UNSIGNED_OCT,
    KP_TYPE_UNSIGNED_BIN,
    KP_TYPE_UNSIGNED_PTR,
    KP_TYPE_FLOAT,
    KP_TYPE_CHAR,
    KP_TYPE_STRING,
};

enum kp_err
{
    KP_ERR_INVALID_TYPE = 1,
    KP_ERR_UNEXPECTED_END,
    KP_ERR_INVALID_STATE
};

struct kp_opts
{
    bool pad_zeros;
};

#define KP_OPTS_DEFAULT ((struct kp_opts){ .pad_zeros = false })

static const size_t float_type_size_lut[] = {
    [KP_LEN_DEFAULT] = sizeof (double),
    [KP_LEN_SHORT] = 0,
    [KP_LEN_LONG] = sizeof (double),
    [KP_LEN_LONG_LONG] = sizeof (long double),
    [KP_LEN_SIZE] = 0,
    [KP_LEN_PTR] = 0,
};

static const size_t int_type_size_lut[] = {
    [KP_LEN_DEFAULT] = sizeof (int),
    [KP_LEN_SHORT] = sizeof (short int),
    [KP_LEN_LONG] = sizeof (long int),
    [KP_LEN_LONG_LONG] = sizeof (long long int),
    [KP_LEN_SIZE] = sizeof (size_t),
    [KP_LEN_PTR] = sizeof (size_t),
};

static size_t int_type_max_hex_digits_lut[__KP_LEN_COUNT];
static size_t int_type_max_oct_digits_lut[__KP_LEN_COUNT];
static size_t int_type_max_bin_digits_lut[__KP_LEN_COUNT];
static size_t int_type_max_dec_digits_lut[__KP_LEN_COUNT];

static inline size_t
kprintf_count_decimal_digits (uint64_t value)
{
    if (value >= 10000000000000000000ULL)
        return 20;

    if (value >= 1000000000000000000ULL)
        return 19;

    if (value >= 100000000000000000ULL)
        return 18;

    if (value >= 10000000000000000ULL)
        return 17;

    if (value >= 1000000000000000ULL)
        return 16;

    if (value >= 100000000000000ULL)
        return 15;

    if (value >= 10000000000000ULL)
        return 14;

    if (value >= 1000000000000ULL)
        return 13;

    if (value >= 100000000000ULL)
        return 12;

    if (value >= 10000000000ULL)
        return 11;

    if (value >= 1000000000ULL)
        return 10;

    if (value >= 100000000ULL)
        return 9;

    if (value >= 10000000ULL)
        return 8;

    if (value >= 1000000ULL)
        return 7;

    if (value >= 100000ULL)
        return 6;

    if (value >= 10000ULL)
        return 5;

    if (value >= 1000ULL)
        return 4;

    if (value >= 100ULL)
        return 3;

    if (value >= 10ULL)
        return 2;

    return 1;
}

void
kprintf_init (void)
{
    memcpy (int_type_max_hex_digits_lut, int_type_size_lut,
            sizeof int_type_max_hex_digits_lut);
    memcpy (int_type_max_oct_digits_lut, int_type_size_lut,
            sizeof int_type_max_oct_digits_lut);
    memcpy (int_type_max_bin_digits_lut, int_type_size_lut,
            sizeof int_type_max_bin_digits_lut);
    memcpy (int_type_max_dec_digits_lut, int_type_size_lut,
            sizeof int_type_max_bin_digits_lut);

    for (int i = 0; i < __KP_LEN_COUNT; i++)
    {
        int_type_max_hex_digits_lut[i] *= 2U;
        int_type_max_bin_digits_lut[i] *= 8U;

        size_t old_oct = int_type_max_oct_digits_lut[i];
        int_type_max_oct_digits_lut[i]
            = (int_type_max_oct_digits_lut[i] * 8U) / 3U;

        if ((int_type_max_oct_digits_lut[i] * 3U) / 8U != old_oct)
            int_type_max_oct_digits_lut[i]++;

        unsigned long long int max
            = int_type_max_bin_digits_lut[i] == 64
                  ? ~(0ULL)
                  : ~(1ULL << int_type_max_bin_digits_lut[i]);
        int_type_max_dec_digits_lut[i] = kprintf_count_decimal_digits (max);
    }
}

static const char *storage_size_units[]
    = { " B", " KiB", " MiB", " GiB", " TiB", " PiB", " EiB", NULL };

static inline void
kprintf_format_storage_size (unsigned long long int *out_value,
                             const char **out_unit)
{
    unsigned long long int value = *out_value;
    int unit_index;

    for (unit_index = 0; value >= 1024 && storage_size_units[unit_index];
         unit_index++)
        value /= 1024;

    *out_value = value;
    *out_unit = storage_size_units[unit_index];
}

static int
kprintf_decimal_internal (unsigned long long int value,
                          const struct kp_opts *opts, enum kp_type type,
                          enum kp_length length, bool is_signed,
                          int decimal_point_pos)
{
    (void) opts;

    const size_t dec_digits = int_type_max_dec_digits_lut[length];
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

    const char *size_unit = NULL;

    if (type == KP_TYPE_UNSIGNED_STORAGE_SIZE)
        kprintf_format_storage_size (&value, &size_unit);

    char buf[65] = { '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',

                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',

                     0 };
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

    if (opts->pad_zeros)
        buf_len = dec_digits < 64 ? dec_digits : 64;

    int i = 0;

    while (buf_len--)
    {
        if (i == decimal_point_pos)
        {
            if (!i)
            {
                putc_noflush ('0');
                count++;
            }

            putc_noflush ('.');
            count++;
        }

        putc_noflush (buf[buf_len]);
        i++;
    }

    if (size_unit)
        count += puts_raw_noflush (size_unit);

    return count;
}

static inline int
kprintf_int_decimal (unsigned long long int value, const struct kp_opts *opts,
                     enum kp_type type, enum kp_length length, bool is_signed)
{
    return kprintf_decimal_internal (value, opts, type, length, is_signed, -1);
}

static int
kprintf_int_hex (unsigned long long int value, const struct kp_opts *opts,
                 enum kp_length length)
{
    const size_t hex_digits = int_type_max_hex_digits_lut[length];
    int count = 0;
    char buf[18] = { '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', 0 };

    int buf_len = 0;

    do
    {
        if (buf_len >= sizeof buf - 1)
            return -1;

        uint8_t digit = (uint8_t) (value % 16);
        buf[buf_len++] = digit < 0xA ? '0' + digit : ('a' + digit - 10);
        value /= 16;
    } while (value);

    count += buf_len;

    if (opts->pad_zeros)
        buf_len = hex_digits < 16 ? hex_digits : 16;

    while (buf_len--)
        putc_noflush (buf[buf_len]);

    return count;
}

static int
kprintf_int_oct (unsigned long long int value, const struct kp_opts *opts,
                 enum kp_length length)
{
    const size_t oct_digits = int_type_max_oct_digits_lut[length];
    int count = 0;
    char buf[25] = { '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',

                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',

                     0 };
    int buf_len = 0;

    do
    {
        if (buf_len >= sizeof buf - 1)
            return -1;

        uint8_t digit = (uint8_t) (value % 8);
        buf[buf_len++] = '0' + digit;
        value /= 8;
    } while (value);

    count += buf_len;

    if (opts->pad_zeros)
        buf_len = oct_digits < 22 ? oct_digits : 22;

    while (buf_len--)
        putc_noflush (buf[buf_len]);

    return count;
}

static int
kprintf_int_bin (unsigned long long int value, const struct kp_opts *opts,
                 enum kp_length length)
{
    const size_t bin_digits = int_type_max_bin_digits_lut[length];
    int count = 0;
    char buf[65] = { '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',

                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
                     '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',

                     0 };
    int buf_len = 0;

    do
    {
        if (buf_len >= sizeof buf - 1)
            return -1;

        uint8_t digit = (uint8_t) (value & 0x1);
        buf[buf_len++] = '0' + digit;
        value >>= 1;
    } while (value);

    count += buf_len;

    if (opts->pad_zeros)
        buf_len = bin_digits < 64 ? bin_digits : 64;

    while (buf_len--)
        putc_noflush (buf[buf_len]);

    return count;
}

static int
kprintf_float_long_double (long double ldvalue, const struct kp_opts *opts)
{
    return 0;
}

static int
kprintf_float_double (double dvalue, const struct kp_opts *opts)
{
    int count = 0;
    const int prec = 6;
    uint64_t bits = 0;
    memcpy (&bits, &dvalue, sizeof (double));
    const uint16_t biased_exp = (bits >> 52ULL) & 0x7FF;
    const uint64_t mantissa = bits & 0xFFFFFFFFFFFFFULL;
    const int exp = ((int) biased_exp) - 1023;

    bool is_neg = bits >> 63ULL;

    if (is_neg)
    {
        dvalue = -dvalue;
        putc_noflush ('-');
        count++;
    }

    if (!biased_exp && !mantissa)
    {
        for (int i = 0; i < prec; i++)
            putc_noflush ('0');

        count += prec;
    }
    else if (biased_exp == 0x7ff)
    {
        count += puts_raw_noflush (mantissa ? "nan" : "infinity");
    }
    else
    {
        int digits
            = dvalue < 1.0
                  ? 0
                  : (int) kprintf_count_decimal_digits ((uint64_t) dvalue);

        for (int i = 0; i < prec; i++)
            dvalue *= 10;

        uint64_t value = (double) dvalue;
        count += kprintf_decimal_internal (value, opts, KP_TYPE_SIGNED_DECIMAL,
                                           KP_LEN_LONG_LONG, false, digits);
    }

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
kprintf_float_type (const void *ptr, enum kp_type type, enum kp_length length,
                    const struct kp_opts *opts, int *inc)
{
    (void) type;

    const size_t byte_len = float_type_size_lut[length];
    int count;
    double dvalue = 0;
    long double ldvalue = 0;

    switch (length)
    {
        case KP_LEN_DEFAULT:
        case KP_LEN_LONG:
            memcpy (&dvalue, ptr, sizeof (double));
            count = kprintf_float_double (dvalue, opts);
            break;

        case KP_LEN_LONG_LONG:
            memcpy (&ldvalue, ptr, sizeof (long double));
            count = kprintf_float_long_double (ldvalue, opts);
            break;

        default:
            return -1;
    }

    *inc = byte_len < sizeof (void *)
               ? 1
               : ((byte_len + sizeof (void *) - 1) / sizeof (void *));

    return count;
}

static int
kprintf_int_type (const void *ptr, enum kp_type type, enum kp_length length,
                  const struct kp_opts *opts, int *inc)
{
    union
    {
        unsigned long long int llval;
        unsigned long int lval;
        unsigned int ival;
        unsigned short sval;
        size_t szval;
    } value = { 0 };

    const size_t byte_len = int_type_size_lut[length];

    switch (length)
    {
        case KP_LEN_DEFAULT:
            value.ival = *(unsigned int *) ptr;
            break;

        case KP_LEN_SHORT:
            value.sval = *(unsigned short int *) ptr;
            break;

        case KP_LEN_LONG:
            value.lval = *(unsigned long int *) ptr;
            break;

        case KP_LEN_LONG_LONG:
            value.llval = *(unsigned long long int *) ptr;
            break;

        case KP_LEN_SIZE:
            value.szval = *(size_t *) ptr;
            break;

        case KP_LEN_PTR:
            value.llval = (size_t) *(void **) ptr;
            break;

        default:
            return -1;
    }

    *inc = byte_len < sizeof (void *)
               ? 1
               : ((byte_len + sizeof (void *) - 1) / sizeof (void *));

    switch (type)
    {
        case KP_TYPE_SIGNED_DECIMAL:
            return kprintf_int_decimal (value.llval, opts, type, length, true);

        case KP_TYPE_UNSIGNED_DECIMAL:
            return kprintf_int_decimal (value.llval, opts, type, length, false);

        case KP_TYPE_UNSIGNED_STORAGE_SIZE:
            return kprintf_int_decimal (value.llval, opts, type, length, false);

        case KP_TYPE_UNSIGNED_HEX:
            return kprintf_int_hex (value.llval, opts, length);

        case KP_TYPE_UNSIGNED_OCT:
            return kprintf_int_oct (value.llval, opts, length);

        case KP_TYPE_UNSIGNED_BIN:
            return kprintf_int_bin (value.llval, opts, length);

        case KP_TYPE_UNSIGNED_PTR:
            putc_noflush ('0');
            putc_noflush ('x');
            return kprintf_int_hex (value.llval, opts, length) + 2;
    }

    return -1;
}

void
panic_message_kprintf (const char *format, ...)
{
    void **argp = ((void **) &format) + 1;
    puts ("***************************************");
    puts ("********* KERNEL PANIC: HALT **********");
    puts ("***************************************");
    kvprintf (argp, format);
}

int
kprintf (const char *format, ...)
{
    void **argp = ((void **) &format) + 1;
    return kvprintf (argp, format);
}

int
kvprintf (void **argp, const char *format)
{
    int count = 0;
    enum kp_state state = KP_STATE_DEFAULT;
    enum kp_length length = KP_LEN_DEFAULT;
    enum kp_type type = -1;
    struct kp_opts opts = KP_OPTS_DEFAULT;

    for (;;)
    {
        switch (state)
        {
            case KP_STATE_DEFAULT:
                switch (*format)
                {
                    case 0:
                        goto kp_state_end;

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
                        continue;

                    case '0':
                        opts.pad_zeros = true;
                        format++;
                        break;
                }

                switch (*format)
                {
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

                    case 'S':
                        type = KP_TYPE_UNSIGNED_STORAGE_SIZE;
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

                    case 'p':
                        type = KP_TYPE_UNSIGNED_PTR;
                        break;

                    case 'f':
                        type = KP_TYPE_FLOAT;
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

                        case KP_TYPE_FLOAT:
                            ret = kprintf_float_type (argp, type, length, &opts,
                                                      &inc);
                            argp += inc;
                            break;

                        default:
                            ret = kprintf_int_type (argp, type, length, &opts,
                                                    &inc);
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
                    opts = KP_OPTS_DEFAULT;
                    type = -1;
                }

                break;

            default:
                count = -KP_ERR_INVALID_STATE;
                goto end;
        }
    }
kp_state_end:

    if (state != KP_STATE_DEFAULT)
        count = -KP_ERR_UNEXPECTED_END;

end:
    flush_stdout ();
    return count;
}
