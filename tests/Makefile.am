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

sigc_libs = $(top_builddir)/sigc++/libsigc-$(SIGCXX_API_VERSION).la
LDADD       = $(sigc_libs)

dist_noinst_DATA = CMakeLists.txt

check_PROGRAMS = \
  test_accum_iter \
  test_accumulated \
  test_bind \
  test_bind_as_slot \
  test_bind_ref \
  test_bind_refptr \
  test_bind_return \
  test_compose \
  test_connection \
  test_copy_invalid_slot \
  test_cpp11_lambda \
  test_custom \
  test_disconnect \
  test_disconnect_during_emit \
  test_exception_catch \
  test_hide \
  test_limit_reference \
  test_member_method_trait \
  test_mem_fun \
  test_ptr_fun \
  test_retype \
  test_retype_return \
  test_rvalue_ref \
  test_scoped_connection \
  test_signal \
  test_signal_move \
  test_size \
  test_slot \
  test_slot_disconnect \
  test_slot_move \
  test_trackable \
  test_trackable_move \
  test_track_obj \
  test_tuple_cdr \
  test_tuple_end \
  test_tuple_for_each \
  test_tuple_start \
  test_tuple_transform_each \
  test_visit_each \
  test_visit_each_trackable \
  test_weak_raw_ptr

TESTS = $(check_PROGRAMS)

sigc_test_util = testutilities.h testutilities.cc

test_accum_iter_SOURCES      = test_accum_iter.cc $(sigc_test_util)
test_accumulated_SOURCES     = test_accumulated.cc $(sigc_test_util)
test_bind_SOURCES            = test_bind.cc $(sigc_test_util)
test_bind_as_slot_SOURCES    = test_bind_as_slot.cc $(sigc_test_util)
test_bind_ref_SOURCES        = test_bind_ref.cc $(sigc_test_util)
test_bind_refptr_SOURCES     = test_bind_refptr.cc $(sigc_test_util)
test_bind_return_SOURCES     = test_bind_return.cc $(sigc_test_util)
test_compose_SOURCES         = test_compose.cc $(sigc_test_util)
test_connection_SOURCES      = test_connection.cc $(sigc_test_util)
test_copy_invalid_slot_SOURCES = test_copy_invalid_slot.cc $(sigc_test_util)
test_cpp11_lambda_SOURCES    = test_cpp11_lambda.cc $(sigc_test_util)
test_custom_SOURCES          = test_custom.cc $(sigc_test_util)
test_disconnect_SOURCES      = test_disconnect.cc $(sigc_test_util)
test_disconnect_during_emit_SOURCES = test_disconnect_during_emit.cc $(sigc_test_util)
test_exception_catch_SOURCES = test_exception_catch.cc $(sigc_test_util)
test_hide_SOURCES            = test_hide.cc $(sigc_test_util)
test_limit_reference_SOURCES = test_limit_reference.cc $(sigc_test_util)
test_member_method_trait_SOURCES = test_member_method_trait.cc $(sigc_test_util)
test_mem_fun_SOURCES         = test_mem_fun.cc $(sigc_test_util)
test_ptr_fun_SOURCES         = test_ptr_fun.cc $(sigc_test_util)
test_retype_SOURCES          = test_retype.cc $(sigc_test_util)
test_retype_return_SOURCES   = test_retype_return.cc $(sigc_test_util)
test_rvalue_ref_SOURCES      = test_rvalue_ref.cc $(sigc_test_util)
test_scoped_connection_SOURCES = test_scoped_connection.cc $(sigc_test_util)
test_signal_SOURCES          = test_signal.cc $(sigc_test_util)
test_signal_move_SOURCES     = test_signal_move.cc $(sigc_test_util)
test_size_SOURCES            = test_size.cc $(sigc_test_util)
test_slot_SOURCES            = test_slot.cc $(sigc_test_util)
test_slot_disconnect_SOURCES = test_slot_disconnect.cc $(sigc_test_util)
test_slot_move_SOURCES       = test_slot_move.cc $(sigc_test_util)
test_trackable_SOURCES       = test_trackable.cc $(sigc_test_util)
test_trackable_move_SOURCES  = test_trackable_move.cc $(sigc_test_util)
test_track_obj_SOURCES       = test_track_obj.cc $(sigc_test_util)
test_tuple_cdr_SOURCES       = test_tuple_cdr.cc $(sigc_test_util)
test_tuple_end_SOURCES       = test_tuple_end.cc $(sigc_test_util)
test_tuple_for_each_SOURCES  = test_tuple_for_each.cc $(sigc_test_util)
test_tuple_start_SOURCES     = test_tuple_start.cc $(sigc_test_util)
test_tuple_transform_each_SOURCES = test_tuple_transform_each.cc $(sigc_test_util)
test_visit_each_SOURCES      = test_visit_each.cc $(sigc_test_util)
test_visit_each_trackable_SOURCES = test_visit_each_trackable.cc $(sigc_test_util)
test_weak_raw_ptr_SOURCES = test_weak_raw_ptr.cc $(sigc_test_util)

if SIGC_BUILD_BENCHMARK
check_PROGRAMS += benchmark
benchmark_SOURCES = benchmark.cc $(sigc_test_util)
benchmark_LDADD = $(sigc_libs) \
	$(BOOST_SYSTEM_LIB) \
	$(BOOST_TIMER_LIB)
endif
