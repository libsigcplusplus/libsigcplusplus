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
doc_subdirs = docs/docs
else
doc_subdirs =
endif
SUBDIRS = sigc++ tests examples cmake $(doc_subdirs)

sigc_configdir = $(libdir)/$(SIGCXX_MODULE_NAME)/include
nodist_sigc_config_HEADERS = sigc++config.h

pkgconfigdir = $(libdir)/pkgconfig
nodist_pkgconfig_DATA = $(SIGCXX_MODULE_NAME).pc
noinst_DATA = $(SIGCXX_MODULE_NAME)-uninstalled.pc

dist_noinst_SCRIPTS = autogen.sh

include $(srcdir)/MSVC_NMake/filelist.am

dist_noinst_DATA = \
  $(addprefix MSVC_NMake/,$(msvc_nmake_data)) \
  CMakeLists.txt \
  sigc++config.h.cmake \
  cmake_uninstall.cmake.in \
  README.md

DISTCLEANFILES = MSVC_NMake/sigc++config.h

# Distribute files needed when building libsigc++ with meson.
EXTRA_DIST = \
  meson.build \
  meson_options.txt \
  sigc++config.h.meson \
  MSVC_NMake/meson.build \
  docs/docs/manual/can_use_xmllint.xml \
  docs/docs/manual/meson.build \
  docs/docs/reference/meson.build \
  examples/meson.build \
  sigc++/meson.build \
  subprojects/mm-common.wrap \
  tests/meson.build \
  tools/handle-built-files.py \
  tools/tutorial-custom-cmd.py \
  untracked/README

# Optional: auto-generate the ChangeLog file from the git log on make dist
include $(top_srcdir)/build/dist-changelog.am

# Run clang-format over all the files, to reformat them.
# (We don't use xargs here because that wouldn't let us specify different
# clang-format versions via a bash alias.)
format:
	clang-format -i `find . -name "*.h" -or -name "*.cc"`

# Run clang-format over all files, and fail if they are not formatted correctly.
# (This requires clang-format 10, which has the --dry-run and --Werror
# command-line arguments.)
check-format:
	clang-format --dry-run --Werror `find . -name "*.h" -or -name "*.cc"`
