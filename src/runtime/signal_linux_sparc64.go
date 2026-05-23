// Copyright 2017 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package runtime

import (
	"unsafe"
)

type sigctxt struct {
	info *siginfo
	ctxt unsafe.Pointer
}

func (c *sigctxt) regs() *sigcontext { return &(*ucontext)(c.ctxt).uc_mcontext }

func (c *sigctxt) r1() uint64  { return c.regs().u_regs[1] }
func (c *sigctxt) r2() uint64  { return c.regs().u_regs[2] }
func (c *sigctxt) r3() uint64  { return c.regs().u_regs[3] }
func (c *sigctxt) r4() uint64  { return c.regs().u_regs[4] }
func (c *sigctxt) r5() uint64  { return c.regs().u_regs[5] }
func (c *sigctxt) r6() uint64  { return c.regs().u_regs[6] }
func (c *sigctxt) r7() uint64  { return c.regs().u_regs[7] }
func (c *sigctxt) r8() uint64  { return c.regs().u_regs[8] }
func (c *sigctxt) r9() uint64  { return c.regs().u_regs[9] }
func (c *sigctxt) r10() uint64 { return c.regs().u_regs[10] }
func (c *sigctxt) r11() uint64 { return c.regs().u_regs[11] }
func (c *sigctxt) r12() uint64 { return c.regs().u_regs[12] }
func (c *sigctxt) r13() uint64 { return c.regs().u_regs[13] }
func (c *sigctxt) r14() uint64 { return c.regs().u_regs[14] }
func (c *sigctxt) r15() uint64 { return c.regs().u_regs[15] }

// On SPARC, R16-R31 are local and in registers, they are usually
// saved on the stack. The sigcontext contains a pointer to the
// saved register window.
func (c *sigctxt) r16() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 0)) }
func (c *sigctxt) r17() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 8)) }
func (c *sigctxt) r18() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 16)) }
func (c *sigctxt) r19() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 24)) }
func (c *sigctxt) r20() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 32)) }
func (c *sigctxt) r21() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 40)) }
func (c *sigctxt) r22() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 48)) }
func (c *sigctxt) r23() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 56)) }
func (c *sigctxt) r24() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 64)) }
func (c *sigctxt) r25() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 72)) }
func (c *sigctxt) r26() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 80)) }
func (c *sigctxt) r27() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 88)) }
func (c *sigctxt) r28() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 96)) }
func (c *sigctxt) r29() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 104)) }
func (c *sigctxt) r30() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 112)) }
func (c *sigctxt) r31() uint64 { return *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 120)) }

func (c *sigctxt) sp() uint64     { return c.regs().u_regs[14] + 0x7ff }
func (c *sigctxt) lr() uint64     { return c.regs().u_regs[15] }
func (c *sigctxt) pc() uint64     { return c.regs().tpc }
func (c *sigctxt) npc() uint64    { return c.regs().tnpc }
func (c *sigctxt) tstate() uint64 { return c.regs().tstate }
func (c *sigctxt) y() uint32      { return c.regs().y }
func (c *sigctxt) fprs() uint32   { return c.regs().fprs }
func (c *sigctxt) fp() uint64     { return c.r30() + 0x7ff }
func (c *sigctxt) fault() uint64  { return c.sigaddr() }

func (c *sigctxt) sigcode() uint64 { return uint64(c.info.si_code) }
func (c *sigctxt) sigaddr() uint64 {
	return *(*uint64)(add(unsafe.Pointer(c.info), 16))
}

func (c *sigctxt) set_pc(x uint64)  { c.regs().tpc = x; c.regs().tnpc = x + 4 }
func (c *sigctxt) set_npc(x uint64) { c.regs().tnpc = x }
func (c *sigctxt) set_sp(x uint64)  { c.regs().u_regs[14] = x - 0x7ff }
func (c *sigctxt) set_lr(x uint64)  { c.regs().u_regs[15] = x }
func (c *sigctxt) set_g(x uint64)   { c.regs().u_regs[3] = x }
func (c *sigctxt) set_fp(x uint64)  { *(*uint64)(unsafe.Pointer(c.regs().rwin_save + 112)) = x - 0x7ff }
func (c *sigctxt) set_r3(x uint64)  { c.regs().u_regs[3] = x }

func (c *sigctxt) set_sigaddr(x uint64) {
	*(*uint64)(add(unsafe.Pointer(c.info), 16)) = x
}
