# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils autotools

DESCRIPTION="The moodbar tool and gstreamer plugin for Amarok"
HOMEPAGE="https://userbase.kde.org/Amarok/Manual/Various/Moodbar"
SRC_URI="https://github.com/Mazhoon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-plugins/gst-plugins-meta:1.0
	sci-libs/fftw:3.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	NOCONFIGURE=1 ./autogen.sh
}

src_install() {
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	einfo "Make sure to enable audio file support on media-plugins/gst-plugins-meta"
}
