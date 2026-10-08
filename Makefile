AS := as
LD := ld
CC := gcc
CCAS := $(CC)
CCLD := $(CC)
RM := rm -f
DD := dd
QEMU := qemu-system-x86_64

ASFLAGS := -g
LDFLAGS :=
CPPFLAGS := -I$(shell pwd)/src -I$(shell pwd)/src/kernel -I$(shell pwd)/src/kernel/include
CFLAGS := -ffreestanding -nostdinc -nostdlib -mfpmath=sse -msse2 -mno-avx -mno-avx2 -fno-pic -fno-pie -fno-stack-protector -g
CCASFLAGS := $(CFLAGS) -D__ASM__

LOADER1_CFLAGS := -m32
LOADER2_CFLAGS :=
KERNEL_CFLAGS  := -m64

LOADER1_CCASFLAGS := $(LOADER1_CFLAGS)
LOADER2_CCASFLAGS := $(LOADER2_CFLAGS)
KERNEL_CCASFLAGS := $(KERNEL_CFLAGS)

LOADER1_LDFLAGS :=
LOADER2_LDFLAGS :=
KERNEL_LDFLAGS :=

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
	src/kernel/mm/mman.c \
	src/kernel/int/idt.c \
	src/kernel/int/isr.S

KERNEL_OBJECTS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(patsubst %.s,%.o,$(KERNEL_SOURCES))))

all: $(IMG)

$(IMG): $(LOADER1) $(LOADER2) $(KERNEL)
	$(DD) if=/dev/zero of=$(IMG) bs=512 count=256 conv=sync
	$(DD) if=$(LOADER1) of=$(IMG) bs=512 conv=notrunc
	$(DD) if=$(LOADER2) of=$(IMG) bs=512 conv=notrunc seek=1
	$(DD) if=$(KERNEL) of=$(IMG) bs=512 conv=notrunc seek=32

$(LOADER1_MAIN_OBJECT): $(LOADER1_MAIN_SOURCE)
	$(CCAS) $(CPPFLAGS) $(LOADER1_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

$(LOADER2_MAIN_OBJECT): $(LOADER2_MAIN_SOURCE)
	$(CCAS) $(CPPFLAGS) $(LOADER2_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

$(LOADER1): $(LOADER1_OBJECTS)
	$(LD) $(LDFLAGS) -Map=src/loader/loader1.map --script loader1_cfg.ld -o $@ $^

$(LOADER2): $(LOADER2_OBJECTS)
	$(LD) $(LDFLAGS) -Map=src/loader/loader2.map --script loader2_cfg.ld -o $@ $^

src/kernel/%.o: src/kernel/%.S
	$(CCAS) $(CPPFLAGS) $(KERNEL_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

src/kernel/%.o: src/kernel/%.s
	$(CCAS) $(CPPFLAGS) $(KERNEL_CCASFLAGS) $(CCASFLAGS) -o $@ -c $<

src/kernel/%.o: src/kernel/%.c
	$(CC) $(CPPFLAGS) $(KERNEL_CFLAGS) $(CFLAGS) -o $@ -c $<

$(KERNEL): $(KERNEL_OBJECTS)
	$(CCLD) $(KERNEL_LDFLAGS) $(KERNEL_CFLAGS) $(CFLAGS) $(LDFLAGS) -Wl,--script kernel_cfg.ld -o $@ $^ -lgcc

clean:
	$(RM) $(IMG)
	$(RM) $(LOADER1) $(LOADER2) $(KERNEL) *.map
	$(RM) $(LOADER1_OBJECTS) $(LOADER2_OBJECTS) $(KERNEL_OBJECTS)

run: $(IMG)
	$(QEMU) -cpu max -machine pc,acpi=on -m 8G -vga std -d int,cpu_reset -no-reboot -drive format=raw,file=$(IMG)

drun: $(IMG)
	$(RM) $(IMG).lock
	bochs -f bochsrc -dbg_gui

.PHONY: all clean run drun
