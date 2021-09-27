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

include $(srcdir)/MSVC_NMake/filelist.am

dist_noinst_DATA = $(addprefix MSVC_NMake/,$(msvc_nmake_data))

DISTCLEANFILES = MSVC_NMake/sigc++config.h

# Distribute files needed when building libsigc++ with meson.
EXTRA_DIST = \
  meson.build \
  meson_options.txt \
  sigc++config.h.meson \
  MSVC_NMake/meson.build \
  docs/manual/can_use_xmllint.xml \
  docs/manual/meson.build \
  docs/reference/meson.build \
  examples/meson.build \
  sigc++/meson.build \
  subprojects/mm-common.wrap \
  tests/meson.build \
  tools/handle-built-files.py \
  tools/tutorial-custom-cmd.py \
  tools/gcc_template_specialization_operator_overload.cc \
  tools/have_sun_reverse_iterator.cc \
  tools/msvc_template_specialization_operator_overload.cc \
  tools/pragma_push_pop_macro.cc \
  untracked/README

# Optional: auto-generate the ChangeLog file from the git log on make dist
include $(top_srcdir)/build/dist-changelog.am
