dnl  ARM mpn_rshift.

dnl  Contributed to the GNU project by Torbjörn Granlund.

dnl  Copyright 1997, 2000, 2001, 2012 Free Software Foundation, Inc.

dnl  This file is part of the GNU MP Library.

dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU Lesser General Public License as published
dnl  by the Free Software Foundation; either version 3 of the License, or (at
dnl  your option) any later version.

dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
dnl  License for more details.

dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.

include(`../config.m4')

C	     cycles/limb
C StrongARM	 ?
C XScale	 ?
C Cortex-A7	 ?
C Cortex-A8	 ?
C Cortex-A9	 3.5
C Cortex-A15	 ?

define(`rp',  `r0')
define(`up',  `r1')
define(`n',   `r2')
define(`cnt', `r3')
define(`tnc', `r12')

ASM_START()
PROLOGUE(mpn_rshift)
	push	{r4, r6, r7, r8}
	ldr	r4, [up]
	rsb	tnc, cnt, #32

	mov	r7, r4, lsr cnt
	tst	n, #1
	beq	L(evn)			C n even

L(odd):	subs	n, n, #2
	bcc	L(1)			C n = 1
	ldr	r8, [up, #4]!
	b	L(mid)

L(evn):	ldr	r6, [up, #4]!
	subs	n, n, #2
	beq	L(end)

L(top):	ldr	r8, [up, #4]!
	orr	r7, r7, r6, lsl tnc
	str	r7, [rp], #4
	mov	r7, r6, lsr cnt
L(mid):	ldr	r6, [up, #4]!
	orr	r7, r7, r8, lsl tnc
	str	r7, [rp], #4
	mov	r7, r8, lsr cnt
	subs	n, n, #2
	bgt	L(top)

L(end):	orr	r7, r7, r6, lsl tnc
	str	r7, [rp], #4
	mov	r7, r6, lsr cnt
L(1):	str	r7, [rp], #4
	mov	r0, r4, lsl tnc
	pop	{r4, r6, r7, r8}
	bx	r14
EPILOGUE()
