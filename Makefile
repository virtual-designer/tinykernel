-include config.progs.mk

AS ?= as
LD ?= ld
CC ?= gcc
CCAS ?= $(CC)
CCLD ?= $(CC)
RM ?= rm -f
DD ?= dd
QEMU ?= qemu-system-x86_64

ASFLAGS := -g
LDFLAGS :=
CPPFLAGS := \
	-I$(shell pwd)/src \
	-I$(shell pwd)/src/kernel \
	-I$(shell pwd)/src/kernel/include

CFLAGS := \
	-g \
	-std=gnu11 \
	-Wall \
	-Wextra \
	-pedantic \
	-Wno-packed-bitfield-compat \
	-ffreestanding \
	-nostdinc \
	-nostdlib \
	-mpopcnt \
	-mbmi \
	-mlzcnt \
	-march=native \
	-mtune=native \
	-mfpmath=sse \
	-msse2 \
	-msse3 \
	-msse4 \
	-mno-avx \
	-mno-avx2 \
	-fno-pic \
	-fno-pie \
	-fno-stack-protector \
	-fbuiltin

CCASFLAGS := $(CFLAGS) -D__ASM__

KERNEL_LOAD_PHY_ADDR_START     := 0x100000
KERNEL_LOAD_VIRT_ADDR_OFFSET   := 0xffffffff80000000
KERNEL_SHADOW_VIRT_ADDR_OFFSET := 0xffff800000000000
KERNEL_LOAD_VIRT_ADDR_START  := $(shell python3 -c "print(hex($(KERNEL_LOAD_VIRT_ADDR_OFFSET) + $(KERNEL_LOAD_PHY_ADDR_START)))")

LOADER1_CPPFLAGS :=
LOADER2_CPPFLAGS :=
KERNEL_CPPFLAGS  :=

CPPFLAGS += \
	-DKERNEL_LOAD_PHY_ADDR_START=$(KERNEL_LOAD_PHY_ADDR_START) \
	-DKERNEL_LOAD_VIRT_ADDR_START=$(KERNEL_LOAD_VIRT_ADDR_START) \
	-DKERNEL_LOAD_VIRT_ADDR_OFFSET=$(KERNEL_LOAD_VIRT_ADDR_OFFSET) \
	-DKERNEL_SHADOW_VIRT_ADDR_OFFSET=$(KERNEL_SHADOW_VIRT_ADDR_OFFSET)

LOADER1_CFLAGS := -m32
LOADER2_CFLAGS :=
KERNEL_CFLAGS  := -m64 -mcmodel=kernel

LOADER1_CCASFLAGS := $(LOADER1_CFLAGS)
LOADER2_CCASFLAGS := $(LOADER2_CFLAGS)
KERNEL_CCASFLAGS := $(KERNEL_CFLAGS)

LOADER1_LDFLAGS :=
LOADER2_LDFLAGS :=
KERNEL_LDFLAGS := \
	-Wl,--defsym=__KERNEL_LOAD_PHY_ADDR_START_SYM=$(KERNEL_LOAD_PHY_ADDR_START) \
	-Wl,--defsym=__KERNEL_LOAD_VIRT_ADDR_START_SYM=$(KERNEL_LOAD_VIRT_ADDR_START) \
	-Wl,--defsym=__KERNEL_LOAD_VIRT_ADDR_OFFSET_SYM=$(KERNEL_LOAD_VIRT_ADDR_OFFSET) \
	-Wl,--defsym=__KERNEL_SHADOW_VIRT_ADDR_OFFSET_SYM=$(KERNEL_SHADOW_VIRT_ADDR_OFFSET) \
	-mcmodel=kernel

v_as_ = $(v_as_0)
v_as_0 = @echo "   AS   $@"; $(AS)
v_as_1 = $(AS)

v_cc_ = $(v_cc_0)
v_cc_0 = @echo "   CC   $@"; $(CC)
v_cc_1 = $(CC)

v_ccld_ = $(v_ccld_0)
v_ccld_0 = @echo "   CCLD $@"; $(CCLD)
v_ccld_1 = $(CCLD)

v_ccas_ = $(v_ccas_0)
v_ccas_0 = @echo "   CCAS $@"; $(CCAS)
v_ccas_1 = $(CCAS)

v_ld_ = $(v_ld_0)
v_ld_0 = @echo "   LD   $@"; $(LD)
v_ld_1 = $(LD)

V_AS = $(v_as_$(V))
V_CC = $(v_cc_$(V))
V_CCLD = $(v_ccld_$(V))
V_CCAS = $(v_ccas_$(V))
V_LD = $(v_ld_$(V))

IMG := /tmp/disk.img
LOADER1 := /tmp/loader1
LOADER2 := /tmp/loader2
KERNEL := /tmp/kernel

LOADER1_MAIN_SOURCE = src/loader/stage1.S
LOADER1_SOURCES := \
	$(LOADER1_MAIN_SOURCE)

