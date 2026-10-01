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
CFLAGS := -ffreestanding -nostdinc -nostdlib -m32 -mno-sse -mno-avx -mno-avx2 -fno-pic -fno-pie -fno-stack-protector
CCASFLAGS := $(CFLAGS) -D__ASM__

IMG := /tmp/disk.img
LOADER := /tmp/loader
KERNEL := /tmp/kernel

LOADER_SOURCES := src/loader/boot.s
LOADER_OBJECTS := $(patsubst %.S,%.o,$(patsubst %.s,%.o,$(LOADER_SOURCES)))

KERNEL_SOURCES := \
	src/kernel/init/main.c \
	src/kernel/init/e820.c \
	src/kernel/stdio/kprintf.c \
	src/kernel/stdio/stdio.c \
	src/kernel/utils/utils.s \
	src/kernel/utils/debug.c \
	src/kernel/init/entry.s

KERNEL_OBJECTS := $(patsubst %.c,%.o,$(patsubst %.S,%.o,$(patsubst %.s,%.o,$(KERNEL_SOURCES))))

all: $(IMG)

$(IMG): $(LOADER) $(KERNEL)
	$(DD) if=/dev/zero of=$(IMG) bs=512 count=128 conv=sync
	$(DD) if=$(LOADER) of=$(IMG) bs=512 count=1 conv=notrunc
	$(DD) if=$(KERNEL) of=$(IMG) bs=512 oseek=1 conv=notrunc

$(LOADER): $(LOADER_OBJECTS)
	$(LD) $(LDFLAGS) --script loader_cfg.ld -o $@ $^

$(KERNEL): $(KERNEL_OBJECTS)
	$(CCLD) $(CFLAGS) $(LDFLAGS) -Wl,--script kernel_cfg.ld -o $@ $^ -lgcc

clean:
	$(RM) $(IMG)
	$(RM) $(LOADER) $(KERNEL)
	$(RM) $(LOADER_OBJECTS) $(KERNEL_OBJECTS)

run: $(IMG)
	$(QEMU) -enable-kvm -cpu host -m 8G -vga std -drive format=raw,file=$(IMG)

.SUFFIXES: .S .o

.S.o:
	$(CCAS) $(CPPFLAGS) $(CCASFLAGS) -c -o $@ $^

.PHONY: all clean run
