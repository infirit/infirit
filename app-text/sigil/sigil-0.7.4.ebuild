# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
CMAKE_BUILD_TYPE="Release"

inherit eutils cmake-utils

MY_P="Sigil-${PV}-Code"

DESCRIPTION="Sigil is a multi-platform WYSIWYG ebook editor for ePub format."
HOMEPAGE="http://code.google.com/p/sigil/"
SRC_URI="https://${PN}.googlecode.com/files/${MY_P}.zip"

LICENSE="CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-text/hunspell-1.3.2
	>=dev-libs/boost-1.49
	>=dev-libs/libpcre-8.31[pcre16]
	>=dev-libs/xerces-c-3.1.1
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/linguist-tools:5
	dev-qt/qtwebkit:5[widgets]
	dev-qt/qtxmlpatterns:5
	>=sys-libs/zlib-1.2.7[minizip]"

DEPEND=">=dev-util/cmake-2.8.9
	${DEPEND}"

S="${WORKDIR}"

DOCS=( ChangeLog README )

src_prepare() {
	# use standard naming
	mv -f README.txt README
	mv -f ChangeLog.txt ChangeLog
	edos2unix ChangeLog README
}

pkg_postinst() {
	einfo "A comprehensive user guide is availabe from the sigil website."
	einfo "Get it from https://code.google.com/p/sigil/downloads/list"
}
