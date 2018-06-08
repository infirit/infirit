# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eapi7-ver multilib python-single-r1 xdg-utils

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/exaile/exaile.git"
	MY_PV="${PV}"
	KEYWORDS=""
else
	MY_PV="$(ver_rs 3 '-')"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~arm"
fi

DESCRIPTION="a media player aiming to be similar to AmaroK, but for GTK+"
HOMEPAGE="http://www.exaile.org/"

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="cddb libnotify moodbar nls scrobbler"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/bsddb3[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gst-python:1.0[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=x11-libs/gtk+-3.10:3[introspection]
	>=dev-python/pygobject-3.13.2:3[${PYTHON_USEDEP}]
	>=media-libs/gst-plugins-base-1.6:1.0
	>=media-libs/gst-plugins-good-1.4:1.0
	>=media-libs/mutagen-1.10[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-meta:1.0
	cddb? ( dev-python/cddb-py )
	scrobbler? ( dev-python/pylast[${PYTHON_USEDEP}] )
	libnotify? ( dev-python/notify-python )
	moodbar? ( media-sound/moodbar )"
DEPEND="
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

RESTRICT="test" #315589

S="${WORKDIR}/${PN}-${MY_PV}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_compile() {
	if use nls; then
		emake locale
	fi
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBINSTALLDIR=/usr/$(get_libdir) \
		DESTDIR="${D}" \
		install$(use nls || echo _no_locale)

	python_optimize "${D}$(get_libdir)/${PN}"
	python_optimize "${D}/usr/share/${PN}"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
