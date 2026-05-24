// Copyright 2017 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//
// System calls and other sys.stuff for SPARC64, Linux
//

#include "go_asm.h"
#include "go_tls.h"
#include "textflag.h"
#include "asm_sparc64.h"

#define SYS_exit 1
#define SYS_read 3
#define SYS_write 4
#define SYS_open 5
#define SYS_close 6
#define SYS_gettimeofday 116
#define SYS_brk 17
#define SYS_munmap 73
#define SYS_madvise 75
#define SYS_setitimer 83
#define SYS_getpid 20
#define SYS_gettid 143
#define SYS_kill 37
#define SYS_tkill 187
#define SYS_futex 142
#define SYS_sched_getaffinity 161
#define SYS_exit_group 188
#define SYS_rt_sigreturn 101
#define SYS_rt_sigaction 102
#define SYS_rt_sigprocmask 103
#define SYS_sigaltstack 28
#define SYS_mmap 71
#define SYS_clock_gettime 257
#define SYS_pipe2 321
#define SYS_epoll_create1 319
#define SYS_epoll_ctl 194
#define SYS_epoll_wait 195
#define SYS_epoll_pwait 309
#define SYS_fcntl 92
#define SYS_tgkill 211
#define SYS_mincore 78

TEXT runtime·exit(SB),NOSPLIT|NOFRAME,$0-4
	MOVW	code+0(FP), O0
	MOVW	$SYS_exit_group, RT1
	TA	$0x6d
	RET

TEXT runtime·exit1(SB),NOSPLIT|NOFRAME,$0-4
	MOVW	code+0(FP), O0
	MOVW	$SYS_exit, RT1
	TA	$0x6d
	RET

TEXT runtime·open(SB),NOSPLIT|NOFRAME,$0-20
	MOVD	name+0(FP), O0
	MOVW	mode+8(FP), O1
	MOVW	perm+12(FP), O2
	MOVW	$SYS_open, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	NEG	O0, O0
ok:
	MOVW	O0, ret+16(FP)
	RET

TEXT runtime·closefd(SB),NOSPLIT|NOFRAME,$0-12
	MOVW	fd+0(FP), O0
	MOVW	$SYS_close, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	NEG	O0, O0
ok:
	MOVW	O0, ret+8(FP)
	RET

TEXT runtime·write(SB),NOSPLIT|NOFRAME,$0-28
	MOVD	fd+0(FP), O0
	MOVD	p+8(FP), O1
	MOVW	n+16(FP), O2
	MOVW	$SYS_write, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	NEG	O0, O0
ok:
	MOVD	O0, ret+24(FP)
	RET

TEXT runtime·read(SB),NOSPLIT|NOFRAME,$0-28
	MOVW	fd+0(FP), O0
	MOVD	p+8(FP), O1
	MOVW	n+16(FP), O2
	MOVW	$SYS_read, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	NEG	O0, O0
ok:
	MOVD	O0, ret+24(FP)
	RET

TEXT runtime·getrlimit(SB),NOSPLIT|NOFRAME,$0-20
	MOVW	kind+0(FP), O0
	MOVD	limit+8(FP), O1
	MOVW	$144, RT1 // SYS_GETRLIMIT
	TA	$0x6d
	MOVW	O0, ret+16(FP)
	RET

TEXT runtime·usleep(SB),NOSPLIT,$16
	MOVD	usec+0(FP), O0
	MOVD	$1000000, O1
	UDIVD	O1, O0, O2 // sec
	MOVD	O2, O3
	MULD	O1, O3, O4
	SUB	O4, O0, O5 // usec
	// use local area (offset 176)
	MOVD	O2, 176(BSP) // tv_sec
	MOVD	O5, O0
	MULD	$1000, O0, O0
	MOVD	O0, 184(BSP) // tv_nsec

	MOVD	$0, O0 // n
	MOVD	$0, O1 // readfds
	MOVD	$0, O2 // writefds
	MOVD	$0, O3 // exceptfds
	MOVD	BSP, O4
	ADD	$176, O4, O4 // timeout pointer
	MOVW	$230, RT1 // SYS__NEWSELECT
	TA	$0x6d
	RET

