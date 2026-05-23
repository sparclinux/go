// Copyright 2017 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "textflag.h"

//
// System calls for SPARC64, Linux
//

// func Syscall(trap int64, a1, a2, a3 int64) (r1, r2, err int64);
TEXT ·Syscall(SB),NOSPLIT,$0-56
	CALL	runtime·entersyscall(SB)
	MOVD	a1+8(FP), O0
	MOVD	a2+16(FP), O1
	MOVD	a3+24(FP), O2
	MOVD	trap+0(FP), RT1
	TA	$0x6d
	BCCD	ok
	MOVD	$-1, L1
	MOVD	L1, r1+32(FP)
	MOVD	ZR, r2+40(FP)
	MOVD	O0, err+48(FP)
	CALL	runtime·exitsyscall(SB)
	RET
ok:
	MOVD	O0, r1+32(FP)
	MOVD	O1, r2+40(FP)
	MOVD	ZR, err+48(FP)
	CALL	runtime·exitsyscall(SB)
	RET

// func Syscall6(trap, a1, a2, a3, a4, a5, a6 uintptr) (r1, r2, err uintptr)
TEXT ·Syscall6(SB),NOSPLIT,$0-80
	CALL	runtime·entersyscall(SB)
	MOVD	a1+8(FP), O0
	MOVD	a2+16(FP), O1
	MOVD	a3+24(FP), O2
	MOVD	a4+32(FP), O3
	MOVD	a5+40(FP), O4
	MOVD	a6+48(FP), O5
	MOVD	trap+0(FP), RT1
	TA	$0x6d
	BCCD	ok6
	MOVD	$-1, L1
	MOVD	L1, r1+56(FP)
	MOVD	ZR, r2+64(FP)
	MOVD	O0, err+72(FP)
	CALL	runtime·exitsyscall(SB)
	RET
ok6:
	MOVD	O0, r1+56(FP)
	MOVD	O1, r2+64(FP)
	MOVD	ZR, err+72(FP)
	CALL	runtime·exitsyscall(SB)
	RET

// func RawSyscall(trap, a1, a2, a3 uintptr) (r1, r2, err uintptr)
TEXT ·RawSyscall(SB),NOSPLIT,$0-56
	MOVD	a1+8(FP), O0
	MOVD	a2+16(FP), O1
	MOVD	a3+24(FP), O2
	MOVD	trap+0(FP), RT1
	TA	$0x6d
	BCCD	ok1
	MOVD	$-1, L1
	MOVD	L1, r1+32(FP)
	MOVD	ZR, r2+40(FP)
	MOVD	O0, err+48(FP)
	RET
ok1:
	MOVD	O0, r1+32(FP)
	MOVD	O1, r2+40(FP)
	MOVD	ZR, err+48(FP)
	RET

// func RawSyscall6(trap, a1, a2, a3, a4, a5, a6 uintptr) (r1, r2, err uintptr)
TEXT ·RawSyscall6(SB),NOSPLIT,$0-80
	MOVD	a1+8(FP), O0
	MOVD	a2+16(FP), O1
	MOVD	a3+24(FP), O2
	MOVD	a4+32(FP), O3
	MOVD	a5+40(FP), O4
	MOVD	a6+48(FP), O5
	MOVD	trap+0(FP), RT1
	TA	$0x6d
	BCCD	ok2
	MOVD	$-1, L1
	MOVD	L1, r1+56(FP)
	MOVD	ZR, r2+64(FP)
	MOVD	O0, err+72(FP)
	RET
ok2:
	MOVD	O0, r1+56(FP)
	MOVD	O1, r2+64(FP)
	MOVD	ZR, err+72(FP)
	RET
