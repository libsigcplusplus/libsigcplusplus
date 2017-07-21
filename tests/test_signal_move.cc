/* Copyright 2015 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>

namespace
{
std::ostringstream result_stream;

int
foo(int i)
{
  result_stream << "foo(int " << i << ")";
  return 1;
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // signal
  sigc::signal<int(int)> sig;
  sig.connect(sigc::ptr_fun(&foo));
  sig(1);
  util->check_result(result_stream, "foo(int 1)");

  // Test the move constructor:
  sigc::signal<int(int)> sig2(std::move(sig));
  sig(-2); // Test that the moved-from slot does nothing.
  sig2(2);
  util->check_result(result_stream, "foo(int 2)");

  // Test the move assignment operator:
  sigc::signal<int(int)> sig3;
  sig3 = std::move(sig2);
  sig2(-3); // Test that the moved-from slot does nothing.
  sig3(3);
  util->check_result(result_stream, "foo(int 3)");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
