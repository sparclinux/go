// Created by cgo -godefs - DO NOT EDIT
// cgo -godefs defs_linux.go defs1_linux.go

package runtime

const (
	_EINTR	= 0x4
	_EAGAIN	= 0xb
	_ENOMEM	= 0xc

	_PROT_NONE = 0x0
	_PROT_READ = 0x1
	_PROT_WRITE = 0x2
	_PROT_EXEC = 0x4

	_MAP_ANON = 0x20
	_MAP_PRIVATE = 0x2
	_MAP_FIXED = 0x10

	_MADV_DONTNEED = 0x4
	_MADV_HUGEPAGE = 0xe
	_MADV_NOHUGEPAGE = 0xf

	_SA_RESTART = 0x2
	_SA_ONSTACK = 0x1
	_SA_SIGINFO = 0x200

	_SIGHUP	= 0x1
	_SIGINT	= 0x2
	_SIGQUIT = 0x3
	_SIGILL	= 0x4
	_SIGTRAP = 0x5
	_SIGABRT = 0x6
	_SIGBUS	= 0xa
	_SIGFPE	= 0x8
	_SIGKILL = 0x9
	_SIGUSR1 = 0x1e
	_SIGSEGV = 0xb
	_SIGUSR2 = 0x1f
	_SIGPIPE = 0xd
	_SIGALRM = 0xe

	_SIGCHLD = 0x14
	_SIGCONT = 0x13
	_SIGSTOP = 0x11
	_SIGTSTP = 0x12
	_SIGTTIN = 0x15
	_SIGTTOU = 0x16
	_SIGURG	= 0x10
	_SIGXCPU = 0x18
	_SIGXFSZ = 0x19
	_SIGVTALRM = 0x1a
	_SIGPROF = 0x1b
	_SIGWINCH = 0x1c
	_SIGIO	= 0x17
	_SIGPWR	= 0x1d
	_SIGSYS	= 0xc

	_FPE_INTDIV = 0x1
	_FPE_INTOVF = 0x2
	_FPE_FLTDIV = 0x3
	_FPE_FLTOVF = 0x4
	_FPE_FLTUND = 0x5
	_FPE_FLTRES = 0x6
	_FPE_FLTINV = 0x7
	_FPE_FLTSUB = 0x8

	_BUS_ADRALN = 0x1
	_BUS_ADRERR = 0x2
	_BUS_OBJERR = 0x3

	_SEGV_MAPERR = 0x1
	_SEGV_ACCERR = 0x2

	_ITIMER_REAL	= 0x0
	_ITIMER_VIRTUAL	= 0x1
	_ITIMER_PROF	= 0x2

	_EPOLLIN = 0x1
	_EPOLLOUT = 0x4
	_EPOLLERR = 0x8
	_EPOLLHUP = 0x10
	_EPOLLRDHUP = 0x2000
	_EPOLLET = 0x80000000
	_EPOLL_CLOEXEC = 0x400000
	_EPOLL_CTL_ADD = 0x1
	_EPOLL_CTL_DEL = 0x2
	_EPOLL_CTL_MOD = 0x3
)

//type Sigset uint64
type timespec struct {
	tv_sec	int64
	tv_nsec	int64
}

func (ts *timespec) set_sec(x int64) {
        ts.tv_sec = x
}

func (ts *timespec) set_nsec(x int32) {
        ts.tv_nsec = int64(x)
}

type timeval struct {
	tv_sec		int64
	tv_usec		int32
	Pad_cgo_0	[4]byte
}

func (tv *timeval) set_usec(x int32) {
        tv.tv_usec = x
}

type sigactiont struct {
        sa_handler  uintptr
        sa_flags    uint64
        sa_restorer uintptr
        sa_mask     uint64
}

type siginfo struct {
	si_signo	int32
	si_errno	int32
	si_code		int32
	pad_cgo_0	[4]byte
	X_sifields	[112]byte
}

type itimerval struct {
        it_interval timeval
        it_value    timeval
}

type epollevent struct {
        events    uint32
        pad_cgo_0 [4]byte
        data      [8]byte // unaligned uintptr
}

const (
	_O_RDONLY    = 0x0
	_O_CLOEXEC   = 0x400000
	_SA_RESTORER = 0
)

type sigaltstackt struct {
	ss_sp		*byte
	ss_flags	int32
	pad_cgo_0	[4]byte
	ss_size		uintptr
}

type sigcontext struct {
	si_info		[128]int8
	u_regs		[16]uint64
	tstate		uint64
	tpc		uint64
	tnpc		uint64
	y		uint32
	fprs		uint32
	fpu_save	uintptr
	ss_sp		uintptr
	ss_flags	int32
	pad_cgo_0	[4]byte
	ss_size		uintptr
	sig_mask	uint64
	rwin_save	uintptr
}

type ucontext struct {
	uc_link		*ucontext
	uc_flags	uint64
	uc_sigmask	uint64
	pad_cgo_0	[8]byte
	uc_mcontext	sigcontext
	uc_stack	sigaltstackt
}
