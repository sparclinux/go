// Copyright 2016 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package runtime

import (
	"runtime/internal/sys"
	"unsafe"
)

type sigctxt struct {
	info *siginfo
	ctxt unsafe.Pointer
}

func (c *sigctxt) regs() *sigcontext {
	return &(*ucontext)(c.ctxt).uc_mcontext
}

// SPARC64 registers in signal context:
// - u_regs[0-7]: g0-g7 (global registers)
// - u_regs[8-15]: o0-o7 (output registers)
// Note: Local and input registers (l0-l7, i0-i7) are in the register
// window on the stack, not directly in the signal context.

func (c *sigctxt) r0() uint64  { return 0 } // g0 is always zero
func (c *sigctxt) r1() uint64  { return c.regs().Regs.u_regs[1] }  // g1
func (c *sigctxt) r2() uint64  { return c.regs().Regs.u_regs[2] }  // g2
func (c *sigctxt) r3() uint64  { return c.regs().Regs.u_regs[3] }  // g3
func (c *sigctxt) r4() uint64  { return c.regs().Regs.u_regs[4] }  // g4
func (c *sigctxt) r5() uint64  { return c.regs().Regs.u_regs[5] }  // g5
func (c *sigctxt) r6() uint64  { return c.regs().Regs.u_regs[6] }  // g6
func (c *sigctxt) r7() uint64  { return c.regs().Regs.u_regs[7] }  // g7
func (c *sigctxt) r8() uint64  { return c.regs().Regs.u_regs[8] }  // o0
func (c *sigctxt) r9() uint64  { return c.regs().Regs.u_regs[9] }  // o1
func (c *sigctxt) r10() uint64 { return c.regs().Regs.u_regs[10] } // o2
func (c *sigctxt) r11() uint64 { return c.regs().Regs.u_regs[11] } // o3
func (c *sigctxt) r12() uint64 { return c.regs().Regs.u_regs[12] } // o4
func (c *sigctxt) r13() uint64 { return c.regs().Regs.u_regs[13] } // o5
func (c *sigctxt) r14() uint64 { return c.regs().Regs.u_regs[14] } // o6 (sp)
func (c *sigctxt) r15() uint64 { return c.regs().Regs.u_regs[15] } // o7 (link)

// Registers r16-r31 (i0-i7, l0-l7) are not directly accessible
// from the signal context as they're in the register window.
// Return zeros for now.
func (c *sigctxt) r16() uint64 { return 0 }
func (c *sigctxt) r17() uint64 { return 0 }
func (c *sigctxt) r18() uint64 { return 0 }
func (c *sigctxt) r19() uint64 { return 0 }
func (c *sigctxt) r20() uint64 { return 0 }
func (c *sigctxt) r21() uint64 { return 0 }
func (c *sigctxt) r22() uint64 { return 0 }
func (c *sigctxt) r23() uint64 { return 0 }
func (c *sigctxt) r24() uint64 { return 0 }
func (c *sigctxt) r25() uint64 { return 0 }
func (c *sigctxt) r26() uint64 { return 0 }
func (c *sigctxt) r27() uint64 { return 0 }
func (c *sigctxt) r28() uint64 { return 0 }
func (c *sigctxt) r29() uint64 { return 0 }
func (c *sigctxt) r30() uint64 { return 0 }
func (c *sigctxt) r31() uint64 { return 0 }

func (c *sigctxt) sp() uint64   { return c.regs().Regs.u_regs[14] } // o6
func (c *sigctxt) pc() uint64   { return c.regs().Regs.tpc }
func (c *sigctxt) npc() uint64  { return c.regs().Regs.tnpc }
func (c *sigctxt) fp() uint64   { return 0 } // i6 not directly accessible
func (c *sigctxt) lr() uint64   { return c.regs().Regs.u_regs[15] } // o7
func (c *sigctxt) link() uint64 { return c.regs().Regs.u_regs[15] } // o7

func (c *sigctxt) sigcode() uint32 { return uint32(c.info.si_code) }
func (c *sigctxt) sigaddr() uint64 { return c.info.si_addr }
func (c *sigctxt) fault() uintptr  { return uintptr(c.info.si_addr) }

func (c *sigctxt) set_r1(x uint64)   { c.regs().Regs.u_regs[1] = x }
func (c *sigctxt) set_r3(x uint64)   { c.regs().Regs.u_regs[3] = x }
func (c *sigctxt) set_r14(x uint64)  { c.regs().Regs.u_regs[14] = x }
func (c *sigctxt) set_r15(x uint64)  { c.regs().Regs.u_regs[15] = x }
func (c *sigctxt) set_pc(x uint64)   { c.regs().Regs.tpc = x }
func (c *sigctxt) set_npc(x uint64)  { c.regs().Regs.tnpc = x }
func (c *sigctxt) set_sp(x uint64)   { c.regs().Regs.u_regs[14] = x }
func (c *sigctxt) set_fp(x uint64)   { } // i6 not directly accessible
func (c *sigctxt) set_lr(x uint64)   { c.regs().Regs.u_regs[15] = x }
func (c *sigctxt) set_link(x uint64) { c.regs().Regs.u_regs[15] = x }

func (c *sigctxt) set_sigcode(x uint32) { c.info.si_code = int32(x) }
func (c *sigctxt) set_sigaddr(x uint64) {
	*(*uintptr)(add(unsafe.Pointer(c.info), 2*sys.PtrSize)) = uintptr(x)
}
