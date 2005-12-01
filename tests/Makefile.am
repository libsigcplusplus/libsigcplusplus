INCLUDES = -I$(top_srcdir) -I$(top_builddir)

LDADD = $(top_builddir)/sigc++/libsigc-2.0.la

# don't bother with automake defs
DEFS =

# this means make check will run these programs.
noinst_PROGRAMS= \
  test_trackable \
  test_deduce_result_type \
  test_mem_fun \
  test_ptr_fun \
  test_slot \
  test_signal \
  test_disconnect \
  test_disconnect_during_emit \
  test_bind_return \
  test_retype_return \
  test_hide \
  test_retype \
  test_compose \
  test_exception_catch \
  test_size \
  test_bind \
  test_bind_ref \
  test_functor_trait \
  test_compatibility \
  test_limit_reference \
  test_copy_invalid_slot \
  test_slot_disconnect \
  test_custom

#Disabled:
#   test_lambda - The Tru64 compiler can't build this when not using -std strict_ansi -model ansi, so let's not worry about it.

#  test_accumulated - The AIX xlC compiler can't build this. It says 
#  xlC_r  -I. -I. -I.. -I.. -I..    -AA -c -o test_accumulated.o test_accumulated.cc
# "../sigc++/signal.h", line 534.39: 1540-1110 (S) The referenced type "sigc::internal::signal_emit1" contains a circular reference back to ""

TESTS = $(noinst_PROGRAMS)


# we can have as many programs built here as we need.
test_trackable_SOURCES = test_trackable.cc
test_deduce_result_type_SOURCES = test_deduce_result_type.cc
test_functor_trait_SOURCES = test_functor_trait.cc
test_mem_fun_SOURCES = test_mem_fun.cc
test_ptr_fun_SOURCES = test_ptr_fun.cc
test_slot_SOURCES = test_slot.cc
test_signal_SOURCES = test_signal.cc
# test_accumulated_SOURCES = test_accumulated.cc
test_disconnect_SOURCES = test_disconnect.cc
test_disconnect_during_emit_SOURCES = test_disconnect_during_emit.cc
test_bind_SOURCES = test_bind.cc
test_bind_ref_SOURCES = test_bind_ref.cc
test_bind_return_SOURCES = test_bind_return.cc
test_retype_return_SOURCES = test_retype_return.cc
test_hide_SOURCES = test_hide.cc
test_retype_SOURCES = test_retype.cc
test_compose_SOURCES = test_compose.cc
test_exception_catch_SOURCES = test_exception_catch.cc
# test_lambda_SOURCES = test_lambda.cc

test_size_SOURCES = test_size.cc
test_compatibility_SOURCES = test_compatibility.cc
test_limit_reference_SOURCES = test_limit_reference.cc
test_copy_invalid_slot_SOURCES = test_copy_invalid_slot.cc
test_slot_disconnect_SOURCES = test_slot_disconnect.cc
test_custom_SOURCES = test_custom.cc
