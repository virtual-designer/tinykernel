#include "idt.h"
#include "stddef.h"
#include "stdint.h"
#include "stdio.h"

struct idt_entry
{
    uint16_t offset_low;
    uint16_t segment;
    uint8_t ist : 3;
    uint8_t resv0 : 5;
    uint8_t gate_type : 4;
    uint8_t resv1 : 1;
    uint8_t dpl : 2;
    uint8_t p : 1;
    uint16_t offset_mid;
    uint32_t offset_high;
    uint32_t resv2;
} __attribute__ ((packed));

struct idtr
{
    uint16_t size;
    struct idt_entry *idt;
} __attribute__ ((packed));

extern void isr_entry_0x00 (void);

static const void (*isr_entries[256]) (void) = { &isr_entry_0x00, NULL };

struct idt_entry idt[256] = { 0 };
struct idtr idtr = { .size = sizeof (idt) - 1, .idt = idt };

idt_handler_t idt_handlers[256] = { NULL };

void
idt_install_handler (enum idt_entry_type type, idt_handler_t handler)
{
    idt_handlers[type] = handler;
}

extern void idt_load ();

void
idt_init (void)
{
    for (int i = 0; i < 256; i++)
    {
        if (!idt_handlers[i])
            continue;

        kprintf ("Installing interrupt handler for vector 0x%x\n", i);

        uint64_t isr_entry_ptr = (uint64_t) isr_entries[i];
        struct idt_entry *e = &idt[i];

        e->p = 1;
        e->segment = 0x08;
        e->ist = 0;
        e->gate_type = 0xf; /* 64-bit trap gate */
        e->dpl = 0;
        e->offset_low = isr_entry_ptr & 0xFFFF;
        e->offset_mid = (isr_entry_ptr >> 16U) & 0xFFFF;
        e->offset_high = isr_entry_ptr >> 32U;
    }

    idt_load ();
    kprintf ("Interrupt handlers registered\n");
}
