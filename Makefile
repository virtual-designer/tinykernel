AS := as
LD := ld
CC := gcc
CCAS := $(CC)
CCLD := $(CC)
RM := rm -f
DD := dd
QEMU := qemu-system-x86_64

ASFLAGS := --32
LDFLAGS :=
CPPFLAGS := -I$(shell pwd)/src -I$(shell pwd)/src/kernel -I$(shell pwd)/src/kernel/include
CFLAGS := -ffreestanding -nostdinc -nostdlib -m32 -mfpmath=sse -msse2 -mno-avx -mno-avx2 -fno-pic -fno-pie -fno-stack-protector
CCASFLAGS := $(CFLAGS) -D__ASM__

IMG := /tmp/disk.img
LOADER1 := /tmp/loader1
LOADER2 := /tmp/loader2
KERNEL := /tmp/kernel

LOADER1_SOURCES := \
	src/loader/stage1.S

LOADER1_OBJECTS := $(patsubst %.S,%.o,$(patsubst %.s,%.o,$(LOADER1_SOURCES)))

LOADER2_SOURCES := \
	src/loader/stage2.S

LOADER2_OBJECTS := $(patsubst %.S,%.o,$(patsubst %.s,%.o,$(LOADER2_SOURCES)))

KERNEL_SOURCES := \
	src/kernel/init/main.c \
	src/kernel/init/e820.c \
	src/kernel/stdio/kprintf.c \
	src/kernel/stdio/stdio.c \
	src/kernel/mm/mman.c \
	src/kernel/fpu/fpu.s \
	src/kernel/math/math.c \
	src/kernel/math/consts.s \
	src/kernel/utils/utils.s \
	src/kernel/utils/debug.c \
	src/kernel/utils/string.c \
	src/kernel/init/entry32.s

KERNEL_OBJECTS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(patsubst %.s,%.o,$(KERNEL_SOURCES))))

all: $(IMG)

$(IMG): $(LOADER1) $(LOADER2) $(KERNEL)
	$(DD) if=/dev/zero of=$(IMG) bs=512 count=128 conv=sync
	$(DD) if=$(LOADER1) of=$(IMG) bs=512 conv=notrunc
	$(DD) if=$(LOADER2) of=$(IMG) bs=512 conv=notrunc seek=1
	$(DD) if=$(KERNEL) of=$(IMG) bs=512 conv=notrunc seek=8

$(LOADER1): $(LOADER1_OBJECTS)
	$(LD) $(LDFLAGS) -Map=src/loader/loader1.map --script loader1_cfg.ld -o $@ $^

$(LOADER2): $(LOADER2_OBJECTS)
	$(LD) $(LDFLAGS) -Map=src/loader/loader1.map --script loader2_cfg.ld -o $@ $^

$(KERNEL): $(KERNEL_OBJECTS)
	$(CCLD) $(CFLAGS) $(LDFLAGS) -Wl,--script kernel_cfg.ld -o $@ $^ -lgcc

clean:
	$(RM) $(IMG)
	$(RM) $(LOADER1) $(LOADER2) $(KERNEL) *.map
	$(RM) $(LOADER1_OBJECTS) $(LOADER2_OBJECTS) $(KERNEL_OBJECTS)

run: $(IMG)
	$(QEMU) -enable-kvm -cpu host -machine pc,acpi=on -m 8G -vga std -d int -drive format=raw,file=$(IMG)

.SUFFIXES: .S .o

.S.o:
	$(CCAS) $(CPPFLAGS) $(CCASFLAGS) -c -o $@ $^

.PHONY: all clean run
