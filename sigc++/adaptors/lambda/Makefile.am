sigc_m4 = base.h.m4 select.h.m4 operator.h.m4 group.h.m4 lambda.cc.m4
sigc_built_cc = lambda.cc
sigc_built_h = base.h select.h operator.h group.h

include $(top_srcdir)/sigc++/Makefile.am_fragment

EXTRA_DIST = $(sigc_m4) lambda.h

# install the headers
library_includedir = $(includedir)/sigc++-2.0/sigc++/adaptors/lambda
library_include_HEADERS = $(sigc_built_h)

# build the library
noinst_LTLIBRARIES = libsigc_adaptors_lambda.la
libsigc_adaptors_lambda_la_SOURCES = lambda.cc $(built_sources)

