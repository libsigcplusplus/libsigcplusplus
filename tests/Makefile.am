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

AM_CPPFLAGS = -I$(top_builddir) -I$(top_srcdir)
AM_CXXFLAGS = $(SIGC_WXXFLAGS)
LDADD       = $(top_builddir)/sigc++/libsigc-$(SIGCXX_API_VERSION).la

check_PROGRAMS = \
  test_accum_iter \
  test_accumulated \
  test_bind \
  test_bind_ref \
  test_bind_refptr \
  test_bind_return \
  test_compose \
  test_copy_invalid_slot \
  test_cpp11_lambda \
  test_custom \
  test_deduce_result_type \
  test_disconnect \
  test_disconnect_during_emit \
  test_exception_catch \
  test_functor_trait \
  test_hide \
  test_lambda \
  test_limit_reference \
  test_mem_fun \
  test_ptr_fun \
  test_retype \
  test_retype_return \
  test_signal \
  test_size \
  test_slot \
  test_slot_disconnect \
  test_trackable \
  test_track_obj \
  test_visit_each

TESTS = $(check_PROGRAMS)

sigc_test_util = testutilities.h testutilities.cc

test_accum_iter_SOURCES      = test_accum_iter.cc $(sigc_test_util)
test_accumulated_SOURCES     = test_accumulated.cc $(sigc_test_util)
test_bind_SOURCES            = test_bind.cc $(sigc_test_util)
test_bind_ref_SOURCES        = test_bind_ref.cc $(sigc_test_util)
test_bind_refptr_SOURCES     = test_bind_refptr.cc $(sigc_test_util)
test_bind_return_SOURCES     = test_bind_return.cc $(sigc_test_util)
test_compose_SOURCES         = test_compose.cc $(sigc_test_util)
test_copy_invalid_slot_SOURCES = test_copy_invalid_slot.cc $(sigc_test_util)
test_cpp11_lambda_SOURCES    = test_cpp11_lambda.cc $(sigc_test_util)
test_custom_SOURCES          = test_custom.cc $(sigc_test_util)
test_deduce_result_type_SOURCES = test_deduce_result_type.cc $(sigc_test_util)
test_disconnect_SOURCES      = test_disconnect.cc $(sigc_test_util)
test_disconnect_during_emit_SOURCES = test_disconnect_during_emit.cc $(sigc_test_util)
test_exception_catch_SOURCES = test_exception_catch.cc $(sigc_test_util)
test_functor_trait_SOURCES   = test_functor_trait.cc $(sigc_test_util)
test_hide_SOURCES            = test_hide.cc $(sigc_test_util)
test_lambda_SOURCES          = test_lambda.cc $(sigc_test_util)
test_limit_reference_SOURCES = test_limit_reference.cc $(sigc_test_util)
test_mem_fun_SOURCES         = test_mem_fun.cc $(sigc_test_util)
test_ptr_fun_SOURCES         = test_ptr_fun.cc $(sigc_test_util)
test_retype_SOURCES          = test_retype.cc $(sigc_test_util)
test_retype_return_SOURCES   = test_retype_return.cc $(sigc_test_util)
test_signal_SOURCES          = test_signal.cc $(sigc_test_util)
test_size_SOURCES            = test_size.cc $(sigc_test_util)
test_slot_SOURCES            = test_slot.cc $(sigc_test_util)
test_slot_disconnect_SOURCES = test_slot_disconnect.cc $(sigc_test_util)
test_trackable_SOURCES       = test_trackable.cc $(sigc_test_util)
test_track_obj_SOURCES       = test_track_obj.cc $(sigc_test_util)
test_visit_each_SOURCES      = test_visit_each.cc $(sigc_test_util)

# 2005-01-19
# Disabled: test_lambda - The Tru64 compiler can't build this when not using
#  -std strict_ansi -model ansi, so let's not worry about it.
# 2012-03-19
# Enabled test_lambda. See https://bugzilla.gnome.org/show_bug.cgi?id=669128
# TODO: Disable once again, if some compiler still can't build it (tested with gcc 4.6.1)

#dist_noinst_DATA = test_lambda.cc