TEXT runtime·gettid(SB),NOSPLIT|NOFRAME,$0-4
	MOVW	$SYS_gettid, RT1
	TA	$0x6d
	MOVW	O0, ret+0(FP)
	RET

TEXT runtime·raise(SB),NOSPLIT|NOFRAME,$0
	MOVW	$SYS_getpid, RT1
	TA	$0x6d
	MOVW	O0, O0
	MOVW	$SYS_gettid, RT1
	TA	$0x6d
	MOVW	O0, O1
	MOVW	sig+0(FP), O2
	MOVW	$SYS_tgkill, RT1
	TA	$0x6d
	RET

TEXT runtime·raiseproc(SB),NOSPLIT|NOFRAME,$0
	MOVW	$SYS_getpid, RT1
	TA	$0x6d
	MOVW	O0, O0
	MOVW	sig+0(FP), O1
	MOVW	$SYS_kill, RT1
	TA	$0x6d
	RET

TEXT runtime·setitimer(SB),NOSPLIT|NOFRAME,$0-24
	MOVW	mode+0(FP), O0
	MOVD	new+8(FP), O1
	MOVD	old+16(FP), O2
	MOVW	$SYS_setitimer, RT1
	TA	$0x6d
	RET

TEXT runtime·mincore(SB),NOSPLIT|NOFRAME,$0-28
	MOVD	addr+0(FP), O0
	MOVD	n+8(FP), O1
	MOVD	dst+16(FP), O2
	MOVW	$SYS_mincore, RT1
	TA	$0x6d
	MOVW	O0, ret+24(FP)
	RET

TEXT runtime·walltime(SB),NOSPLIT,$16
	MOVW	$0, O0 // CLOCK_REALTIME
	MOVD	BSP, O1
	ADD	$176, O1, O1 // timespec pointer in local area
	MOVW	$SYS_clock_gettime, RT1
	TA	$0x6d

	MOVD	176(BSP), O0 // sec
	MOVD	184(BSP), O1 // nsec
	MOVD	O0, sec+0(FP)
	MOVW	O1, nsec+8(FP)
	RET

TEXT runtime·nanotime(SB),NOSPLIT,$16
	MOVW	$1, O0 // CLOCK_MONOTONIC
	MOVD	BSP, O1
	ADD	$176, O1, O1 // timespec pointer in local area
	MOVW	$SYS_clock_gettime, RT1
	TA	$0x6d

	MOVD	176(BSP), O0 // sec
	MOVD	184(BSP), O1 // nsec
	MOVD	$1000000000, O2
	MULD	O2, O0
	ADD	O1, O0
	MOVD	O0, ret+0(FP)
	RET

TEXT runtime·futex(SB),NOSPLIT|NOFRAME,$0-28
	MOVD	addr+0(FP), O0
	MOVW	op+8(FP), O1
	MOVW	val+12(FP), O2
	MOVD	ts+16(FP), O3
	MOVD	addr2+24(FP), O4
	MOVW	val3+32(FP), O5
	MOVW	$SYS_futex, RT1
	TA	$0x6d
	MOVW	O0, ret+36(FP)
	RET

TEXT runtime·osyield(SB),NOSPLIT|NOFRAME,$0
	MOVW	$245, RT1 // SYS_SCHED_YIELD
	TA	$0x6d
	RET

TEXT runtime·sched_getaffinity(SB),NOSPLIT|NOFRAME,$0-28
	MOVD	pid+0(FP), O0
	MOVD	len+8(FP), O1
	MOVD	buf+16(FP), O2
	MOVW	$SYS_sched_getaffinity, RT1
	TA	$0x6d
	MOVW	O0, ret+24(FP)
	RET

// sigaction
TEXT runtime·rt_sigaction(SB),NOSPLIT|NOFRAME,$0-36
	MOVD	sig+0(FP), O0
	MOVD	new+8(FP), O1
	MOVD	old+16(FP), O2
	MOVD	ZR, O3	// restorer
	MOVD	size+24(FP), O4
	MOVW	$SYS_rt_sigaction, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	NEG	O0, O0
