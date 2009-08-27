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

include $(top_srcdir)/sigc++/filelist.am

book_name = libsigc++-$(SIGCXX_API_VERSION)

# For each header file, test whether it exists in the build directory.
# If it does, return its relative path.  Otherwise, assume the file is
# present in the source directory and return the relative path to that
# location.
libsigc_h = $(sigc_public_h) $(sigc_built_h)
vp_select = $(or $(wildcard $(top_builddir)/sigc++/$(file)),$(top_srcdir)/sigc++/$(file))
vp_search = $(foreach file,$(libsigc_h),$(vp_select))
doc_input = $(if $(srcdir:.=),$(vp_search),$(addprefix $(top_builddir)/sigc++/,$(libsigc_h)))

include $(top_srcdir)/build/doc-reference.am

doc_imagesdir = $(libdocdir)/images
dist_libdoc_DATA = index.html
dist_doc_images_DATA = images/libsigc_logo.gif images/top.gif

dist_noinst_DATA += doc-install.pl doc-postprocess.pl doxygen.css tagfile-to-devhelp2.xsl

include $(srcdir)/doc-manual.am
