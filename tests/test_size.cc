// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>
#include <iostream>
#include <cstdlib>

// The correct result of this test may be implementation-dependent.
// No attempt is made to decide if the result is correct.
// The test will succeed, unless it's started with erroneous command arguments.
// "./test_size --verbose" shows the sizes.

namespace
{
struct A
{
  void foo();
};
} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  if (util->get_verbose())
  {
    std::cout << "sizes of public classes:" << std::endl;

    std::cout << "  trackable:               " << sizeof(sigc::trackable) << std::endl;
    std::cout << "  slot<void>:              " << sizeof(sigc::slot<void>) << std::endl;
    std::cout << "  signal<void>:            " << sizeof(sigc::signal<void>) << std::endl;
    std::cout << "  signal<void>::iterator:  " << sizeof(sigc::signal<void>::iterator) << std::endl;
    std::cout << "  connection:              " << sizeof(sigc::connection) << std::endl;

    std::cout << std::endl << "sizes of internal classes:" << std::endl;

    std::cout << "  trackable_callback:      " << sizeof(sigc::internal::trackable_callback) << std::endl;
    std::cout << "  trackable_callback_list: " << sizeof(sigc::internal::trackable_callback_list) << std::endl;
    std::cout << "  slot_rep:                " << sizeof(sigc::internal::slot_rep) << std::endl;
    std::cout << "  typed_slot_rep<mem_functor0<void,A> >: "
              << sizeof(sigc::internal::typed_slot_rep<sigc::mem_functor0<void,A> >) << std::endl;
    std::cout << "  signal_impl:             " << sizeof(sigc::internal::signal_impl) << std::endl;
  }
  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
