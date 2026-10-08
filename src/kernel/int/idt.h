#ifndef KERNEL_IDT_H
#define KERNEL_IDT_H

enum idt_entry_type
{
    IDT_V_DE = 0x00,
    IDT_V_DB = 0x01,
    IDT_V_NMI = 0x02,
    IDT_V_BP = 0x03,
    IDT_V_OF = 0x04,
    IDT_V_BR = 0x05,
    IDT_V_UD = 0x06,
    IDT_V_NM = 0x07,
    IDT_V_DF = 0x08,
    IDT_V_SO = 0x09,
    IDT_V_TS = 0x0A,
    IDT_V_NP = 0x0B,
    IDT_V_SS = 0x0C,
    IDT_V_GP = 0x0D,
    IDT_V_PF = 0x0E,
    IDT_V_MF = 0x10,
    IDT_V_AC = 0x11,
    IDT_V_MC = 0x12,
    IDT_V_XM = 0x13,
    IDT_V_VE = 0x14,
    IDT_V_CP = 0x15,
};

typedef void (*idt_handler_t) (void);

void idt_init (void);
void idt_install_handler (enum idt_entry_type type, idt_handler_t handler);

#endif /* KERNEL_IDT_H */
