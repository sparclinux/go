// Copyright 2017 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"
#include "asm_sparc64.h"

TEXT _rt0_sparc64_linux(SB),NOSPLIT|NOFRAME,$0
	// On SPARC64 Linux, the stack pointer %sp is biased by 2047.
	// The unbiased address of argc is %sp + 2047 + 128 (window save area).
	// BSP is translated by the assembler to (RSP + 2047).
	MOVD	128(BSP), O0 // argc
	MOVD	BSP, O1
	ADD	$136, O1, O1 // argv (128 + 8)
	MOVD	$main(SB), O3
	JMPL	O3, ZR

TEXT main(SB),NOSPLIT|REGWIN,$0
	MOVD	I0, O0
	MOVD	I1, O1
	CALL	runtime·rt0_go(SB)
	RET
