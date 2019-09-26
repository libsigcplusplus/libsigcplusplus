/* Copyright 2019, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <iostream>

namespace
{

TestUtilities* util = nullptr;
std::ostringstream result_stream;

void
test_connection_copy_empty()
{
  sigc::connection con1;

  // Try to prevent the compiler from optimising away the copy.
  std::cout << &con1 << std::endl;

  sigc::connection con2(con1);

  // Try to prevent the compiler from optimising away the copy.
  std::cout << &con2 << std::endl;
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_connection_copy_empty();

  // See also test_disconnection.cc

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
