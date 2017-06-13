#
# Copyright (c) 2017, ARM Limited. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

STACK_SIZE	= 0x10000
PHYS_OFFSET	= 0x60000000

KERNEL		= ./Image
DTB		= ./mps2-an399.dtb

LINUX		= linux.axf
BOOT		= boot.axf

CC		= $(CROSS_COMPILE)gcc
LD		= $(CROSS_COMPILE)ld
AS		= $(CROSS_COMPILE)as

CFLAGS		+= -DPHYS_OFFSET=$(PHYS_OFFSET)
CFLAGS		+= -DSTACK_SIZE=$(STACK_SIZE)
CFLAGS		+= -DKERNEL=$(KERNEL)
CFLAGS		+= -DDTB=$(DTB)

ASFLAGS		+= -march=armv7-m
ASFLAGS		+= -mthumb -mthumb -mimplicit-it=always
ASFLAGS		+= --defsym PHYS_OFFSET=$(PHYS_OFFSET)

all: $(LINUX) $(BOOT)

clean:
	rm -f $(LINUX) $(BOOT) boot.o linux.lds boot.lds

$(LINUX): linux.lds  boot.o FORCE
	$(LD) boot.o -o $@ --script=linux.lds

$(BOOT): boot.lds boot.o
	$(LD) boot.o -o $@ --script=boot.lds

%.o: %.S
	$(AS) $(ASFLAGS) -o $@ $<

boot.lds: boot.lds.S
	$(CC) $(CFLAGS) -E -P -C -o $@ $<

linux.lds: linux.lds.S
	$(CC) $(CFLAGS) -E -P -C -o $@ $<

.PHONY: FORCE
FORCE:
