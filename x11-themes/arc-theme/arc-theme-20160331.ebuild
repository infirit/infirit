# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="A flat theme with transparent elements"
HOMEPAGE="https://github.com/horst3180/arc-theme"
SRC_URI="https://github.com/horst3180/${PN}/archive/${PV}.tar.gz -> arc-theme-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cinnamon +gnome unity +xfce +transparency"

DEPEND=""
RDEPEND="${DEPEND} \
	x11-themes/gnome-themes-standard \
	x11-themes/gtk-engines-murrine"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--enable-gtk2 \
		--enable-gtk3 \
		--enable-light \
		--enable-darker \
		--enable-dark \
		$(use_enable cinnamon) \
		$(use_enable gnome gnome-shell) \
		$(use_enable gnome metacity) \
		$(use_enable xfce xfwm) \
		$(use_enable xfce xfce-notify) \
		$(use_enable transparency) \
		$(use_enable unity)
}
