/* Copyright 2015 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/functors/slot.h>

// The Tru64 compiler seems to need this to avoid an unresolved symbol
// See bug #161503

namespace
{
std::ostringstream result_stream;

class foo
{
public:
  void operator()(int i) { result_stream << "foo(int " << i << ")"; }

  void operator()(std::string& str)
  {
    result_stream << "foo(string '" << str << "') ";
    str = "foo was here";
  }

  void operator()(int, int) { result_stream << "foo(int, int)"; }
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // simple test
  sigc::slot<void(int)> s1 = foo();
  s1(1);
  util->check_result(result_stream, "foo(int 1)");

  // test move constructor:
  sigc::slot<void(int)> s2(std::move(s1));
  s1(-2); // Test that the moved-from slot does nothing.
  s2(2);
  util->check_result(result_stream, "foo(int 2)");

  // test move assignment:
  sigc::slot<void(int)> s3;
  s3 = std::move(s2);
  s2(-3); // Test that the moved-from slot does nothing.
  s3(3);
  util->check_result(result_stream, "foo(int 3)");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
