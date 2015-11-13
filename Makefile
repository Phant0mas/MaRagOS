CC = gcc
OBJCOPY = objcopy
LD = ld
AS = nasm

CFLAGS = -ffreestanding -m32 -Wall -Os -c
LDFLAGS = -m elf_i386

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.c drivers/*.c)

OBJ = ${C_SOURCES:.c=.o}

all: os-image

run : all
	qemu-system-i386 -s os-image

os-image: boot/bootloader.bin kernel.bin
	cat $^ > $@

kernel.bin: kernel/kernel_entry.o ${OBJ}
	$(LD) $(LDFLAGS) -o $@ -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS}
	$(CC) $(CFLAGS) $< -o $@

%.o: %.asm
	$(AS) $< -f elf -o $@

%.bin: %.asm
	$(AS) $< -f bin -I 'boot/' -o $@

clean:
	rm -rf *o *bin  *.dis *.map os-image \
kernel/*.o boot/*.o drivers/*.o boot/*.bin

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@
