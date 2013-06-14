# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"
MATE_LA_PUNT="yes"

inherit eutils mate

DESCRIPTION="Color profile manager for the GNOME desktop"
HOMEPAGE="http://projects.gnome.org/gnome-color-manager/"
SRC_URI="https://github.com/NiceandGently/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/glib-2.14:2
	>=dev-libs/dbus-glib-0.73
	>=dev-libs/libunique-1:1
	>=mate-base/mate-desktop-1.2.0
	media-gfx/sane-backends
	media-libs/lcms:0
	media-libs/libcanberra[gtk]
	media-libs/tiff
	net-print/cups
	virtual/udev[gudev]
	x11-libs/libX11
	x11-libs/libXxf86vm
	x11-libs/libXrandr
	>=x11-libs/gtk+-2.14:2
	>=x11-libs/libnotify-0.7.0
	>=x11-libs/vte-0.22:0
"
DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=dev-util/intltool-0.35
"

# FIXME: run test-suite with files on live file-system
RESTRICT="test"

pkg_setup() {
	# Always enable tests since they are check_PROGRAMS anyway
	G2CONF="${G2CONF} --enable-tests --disable-packagekit"
}
