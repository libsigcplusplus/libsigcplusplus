# Base (./)
base_m4 = template.macros.m4 callof.h.m4 signal.h.m4
base_built_cc =
base_built_h = callof.h signal.h

signal.cc : signal.h functors/closure.h

# Functors (functors/)
functors_m4 = closure.h.m4 ptr_fun.h.m4 mem_fun.h.m4
functors_built_cc = 
functors_built_h = closure.h ptr_fun.h mem_fun.h

functors/closure.cc : functors/closure.h

# Adaptors (adaptors/)
adaptors_m4 = adaptor_trait.h.m4 compose.h.m4 bind_return.h.m4 \
	      exception_catch.h.m4 bind.h.m4 hide.h.m4
adaptors_built_cc =
adaptors_built_h = adaptor_trait.h compose.h bind_return.h exception_catch.h \
                   bind.h hide.h

# Lambda (adaptors/lambda)
lambda_m4 = base.h.m4 select.h.m4 operator.h.m4 group.h.m4 lambda.cc.m4
lambda_built_cc = lambda.cc
lambda_built_h = base.h select.h operator.h group.h

adaptors/lambda/lambda.cc : $(sigc_built_h)

# Subdirectories needed also in the build dir
build_subdirs = functors adaptors adaptors/lambda

# Combine all the above parts with right directories prefixed
sigc_m4 = $(base_m4) \
	  $(patsubst %,functors/%,$(functors_m4)) \
          $(patsubst %,adaptors/%,$(adaptors_m4)) \
          $(patsubst %,adaptors/lambda/%,$(lambda_m4)) 
sigc_built_cc = $(base_built_cc) \
	  $(patsubst %,functors/%,$(functors_built_cc)) \
          $(patsubst %,adaptors/%,$(adaptors_built_cc)) \
          $(patsubst %,adaptors/lambda/%,$(lambda_built_cc)) 
sigc_built_h = $(base_built_h) \
	  $(patsubst %,functors/%,$(functors_built_h)) \
          $(patsubst %,adaptors/%,$(adaptors_built_h)) \
          $(patsubst %,adaptors/lambda/%,$(lambda_built_h)) 

EXTRA_DIST = $(sigc_m4) $(sigc_built_h) $(sigc_built_cc)

# install the headers
library_includedir = $(includedir)/sigc++-2.0/sigc++
nobase_library_include_HEADERS = $(sigc_built_h) \
  trackable.h connection.h type_traits.h visit_each.h \
  functors/functor_trait.h functors/functors.h \
  adaptors/adaptors.h \
  adaptors/lambda/lambda.h

# build the library
lib_LTLIBRARIES = libsigc-2.0.la
libsigc_2_0_la_SOURCES = signal.cc trackable.cc connection.cc \
                         functors/closure.cc \
			 adaptors/lambda/lambda.cc

BUILT_SOURCES = $(sigc_built_h) $(sigc_built_cc)

CLEANFILES = build-subdirs-stamp

# Remove the generated sources during maintainer-clean:
MAINTAINERCLEANFILES = $(built_sources)

M4_DIR = $(top_srcdir)/sigc++

# Rules to generate .h and .cc from .h.m4 and .cc.m4:
%.h: %.h.m4 $(M4_DIR)/template.macros.m4
	        $(M4) $(M4_INCLUDES) $(DEFINES) -I $(M4_DIR) $<  > $@

%.cc: %.cc.m4 $(M4_DIR)/template.macros.m4
	        $(M4) $(M4_INCLUDES) $(DEFINES) -I $(M4_DIR) $<  > $@

# This would be a necessary target for VPATH builds from a clean CVS checkout,
# but I'm not sure where to invoke it...
build-subdirs-stamp:
	for dir in $(build_subdirs); do \
	  test -d $$dir || mkdir $$dir; \
	done
	touch build-subdirs-stamp

# Remove current directory from DEFAULT_INCLUDES because signal.h has
# the same name as a standard header:
DEFAULT_INCLUDES =
AM_CPPFLAGS = -I$(top_srcdir) -I$(top_builddir)

