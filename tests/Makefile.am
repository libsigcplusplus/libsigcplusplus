INCLUDES = -I$(top_srcdir) -I$(top_builddir)

LDADD = $(top_builddir)/sigc++/libsigc-2.0.la

# don't bother with automake defs
DEFS =

# this means make check will run these programs.
noinst_PROGRAMS= \
  test_callof \
  test_mem_fun \
  test_ptr_fun \
  test_compose \
  test_bind_return \
  test_bind \
  test_closure \
  test_signal \
  test_exception_catch \
  test_hide \
  test_functor_trait \
  test_lambda \
  test_trackable 

TESTS = $(noinst_PROGRAMS)


# we can have as may programs built here as we need.
test_callof_SOURCES = test_callof.cc 
test_compose_SOURCES = test_compose.cc 
test_bind_return_SOURCES = test_bind_return.cc 
test_bind_SOURCES = test_bind.cc
test_exception_catch_SOURCES = test_exception_catch.cc 
test_closure_SOURCES = test_closure.cc 
test_signal_SOURCES = test_signal.cc 
test_mem_fun_SOURCES = test_mem_fun.cc 
test_ptr_fun_SOURCES = test_ptr_fun.cc 
test_hide_SOURCES = test_hide.cc 
test_functor_trait_SOURCES = test_functor_trait.cc 
test_lambda_SOURCES = test_lambda.cc 
test_trackable_SOURCES = test_trackable.cc 
