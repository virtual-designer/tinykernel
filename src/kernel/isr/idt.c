#include "idt.h"
#include "stddef.h"
#include "stdint.h"
#include "stdio.h"
#include "utils/utils.h"

#define IDT_VECTOR_COUNT 256

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

extern const uint64_t isr_cpu_entry_path_list[IDT_VECTOR_COUNT];

__attribute__ ((align (16))) struct idt_entry idt[IDT_VECTOR_COUNT] = { 0 };
__attribute__ ((align (16))) struct idtr idtr
    = { .size = sizeof (idt) - 1, .idt = idt };

idt_handler_t idt_handlers[IDT_VECTOR_COUNT] = { NULL };

void
idt_install_handler (enum idt_entry_type type, uint8_t gate_type,
                     idt_handler_t handler)
{
    kprintf ("idt: installing interrupt handler for vector 0x%x\n", type);
    idt_handlers[type] = handler;
    struct idt_entry *e = &idt[type];
    e->gate_type = gate_type;
}

void
idt_install_trap_handler (enum idt_entry_type type, idt_handler_t handler)
{
    idt_install_handler (type, 0xF, handler);
}

void
idt_init (void)
{
    for (int i = 0; i < IDT_VECTOR_COUNT; i++)
    {
        uint64_t isr_entry_ptr = isr_cpu_entry_path_list[i];
        struct idt_entry *e = &idt[i];

        e->p = 1;
        e->segment = 0x08;
        e->ist = 0;
        e->dpl = 0;
        e->gate_type = 0xF;
        e->offset_low = isr_entry_ptr & 0xFFFF;
        e->offset_mid = (isr_entry_ptr >> 16U) & 0xFFFF;
        e->offset_high = isr_entry_ptr >> 32U;
        idt_handlers[i] = NULL;
    }
}

void
isr_handler_invoke (int type)
{
    if (!idt_handlers[type])
        panic ("idt: no handler set up for interrupt type: 0x%x\n", type);

    idt_handlers[type]();
}
