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

check_PROGRAMS =			\
	test_accum_iter			\
	test_bind			\
	test_bind_ref			\
	test_bind_return		\
	test_compose			\
	test_copy_invalid_slot		\
	test_custom			\
	test_deduce_result_type		\
	test_disconnect			\
	test_disconnect_during_emit	\
	test_exception_catch		\
	test_functor_trait		\
	test_hide			\
	test_limit_reference		\
	test_mem_fun			\
	test_ptr_fun			\
	test_retype			\
	test_retype_return		\
	test_signal			\
	test_size			\
	test_slot			\
	test_slot_disconnect		\
	test_trackable

TESTS = $(check_PROGRAMS)

test_accum_iter_SOURCES			= test_accum_iter.cc
test_bind_SOURCES			= test_bind.cc
test_bind_ref_SOURCES			= test_bind_ref.cc
test_bind_return_SOURCES		= test_bind_return.cc
test_compose_SOURCES			= test_compose.cc
test_copy_invalid_slot_SOURCES		= test_copy_invalid_slot.cc
test_custom_SOURCES			= test_custom.cc
test_deduce_result_type_SOURCES		= test_deduce_result_type.cc
test_disconnect_SOURCES			= test_disconnect.cc
test_disconnect_during_emit_SOURCES	= test_disconnect_during_emit.cc
test_exception_catch_SOURCES		= test_exception_catch.cc
test_functor_trait_SOURCES		= test_functor_trait.cc
test_hide_SOURCES			= test_hide.cc
test_limit_reference_SOURCES		= test_limit_reference.cc
test_mem_fun_SOURCES			= test_mem_fun.cc
test_ptr_fun_SOURCES			= test_ptr_fun.cc
test_retype_SOURCES			= test_retype.cc
test_retype_return_SOURCES		= test_retype_return.cc
test_signal_SOURCES			= test_signal.cc
test_size_SOURCES			= test_size.cc
test_slot_SOURCES			= test_slot.cc
test_slot_disconnect_SOURCES		= test_slot_disconnect.cc
test_trackable_SOURCES			= test_trackable.cc

# Disabled: test_lambda - The Tru64 compiler can't build this when not using
#  -std strict_ansi -model ansi, so let's not worry about it.
# Disabled: test_accumulated - The AIX xlC compiler can't build this. It says 
#  xlC_r  -I. -I. -I.. -I.. -I..    -AA -c -o test_accumulated.o test_accumulated.cc
#  "../sigc++/signal.h", line 534.39: 1540-1110 (S) The referenced type
#  "sigc::internal::signal_emit1" contains a circular reference back to ""

dist_noinst_DATA = test_accumulated.cc test_lambda.cc
