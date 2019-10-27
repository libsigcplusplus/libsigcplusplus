/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>

namespace
{
std::ostringstream result_stream;

// TODO: This works with clang++ (when we specify the return type, such as
// int or void, but doesn't work with g++.
/*
int foo()
{
  result_stream << "foo()";
  return 1;
}
*/

void
foo(int i1)
{
  result_stream << "foo(int " << i1 << ")";
}

void
bar(char i1)
{
  result_stream << "bar(char " << (int)i1 << ")";
}

// Note: This doesn't work with some older versions of g++,
// even when we specify the return type.
// Hopefully those g++ versions are old enough now.
void
bar(float i1)
{
  result_stream << "bar(float " << i1 << ")";
}

double
bar(int i1, int i2)
{
  result_stream << "bar(int " << i1 << ", int " << i2 << ")";
  return 1.0f;
}

struct test
{
  static void foo() { result_stream << "test::foo()"; }
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // Test use of overloaded functions that differ by number of parameters
  // and by return type
  // TODO: This works with clang++ (when we specify the return type, such as
  // int or void, but doesn't work with g++.
  // sigc::ptr_fun<int>(&foo)();
  // util->check_result(result_stream, "foo()");

  sigc::ptr_fun<void> (&foo)(1);
  util->check_result(result_stream, "foo(int 1)");

  // Test use of overloaded functions that differ by parameter type:
  sigc::ptr_fun<void, char> (&bar)(2);
  util->check_result(result_stream, "bar(char 2)");

  sigc::ptr_fun<void, float> (&bar)(2.0f);
  util->check_result(result_stream, "bar(float 2)");

  // int or void, but doesn't work with g++.
  // sigc::ptr_fun<void>(&bar)(2.0f);
  // util->check_result(result_stream, "bar(float 2)");

  sigc::ptr_fun<double> (&bar)(3, 5);
  util->check_result(result_stream, "bar(int 3, int 5)");

  sigc::ptr_fun (&test::foo)();
  util->check_result(result_stream, "test::foo()");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
