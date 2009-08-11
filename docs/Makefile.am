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

book_name  = libsigc++-$(SIGCXX_API_VERSION)
pubdocbase = http://libsigc.sourceforge.net/
htmlrefpub = $(pubdocbase)libsigc2/docs/reference/html

doc_input = $(addprefix $(top_srcdir)/sigc++/,$(sigc_public_h)) \
	    $(addprefix $(top_builddir)/sigc++/,$(sigc_built_h))

include $(top_srcdir)/scripts/doc-reference.am

doc_imagesdir = $(libdocdir)/images
dist_libdoc_DATA = index.html
dist_doc_images_DATA = images/libsigc_logo.gif images/top.gif

include $(srcdir)/doc-manual.am
