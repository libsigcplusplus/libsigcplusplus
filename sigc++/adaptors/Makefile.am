SUBDIRS = #lambda

sigc_m4 = adaptor_trait.h.m4 \
          compose.h.m4 bind_return.h.m4 exception_catch.h.m4 \
          bind.h.m4 hide.h.m4
sigc_built_cc = 
sigc_built_h = adaptor_trait.h compose.h bind_return.h exception_catch.h \
               bind.h hide.h

include $(top_srcdir)/sigc++/Makefile.am_fragment

EXTRA_DIST = $(sigc_m4) adaptors.h

# install the headers
sigcdir = $(includedir)/sigc++-2.0/sigc++/adaptors
sigc_HEADERS = $(sigc_built_h)

