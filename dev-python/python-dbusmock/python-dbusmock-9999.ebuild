# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="mock D-Bus objects for tests "
HOMEPAGE="https://github.com/martinpitt/python-dbusmock"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/martinpitt/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/martinpitt/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3+"
SLOT="0"

DEPEND="dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
