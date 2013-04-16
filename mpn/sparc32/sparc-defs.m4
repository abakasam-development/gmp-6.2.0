divert(-1)

dnl  m4 macros for SPARC assembler (32 and 64 bit).


dnl  Copyright 2002, 2011, 2013 Free Software Foundation, Inc.
dnl
dnl  This file is part of the GNU MP Library.
dnl
dnl  The GNU MP Library is free software; you can redistribute it and/or
dnl  modify it under the terms of the GNU Lesser General Public License as
dnl  published by the Free Software Foundation; either version 3 of the
dnl  License, or (at your option) any later version.
dnl
dnl  The GNU MP Library is distributed in the hope that it will be useful,
dnl  but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
dnl  Lesser General Public License for more details.
dnl
dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.


changecom(;)	dnl cannot use default # since that's used in REGISTER decls


dnl  Usage: REGISTER(reg,attr)
dnl
dnl  Give a ".register reg,attr" directive, if the assembler supports it.
dnl  HAVE_REGISTER comes from the GMP_ASM_SPARC_REGISTER configure test.

define(REGISTER,
m4_assert_numargs(2)
m4_assert_defined(`HAVE_REGISTER')
`ifelse(HAVE_REGISTER,yes,
`.register `$1',`$2'')')


C Testing mechanism for running newer code on older processors
ifdef(`FAKE_T3',`
  include_mpn(`sparc64/ultrasparct3/missing.m4')
',`
  define(`addxccc',	``addxccc'	$1, $2, $3')
  define(`addxc',	``addxc'	$1, $2, $3')
  define(`umulxhi',	``umulxhi'	$1, $2, $3')
  define(`lzcnt',	``lzd'	$1, $2')
')

dnl  Usage: LEA64(symbol,reg,pic_reg)
dnl
dnl  Use whatever 64-bit code sequence is appropriate to load "symbol" into
dnl  register "reg", potentially using register "pic_reg" to perform the
dnl  calculations.

define(LEA64,
m4_assert_numargs(3)
m4_assert_defined(`HAVE_GOTDATA')
`ifdef(`PIC',`
	rd	%pc, %`$2'
	sethi	%hi(_GLOBAL_OFFSET_TABLE_+4), %`$3'
	add	%`$3', %lo(_GLOBAL_OFFSET_TABLE_+8), %`$3'
	add	%`$2', %`$3', %`$3'
	sethi	%hi(`$1'), %`$2'
	or	%`$2', %lo(`$1'), %`$2'
	ldx	[%`$3' + %`$2'], %`$2'',`
	setx	`$1', %`$3', %`$2'')')

divert
