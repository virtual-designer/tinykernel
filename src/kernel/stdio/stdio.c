#include "kprintf.h"
#include "stddef.h"
#include "stdint.h"
#include "utils/utils.h"

static const uint16_t VGA_CRTC_INDEX = 0x3D4;
static const uint16_t VGA_CRTC_DATA = 0x3D5;

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static volatile uint16_t *vga_buffer = (uint16_t *) 0xb8000;
static size_t row = 0, col = 0;

enum vga_text_attr
{
    VT_ATTR_SPECIAL = (1U << 7),
    VT_ATTR_BG_DEFAULT = 0b111,
    VT_ATTR_FG_DEFAULT = 0b0111,
    VT_ATTR_FG_BRIGHT = 0b1000,
};

static void
vga_update_cursor (void)
{
    const size_t pos = row * VGA_WIDTH + col;

    outb (VGA_CRTC_INDEX, 0x0F);
    outb (VGA_CRTC_DATA, (uint8_t) (pos & 0xFF));
    outb (VGA_CRTC_INDEX, 0x0E);
    outb (VGA_CRTC_DATA, (uint8_t) ((pos >> 8U) & 0xFF));
}

static void
vga_clear (void)
{
    for (size_t i = 0; i < VGA_HEIGHT; i++)
    {
        for (size_t j = 0; j < VGA_WIDTH; j++)
        {
            const uint8_t attr
                = VT_ATTR_BG_DEFAULT | VT_ATTR_FG_DEFAULT | VT_ATTR_FG_BRIGHT;
            vga_buffer[i * VGA_WIDTH + j] = (attr << 8U) | ' ';
        }
    }

    row = col = 0;
    vga_update_cursor ();
}

static void
vga_enable_block_cursor (void)
{
    outb (VGA_CRTC_INDEX, 0x0A);
    outb (VGA_CRTC_DATA, 0x00);
    outb (VGA_CRTC_INDEX, 0x0B);
    outb (VGA_CRTC_DATA, 0x0F);
}

void
flush_stdout (void)
{
    vga_update_cursor ();
}

void
stdio_init (void)
{
    vga_clear ();
    vga_enable_block_cursor ();
    kprintf_init ();
}

static void
vga_scroll_down (void)
{
    for (size_t r = 1; r < VGA_HEIGHT; r++)
    {
        for (size_t c = 0; c < VGA_WIDTH; c++)
            vga_buffer[(r - 1) * VGA_WIDTH + c] = vga_buffer[r * VGA_WIDTH + c];
    }

    for (size_t c = 0; c < VGA_WIDTH; c++)
        vga_buffer[(VGA_HEIGHT - 1) * VGA_WIDTH + c]
            = ((VT_ATTR_BG_DEFAULT | VT_ATTR_FG_DEFAULT | VT_ATTR_FG_BRIGHT)
               << 8U)
              | ' ';
            
    row--;
}

static inline void
vga_write_char (uint8_t c, uint8_t attr)
{
    switch (c)
    {
        case '\n':
            col = 0;
            row++;
            break;

        default:
            vga_buffer[row * VGA_WIDTH + col] = (attr << 8U) | c;
            col++;
            break;
    }

    if (col >= VGA_WIDTH)
    {
        row++;
        col = 0;
    }

    if (row >= VGA_HEIGHT)
        vga_scroll_down ();
}

void
putc_noflush (char c)
{
    vga_write_char ((char) c, VT_ATTR_BG_DEFAULT | VT_ATTR_FG_DEFAULT
                                  | VT_ATTR_FG_BRIGHT);
}

void
putc (char c)
{
    putc_noflush (c);
    vga_update_cursor ();
}

static inline int
puts_raw_internal (const char *str)
{
    const char *begin = str;

    while (*str)
        putc (*(str++));

    return (int) (str - begin);
}

int
puts_raw (const char *str)
{
    int ret = puts_raw_internal (str);
    vga_update_cursor ();
    return ret;
}

int
puts_raw_noflush (const char *str)
{
    int ret = puts_raw_internal (str);
    return ret;
}

int
puts (const char *str)
{
    int ret = puts_raw_internal (str);
    putc_noflush ('\n');
    vga_update_cursor ();
    return ret + 1;
}
