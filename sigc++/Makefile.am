SUBDIRS = functors adaptors


sigc_m4 = callof.h.m4 signal.h.m4 template.macros.m4
sigc_built_cc =
sigc_built_h = callof.h signal.h

signal.cc : signal.h

include $(top_srcdir)/sigc++/Makefile.am_fragment


EXTRA_DIST = $(sigc_m4) $(sigc_built_h) Makefile.am_fragment

# install the headers
library_includedir = $(includedir)/sigc++-2.0/sigc++
library_include_HEADERS = $(sigc_built_h) trackable.h type_traits.h visit_each.h

# build the library
lib_LTLIBRARIES = libsigc-2.0.la
libsigc_2_0_la_SOURCES = signal.cc trackable.cc
libsigc_2_0_la_LIBADD = functors/libsigc_functors.la
                        # adaptors/lambda/libsigc_adaptors_lambda.la 
                        



