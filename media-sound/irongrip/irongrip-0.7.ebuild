# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools

DESCRIPTION="A graphical Audio CD ripper and encoder with support for WAV, MP3, OggVorbis, FLAC and Opus"
HOMEPAGE="https://github.com/LinuxMatt/IronGrip"
SRC_URI="https://github.com/LinuxMatt/IronGrip/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3"

COMMON_DEPEND=">=media-libs/libcddb-0.9.5
	media-sound/cdparanoia
	x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"
RDEPEND="${COMMON_DEPEND}
	flac? ( media-libs/flac )
	mp3? ( media-sound/lame )"

DOCS="AUTHORS ChangeLog README TODO" # NEWS is dummy

S="${WORKDIR}/IronGrip-${PV}/${PN}"

src_prepare() {
	xxd -i pixmaps/${PN}.png > src/${PN}.icon.h
	xxd -i COPYING > src/license.gpl.h
	intltoolize --force --copy --automake
	autoreconf --verbose --force --install -Wno-portability
}
