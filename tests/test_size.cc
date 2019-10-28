/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>
#include <iostream>

// The correct result of this test may be implementation-dependent.
// No attempt is made to decide if the result is correct.
// The test will succeed, unless it's started with erroneous command arguments.
// "./test_size --verbose" shows the sizes.

namespace
{
struct A
{
  void foo() {}
};
} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  if (util->get_verbose())
  {
    std::cout << "sizes of public classes:" << std::endl;

    // libsigc++ 2.10: 8
    // libsigc++ 3.0: 8
    std::cout << "  trackable:               " << sizeof(sigc::trackable) << std::endl;

    // libsigc++ 2.10: 16
    // libsigc++ 3.0: 16
    std::cout << "  slot<void()>:              " << sizeof(sigc::slot<void()>) << std::endl;

    // libsigc++ 2.10: 16
    // libsigc++ 3.0: 16
    std::cout << "  signal<void()>:            " << sizeof(sigc::signal<void()>) << std::endl;

    // libsigc++ 2.10: 8
    // libsigc++ 3.0: 8
    std::cout << "  connection:              " << sizeof(sigc::connection) << std::endl;

    std::cout << std::endl << "sizes of internal classes:" << std::endl;

    // libsigc++ 2.10: 16
    // libsigc++ 3.0: 16
    std::cout << "  trackable_callback:      " << sizeof(sigc::internal::trackable_callback)
              << std::endl;

    // libsigc++ 2.10: 32
    // libsigc++ 3.0: 32
    std::cout << "  trackable_callback_list: " << sizeof(sigc::internal::trackable_callback_list)
              << std::endl;

    // libsigc++ 2.10: 48
    // libsigc++ 3.0: 48
    std::cout << "  slot_rep:                " << sizeof(sigc::internal::slot_rep) << std::endl;

    // libsigc++ 2.10: 72
    // libsigc++ 3.0: 64
    std::cout << "  typed_slot_rep<mem_functor<void,A> >: "
              << sizeof(sigc::internal::typed_slot_rep<sigc::mem_functor<void (A::*)()>>)
              << std::endl;

    // libsigc++ 2.10: 32
    // libsigc++ 3.0: 32
    std::cout << "  signal_impl:             " << sizeof(sigc::internal::signal_impl) << std::endl;
  }
  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
