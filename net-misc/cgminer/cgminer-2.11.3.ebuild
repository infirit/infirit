# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator flag-o-matic

DESCRIPTION="Bitcoin CPU/GPU/FPGA miner in C"
HOMEPAGE="http://bitcointalk.org/?topic=28402.msg357369"
SRC_URI="http://ck.kolivas.org/apps/cgminer/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples ncurses +cpumining altivec padlock sse2 sse2_4way sse4 opencl adl scrypt
	-udev -bitforce -icarus -modminer -ztex"

REQUIRED_USE="|| ( cpumining opencl bitforce icarus modminer ztex )
	adl? ( opencl )
	altivec? ( cpumining ppc ppc64 )
	opencl? ( ncurses )
	padlock? ( cpumining || ( amd64 x86 ) )
	scrypt? ( opencl )
	sse2? ( cpumining || ( amd64 x86 ) )
	sse4? ( cpumining amd64 )"

DEPEND="net-misc/curl
	dev-libs/jansson
	ncurses? ( sys-libs/ncurses )
	opencl? ( virtual/opencl )
	udev? (	virtual/udev )
	ztex? (	virtual/libusb:1 )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's/\(^\#define WANT_.*\(SSE\|PADLOCK\|ALTIVEC\)\)/\/\/ \1/' miner.h
	ln -s /usr/include/ADL/* ADL_SDK/
}

src_configure() {
	if ! use altivec; then
		sed -i 's/-faltivec//g' configure
	else
		append-cflags "-DWANT_ALTIVEC=1"
	fi
	use padlock && append-cflags "-DWANT_VIA_PADLOCK=1"
	if use sse2; then
		use amd64 && append-cflags "-DWANT_X8664_SSE2=1" \
			|| append-cflags "-DWANT_X8632_SSE2=1"
	fi
	use sse2_4way && append-cflags "-DWANT_SSE2_4WAY=1"
	use sse4 && append-cflags "-DWANT_X8664_SSE4=1"
	use hardened && append-cflags "-nopie"

	econf $(use_with ncurses curses) \
		$(use_enable cpumining) \
		$(use_enable opencl) \
		$(use_enable adl) \
		$(use_enable scrypt) \
		$(use_with udev libudev) \
		$(use_enable bitforce) \
		$(use_enable icarus) \
		$(use_enable modminer) \
		$(use_enable ztex)
	# sanitize directories
	sed -i 's~^\(\#define CGMINER_PREFIX \).*$~\1"'"${EPREFIX}/usr/lib/cgminer"'"~' config.h
}

src_install() { # How about using some make install?
	dobin cgminer
	if use doc; then
		dodoc AUTHORS NEWS README API-README
		use scrypt && dodoc SCRYPT-README
		use icarus || use bitforce && dodoc FPGA-README
	fi

	if use modminer; then
		insinto /usr/lib/cgminer/modminer
		doins bitstreams/*.ncd
		dodoc bitstreams/COPYING_fpgaminer
	fi
	if use opencl; then
		insinto /usr/lib/cgminer
		doins *.cl
	fi
	if use ztex; then
		insinto /usr/lib/cgminer/ztex
		doins bitstreams/*.bit
		dodoc bitstreams/COPYING_ztex
	fi
	if use examples; then
		docinto examples
		dodoc api-example.php miner.php API.java api-example.c
	fi
}