ok:
	MOVW	O0, ret+32(FP)
	RET

// sigprocmask
TEXT runtime·rtsigprocmask(SB),NOSPLIT|NOFRAME,$0-28
	MOVW	how+0(FP), O0
	MOVD	new+8(FP), O1
	MOVD	old+16(FP), O2
	MOVW	sigsetsize+24(FP), O3
	MOVW	$SYS_rt_sigprocmask, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	NEG	O0, O0
ok:
	RET

TEXT runtime·sigfwd(SB),NOSPLIT|NOFRAME,$0-32
	MOVD	sig+8(FP), O0
	MOVD	info+16(FP), O1
	MOVD	ctx+24(FP), O2
	MOVD	fn+0(FP), L1
	CALL	(L1)
	RET

TEXT runtime·sigtramp(SB),NOSPLIT|REGWIN,$128
	// Save RT1 (g1) since it's clobbered by load_g
	// R16 is %l0 after SAVE.
	MOVD	RT1, R16
	CALL	runtime·load_g(SB)

	// sig, info, ctxt are in I0, I1, I2 after SAVE.
	// Arguments area of sigtramp starts at 176(BSP).
	MOVD	I0, 176(BSP)
	MOVD	I1, 184(BSP)
	MOVD	I2, 192(BSP)
	CALL	runtime·sigtrampgo(SB)

	// Restore RT1
	MOVD	R16, RT1
	RET

TEXT runtime·cgoSigtramp(SB),NOSPLIT|NOFRAME,$0
	JMP	runtime·sigtramp(SB)

// sigreturn
TEXT runtime·sigreturn(SB),NOSPLIT|NOFRAME,$0
	MOVW	$SYS_rt_sigreturn, RT1
	TA	$0x6d
	RET

// sigaltstack
TEXT runtime·sigaltstack(SB),NOSPLIT|NOFRAME,$0-16
	MOVD	new+0(FP), O0
	MOVD	old+8(FP), O1
	MOVW	$SYS_sigaltstack, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	MOVD	ZR, (ZR)	// crash
ok:
	RET

// mmap
TEXT runtime·mmap(SB),NOSPLIT|NOFRAME,$0
	MOVD	addr+0(FP), O0
	MOVD	n+8(FP), O1
	MOVW	prot+16(FP), O2
	MOVW	flags+20(FP), O3
	MOVW	fd+24(FP), O4
	MOVW	off+28(FP), O5
	MOVW	$SYS_mmap, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	MOVD	$0, O1
	MOVD	O1, ret+32(FP)
	MOVD	O0, err+40(FP)
	RET
ok:
	MOVD	O0, ret+32(FP)
	MOVD	$0, err+40(FP)
	RET

TEXT runtime·munmap(SB),NOSPLIT|NOFRAME,$0
	MOVD	addr+0(FP), O0
	MOVD	n+8(FP), O1
	MOVW	$SYS_munmap, RT1
	TA	$0x6d
	BCCD	ok
	NOP
	MOVD	ZR, (ZR)	// crash
ok:
	RET

TEXT runtime·madvise(SB),NOSPLIT|NOFRAME,$0
	MOVD	addr+0(FP), O0
	MOVD	n+8(FP), O1
	MOVW	flags+16(FP), O2
	MOVW	$SYS_madvise, RT1
	TA	$0x6d
	RET

// epoll
TEXT runtime·epollcreate(SB),NOSPLIT|NOFRAME,$0
	MOVW	size+0(FP), O0
	MOVW	$193, RT1 // SYS_EPOLL_CREATE
	TA	$0x6d
	MOVW	O0, ret+8(FP)
	RET

TEXT runtime·epollcreate1(SB),NOSPLIT|NOFRAME,$0
	MOVW	flags+0(FP), O0
	MOVW	$SYS_epoll_create1, RT1
	TA	$0x6d
	MOVW	O0, ret+8(FP)
	RET

