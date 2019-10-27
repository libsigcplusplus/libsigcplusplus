/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/hide.h>

namespace
{
std::ostringstream result_stream;

struct foo
{
  int operator()()
  {
    result_stream << "foo() ";
    return true;
  }

  int operator()(int j)
  {
    result_stream << "foo(int " << j << ") ";
    return 1 + j;
  }
};

struct foo_void
{
  void operator()() { result_stream << "foo_void()"; }
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return TestUtilities::get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  result_stream << sigc::hide<0>(foo())(1, 2);
  util->check_result(result_stream, "foo(int 2) 3");

  result_stream << sigc::hide<1>(foo())(1, 2);
  util->check_result(result_stream, "foo(int 1) 2");

  result_stream << sigc::hide<-1>(foo())(1);
  util->check_result(result_stream, "foo() 1");

  result_stream << sigc::hide(foo())(1);
  util->check_result(result_stream, "foo() 1");

  sigc::hide(foo_void())(1); // void test
  util->check_result(result_stream, "foo_void()");

  return TestUtilities::get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
