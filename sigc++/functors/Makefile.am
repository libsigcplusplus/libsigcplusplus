sigc_m4 = closure.h.m4 ptr_fun.h.m4 mem_fun.h.m4
sigc_built_cc =
sigc_built_h = closure.h ptr_fun.h mem_fun.h

include $(top_srcdir)/sigc++/Makefile.am_fragment

EXTRA_DIST = $(sigc_m4) $(sigc_built_h) functors.h

# install the headers
library_includedir = $(includedir)/sigc++-2.0/sigc++/functors
library_include_HEADERS = $(sigc_built_h) functor_trait.h functors.h

# build the library
noinst_LTLIBRARIES = libsigc_functors.la
libsigc_functors_la_SOURCES = closure.cc