LOADER1_MAIN_OBJECT := $(patsubst %.S,%.o,$(LOADER1_MAIN_SOURCE))
LOADER1_OBJECTS := $(patsubst %.S,%.o,$(patsubst %.s,%.o,$(LOADER1_SOURCES)))

LOADER2_MAIN_SOURCE = src/loader/stage2.S
LOADER2_SOURCES := \
	$(LOADER2_MAIN_SOURCE)

LOADER2_MAIN_OBJECT := $(patsubst %.S,%.o,$(LOADER2_MAIN_SOURCE))
LOADER2_OBJECTS := $(patsubst %.S,%.o,$(patsubst %.s,%.o,$(LOADER2_SOURCES)))

KERNEL_SOURCES_GENERATED := src/kernel/isr/isr_entry.S

KERNEL_SOURCES := \
	src/kernel/init/main.c \
	src/kernel/init/entry64.s \
	src/kernel/utils/utils.s \
	src/kernel/stdio/stdio.c \
	src/kernel/stdio/kprintf.c \
	src/kernel/fpu/fpu.s \
	src/kernel/utils/string.c \
	src/kernel/init/e820.c \
	src/kernel/utils/debug.c \
	src/kernel/math/math.c \
	src/kernel/math/consts.s \
	src/kernel/mm/falloc.c \
	src/kernel/mm/pg.c \
	src/kernel/isr/idt.c \
	src/kernel/isr/isr.S \
	src/kernel/acpi/acpi.c \
	$(KERNEL_SOURCES_GENERATED)

KERNEL_OBJECTS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(patsubst %.s,%.o,$(KERNEL_SOURCES))))

all: $(IMG)

$(IMG): $(LOADER1) $(LOADER2) $(KERNEL)
	$(DD) if=/dev/zero of=$(IMG) bs=512 count=256 conv=sync
	$(DD) if=$(LOADER1) of=$(IMG) bs=512 conv=notrunc
	$(DD) if=$(LOADER2) of=$(IMG) bs=512 conv=notrunc seek=1
	$(DD) if=$(KERNEL) of=$(IMG) bs=512 conv=notrunc seek=32
	echo =============================
	echo KERNEL_LOAD_VIRT_ADDR_START=$(KERNEL_LOAD_VIRT_ADDR_START)
	echo =============================

$(LOADER1_MAIN_OBJECT): $(LOADER1_MAIN_SOURCE)
	$(V_CCAS) $(CPPFLAGS) $(LOADER1_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

$(LOADER2_MAIN_OBJECT): $(LOADER2_MAIN_SOURCE)
	$(V_CCAS) $(CPPFLAGS) $(LOADER2_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

$(LOADER1): $(LOADER1_OBJECTS)
	$(V_LD) $(LDFLAGS) -Map=src/loader/loader1.map --script loader1_cfg.ld -o $@ $^

$(LOADER2): $(LOADER2_OBJECTS)
	$(V_LD) $(LDFLAGS) -Map=src/loader/loader2.map --script loader2_cfg.ld -o $@ $^

src/kernel/isr/isr_entry.S: src/kernel/isr/genisr.sh
	$(SHELL) src/kernel/isr/genisr.sh > $@

src/kernel/%.o: src/kernel/%.S
	$(V_CCAS) $(KERNEL_CPPFLAGS) $(CPPFLAGS) $(KERNEL_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

src/kernel/%.o: src/kernel/%.s
	$(V_CCAS) $(KERNEL_CPPFLAGS) $(CPPFLAGS) $(KERNEL_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

src/kernel/%.o: src/kernel/%.c
	$(V_CC) $(KERNEL_CPPFLAGS) $(CPPFLAGS) $(KERNEL_CFLAGS) $(CFLAGS) -o $@ -c $<

$(KERNEL): $(KERNEL_OBJECTS)
	$(V_CCLD) $(KERNEL_LDFLAGS) $(KERNEL_CFLAGS) $(CFLAGS) $(LDFLAGS) -Wl,--script kernel_cfg.ld -o $@ $^ -lgcc

clean:
	$(RM) $(IMG)
	$(RM) $(LOADER1) $(LOADER2) $(KERNEL) *.map
	$(RM) $(LOADER1_OBJECTS) $(LOADER2_OBJECTS) $(KERNEL_OBJECTS)
	$(RM) $(KERNEL_SOURCES_GENERATED)

run: $(IMG)
	$(QEMU) -cpu max -machine pc,acpi=on -m 8G -monitor stdio \
    	    -global isa-debugcon.iobase=0xe9 -vga std -d int,cpu_reset \
			-no-reboot -drive format=raw,file=$(IMG)

drun: $(IMG)
	$(RM) $(IMG).lock
	bochs -f bochsrc -dbg_gui

.PHONY: all clean run drun
