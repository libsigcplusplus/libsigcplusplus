/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/bind.h>
#include <sigc++/functors/slot.h>

namespace
{

std::ostringstream result_stream;

bool
func_to_bind(int a, int b)
{
  result_stream << "func_to_bind(" << a << ", " << b << ")";
  return true;
}

bool
func_to_bind_with_iter(int a, std::string::iterator& b)
{
  result_stream << "func_to_bind_with_iter(" << a << ", " << *b << ")";
  return true;
}

bool
func_to_bind_with_const_iter(int a, std::string::const_iterator& b)
{
  result_stream << "func_to_bind_with_const_iter(" << a << ", " << *b << ")";
  return true;
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // Test that sigc::bind()'s result can be converted to a sigc::slot<>.
  {
    sigc::slot<bool(int)> bound_slot = sigc::bind(sigc::ptr_fun(&func_to_bind), 2);
    bound_slot(1);
    util->check_result(result_stream, "func_to_bind(1, 2)");
  }

  // Test with a non-const iterator:
  {
    std::string c = "2";
    sigc::slot<bool(int)> bound_slot =
      sigc::bind(sigc::ptr_fun(&func_to_bind_with_iter), c.begin());
    bound_slot(1);
    util->check_result(result_stream, "func_to_bind_with_iter(1, 2)");
  }

  // Test with a const_iterator:
  {
    const std::string c = "2";
    sigc::slot<bool(int)> bound_slot =
      sigc::bind(sigc::ptr_fun(&func_to_bind_with_const_iter), c.begin());
    bound_slot(1);
    util->check_result(result_stream, "func_to_bind_with_const_iter(1, 2)");
  }

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
