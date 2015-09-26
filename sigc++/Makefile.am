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

AUTOMAKE_OPTIONS = subdir-objects

include $(srcdir)/filelist.am

# Subdirectories needed also in the build dir
build_subdirs = functors adaptors/lambda

dist_noinst_DATA = $(sigc_m4)

library_includedir = $(includedir)/$(SIGCXX_MODULE_NAME)/sigc++
nobase_library_include_HEADERS = sigc++.h $(sigc_public_h) $(sigc_built_h)

lib_LTLIBRARIES = libsigc-@SIGCXX_API_VERSION@.la

libsigc_@SIGCXX_API_VERSION@_la_SOURCES =	\
	signal.cc				\
	signal_base.cc				\
	trackable.cc				\
	connection.cc				\
	functors/slot.cc			\
	functors/slot_base.cc			\
	adaptors/lambda/lambda.cc

EXTRA_libsigc_@SIGCXX_API_VERSION@_la_SOURCES = $(sigc_built_cc)

# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
libsigc_@SIGCXX_API_VERSION@_la_LDFLAGS = -no-undefined -version-info 0:0:0

AM_CPPFLAGS = -I$(top_builddir) -I$(top_srcdir)
AM_CXXFLAGS = $(SIGC_WXXFLAGS)

BUILT_SOURCES = $(build_subdirs) $(sigc_built_h) $(sigc_built_cc)
MAINTAINERCLEANFILES = $(sigc_built_h) $(sigc_built_cc)

m4_dir = $(srcdir)/macros

$(build_subdirs):
	$(AM_V_at)$(MKDIR_P) $@

signal.cc:			\
	signal.h		\
	signal_base.h		\
	functors/slot.h		\
	functors/slot_base.h	\
	functors/mem_fun.h	\
	functors/functor_trait.h

adaptors/lambda/lambda.cc:		\
	adaptors/lambda/select.h	\
	adaptors/lambda/base.h		\
	adaptors/adaptor_trait.h	\
	adaptors/deduce_result_type.h	\
	functors/ptr_fun.h		\
	functors/mem_fun.h		\
	functors/functor_trait.h

functors/slot.cc:		\
	functors/slot.h		\
	functors/slot_base.h	\
	functors/functor_trait.h

%.h: macros/%.h.m4 $(m4_dir)/template.macros.m4 | $(build_subdirs)
	$(AM_V_GEN)$(M4) -I $(m4_dir) -I macros $< >$@

%.cc: macros/%.cc.m4 $(m4_dir)/template.macros.m4 | $(build_subdirs)
	$(AM_V_GEN)$(M4) -I $(m4_dir) -I macros $< >$@
