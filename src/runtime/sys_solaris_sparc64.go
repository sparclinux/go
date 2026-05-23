// Copyright 2016 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build solaris
// +build sparc64

package runtime

import (
	_ "unsafe" // for go:linkname
)

func usleep2(us uint32)

//go:linkname usleep1_go runtime.usleep1
//go:nosplit
func usleep1_go(µs uint32) {
	_g_ := getg()

	// Check the validity of m because we might be called in cgo callback
	// path early enough where there isn't a m available yet.
	if _g_ != nil && _g_.m != nil {
		sysvicall1(&libc_usleep, uintptr(µs))
		return
	}
	usleep2(µs)
}
