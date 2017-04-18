/* Copyright 2005 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/functors/slot.h>

namespace
{
std::ostringstream result_stream;

void
Foo()
{
  result_stream << "Foo";
}

void
Bar()
{
  result_stream << "Bar";
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // Note that sigc::ptr_fun() creates a sig::pointer_functor.
  sigc::slot<void()> theSlot(sigc::ptr_fun(&Foo));
  theSlot();
  util->check_result(result_stream, "Foo");

  theSlot.disconnect();
  theSlot();
  util->check_result(result_stream, "");

  theSlot = sigc::ptr_fun(&Bar);
  theSlot();
  util->check_result(result_stream, "Bar");

  theSlot = sigc::slot<void()>(); // Assign an empty slot.
  theSlot();
  util->check_result(result_stream, "");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
