## Copyright (c) 2009  Openismus GmbH  <http://www.openismus.com/>
##
## This file is part of libsigc++.
##
## libsigc++ is free software: you can redistribute it and/or modify it
## under the terms of the GNU Lesser General Public License as published
## by the Free Software Foundation, either version 2.1 of the License,
## or (at your option) any later version.
##
## libsigc++ is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this library.  If not, see <http://www.gnu.org/licenses/>.

ACLOCAL_AMFLAGS = -I scripts ${ACLOCAL_FLAGS}

if ENABLE_DOCUMENTATION
doc_subdirs = docs
else
doc_subdirs =
endif
SUBDIRS = sigc++ tests examples $(doc_subdirs) MSVC_Net2005 MSVC_Net2008

sigc_configdir = $(libdir)/sigc++-2.0/include
nodist_sigc_config_HEADERS = sigc++config.h

pkgconfigdir = $(libdir)/pkgconfig
nodist_pkgconfig_DATA = sigc++-2.0.pc
noinst_DATA = sigc++-2.0-uninstalled.pc

dist_noinst_SCRIPTS = autogen.sh

dist_noinst_DATA =			\
	scripts/doc-install.pl		\
	scripts/doc-postprocess.pl	\
	scripts/tagfile-to-devhelp2.xsl
