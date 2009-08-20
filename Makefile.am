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

ACLOCAL_AMFLAGS = -I build ${ACLOCAL_FLAGS}

if ENABLE_DOCUMENTATION
doc_subdirs = docs
else
doc_subdirs =
endif
SUBDIRS = sigc++ tests examples $(doc_subdirs)

sigc_configdir = $(libdir)/$(SIGCXX_MODULE_NAME)/include
nodist_sigc_config_HEADERS = sigc++config.h

pkgconfigdir = $(libdir)/pkgconfig
nodist_pkgconfig_DATA = $(SIGCXX_MODULE_NAME).pc
noinst_DATA = $(SIGCXX_MODULE_NAME)-uninstalled.pc

dist_noinst_SCRIPTS = autogen.sh

include $(srcdir)/MSVC_Net2005/filelist.am
include $(srcdir)/MSVC_Net2008/filelist.am

dist_noinst_DATA = $(addprefix MSVC_Net2005/,$(msvc_net2005_data)) \
                   $(addprefix MSVC_Net2008/,$(msvc_net2008_data))

DISTCLEANFILES = MSVC_Net2005/sigc++config.h MSVC_Net2008/sigc++config.h
