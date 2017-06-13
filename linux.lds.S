/*
 * Copyright (c) 2017 ARM Limited. All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
TARGET(binary)

INPUT(KERNEL)
INPUT(DTB)

SECTIONS
{
	. = PHYS_OFFSET;
	.text : {
		*(.head.text)
		*(.text)
	}

	. = PHYS_OFFSET + 0x4000;
	dtb =. ;
	.dtb : {  DTB }

	. = PHYS_OFFSET + 0x8000;
	kernel = .;
	.kernel : { KERNEL }

	.data : { *(.data) }
	.bss : {
		*(.bss)

		. = ALIGN(8) + STACK_SIZE;
		stack_base = .;
	}

}
