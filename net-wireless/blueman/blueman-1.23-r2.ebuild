# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/blueman/blueman-1.23-r2.ebuild,v 1.1 2012/06/20 06:12:44 dev-zero Exp $

EAPI="4"

PYTHON_DEPEND="2:2.7"

inherit autotools eutils python gnome2-utils

DESCRIPTION="GTK+ Bluetooth Manager, designed to be simple and intuitive for everyday bluetooth tasks."
HOMEPAGE="http://blueman-project.org/"
SRC_URI="http://download.tuxfamily.org/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gconf gnome-sendto mate-sendto network nls policykit pulseaudio"

CDEPEND="dev-libs/glib:2
	>=x11-libs/gtk+-2.12:2
	x11-libs/startup-notification
	dev-python/pygobject:2
	>=net-wireless/bluez-4.21"
DEPEND="${CDEPEND}
	nls? ( dev-util/intltool sys-devel/gettext )
	virtual/pkgconfig
	>=dev-python/pyrex-0.9.8"
RDEPEND="${CDEPEND}
	>=app-mobilephone/obex-data-server-0.4.4
	sys-apps/dbus
	dev-python/pygtk
	dev-python/notify-python
	dev-python/dbus-python
	x11-themes/hicolor-icon-theme
	gconf? ( dev-python/gconf-python )
	gnome-sendto? ( gnome-base/nautilus )
	network? ( || ( net-dns/dnsmasq
		=net-misc/dhcp-3*
		>=net-misc/networkmanager-0.8 ) )
	policykit? ( sys-auth/polkit )
	pulseaudio? ( media-sound/pulseaudio )"

pkg_setup() {
	python_set_active_version 2.7
	python_pkg_setup
}

src_prepare() {
	# disable pyc compiling
	#ln -sf $(type -P true) py-compile

	sed -i \
		-e '/^Encoding/d' \
		data/blueman-manager.desktop.in || die "sed failed"

}

src_configure() {
	econf \
		--disable-static \
		$(use_enable policykit polkit) \
		$(use_enable gnome-sendto) \
		$(use_enable mate-sendto) \
		--disable-hal \
		$(use_enable nls)
}

src_install() {
	default

	python_convert_shebangs 2.7 "${D}"/usr/bin/blueman-* "${D}/usr/libexec/blueman-mechanism"

	rm "${D}"/$(python_get_sitedir)/*.la
	use gnome-sendto || use mate-sendto && rm "${D}"/usr/lib*/nautilus-sendto/plugins/*.la

	use gconf || rm "${D}"/$(python_get_sitedir)/${PN}/plugins/config/Gconf.py
	use policykit || rm -rf "${D}"/usr/share/polkit-1
	use pulseaudio || rm "${D}"/$(python_get_sitedir)/${PN}/{main/Pulse*.py,plugins/applet/Pulse*.py}

	python_need_rebuild
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	python_mod_optimize ${PN}
	gnome2_icon_cache_update
}

pkg_postrm() {
	python_mod_cleanup ${PN}
	gnome2_icon_cache_update
}