TEXT runtime·epollctl(SB),NOSPLIT|NOFRAME,$0
	MOVW	epfd+0(FP), O0
	MOVW	op+4(FP), O1
	MOVW	fd+8(FP), O2
	MOVD	ev+16(FP), O3
	MOVW	$SYS_epoll_ctl, RT1
	TA	$0x6d
	MOVW	O0, ret+24(FP)
	RET

TEXT runtime·epollwait(SB),NOSPLIT|NOFRAME,$0
	MOVW	epfd+0(FP), O0
	MOVD	ev+8(FP), O1
	MOVW	nev+16(FP), O2
	MOVW	timeout+20(FP), O3
	MOVW	$SYS_epoll_wait, RT1
	TA	$0x6d
	MOVW	O0, ret+24(FP)
	RET

TEXT runtime·epollpwait(SB),NOSPLIT|NOFRAME,$0
	MOVW	epfd+0(FP), O0
	MOVD	ev+8(FP), O1
	MOVW	nev+16(FP), O2
	MOVW	timeout+20(FP), O3
	MOVD	mask+24(FP), O4
	MOVW	$SYS_epoll_pwait, RT1
	TA	$0x6d
	MOVW	O0, ret+32(FP)
	RET

// closeonexec
TEXT runtime·closeonexec(SB),NOSPLIT|NOFRAME,$0
	MOVW	fd+0(FP), O0
	MOVW	$2, O1 // F_SETFD
	MOVW	$1, O2 // FD_CLOEXEC
	MOVW	$SYS_fcntl, RT1
	TA	$0x6d
	RET

// int64 clone(int32 flags, void *stk, M *mp, G *gp, void (*fn)(void));
TEXT runtime·clone(SB),NOSPLIT|NOFRAME,$0
	MOVW	flags+0(FP), O0
	MOVD	stk+8(FP), O1

	// Copy mp, gp, fn off parent stack for use by child.
	MOVD	mp+16(FP), L1
	MOVD	gp+24(FP), L2
	MOVD	fn+32(FP), L3

	// O1 is the top of the stack. (Unbiased)
	// We need to leave space for the window and arguments.
	SUB	$FIXED_FRAME, O1, O1

	MOVD	L1, (FIXED_FRAME-8)(O1)
	MOVD	L2, (FIXED_FRAME-16)(O1)
	MOVD	L3, (FIXED_FRAME-24)(O1)
	MOVD	$1234, L1
	MOVD	L1, (FIXED_FRAME-32)(O1)

	// Subtract STACK_BIAS for the syscall
	SUB	$STACK_BIAS, O1, O1

	MOVW	$217, RT1 // SYS_CLONE
	TA	$0x6d

	// In parent, return.
	// On SPARC, O1 is 0 in parent, 1 in child.
	CMP	ZR, O1
	BNED	child
	NOP

	BCCD	parent
	NOP
	// Error
	NEG	O0, O0
	MOVW	O0, ret+40(FP)
	RET

parent:
	MOVW	O0, ret+40(FP)
	RET

child:
	// In child, on new stack.
	FLUSHW
	CALL	runtime·reginit(SB)

	// BSP is now the new stack pointer (unbiased).
	// (FIXED_FRAME-32) = 144.
	MOVD	144(BSP), L1
	MOVD	$1234, TMP
	CMP	L1, TMP
	BED	good
	NOP
	MOVD	ZR, (ZR) // crash

good:
	MOVW	$SYS_gettid, RT1
	TA	$0x6d
	// O0 is tid

	// fn: 152, g: 160, m: 168
	MOVD	152(BSP), L3 // fn
	MOVD	160(BSP), L2 // g
	MOVD	168(BSP), L1 // m

	CMP	ZR, L1
	BED	nog
	NOP
	CMP	ZR, L2
	BED	nog
	NOP

	MOVD	O0, m_procid(L1)

	// TODO: setup TLS.

	MOVD	L1, g_m(L2)
	MOVD	L2, g
	CALL	runtime·save_g(SB)

nog:
	CALL	(L3)

	// exit
	MOVW	$0, O0
	MOVW	$SYS_exit, RT1
	TA	$0x6d
	JMP	-2(PC)
