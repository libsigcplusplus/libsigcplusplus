// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sstream>
#include <sigc++/sigc++.h>
#include <cstdlib>

//TODO: put something like #ifndef FORTE ... #else ... #endif around:
#define ENABLE_TEST_OF_OVERLOADED_FUNCTIONS 0

namespace
{
std::ostringstream result_stream;

int foo()
{
  result_stream << "foo()";
  return 1;
}

void foo(int i1)
{
  result_stream << "foo(int " << i1 << ")";
}

#if ENABLE_TEST_OF_OVERLOADED_FUNCTIONS
void bar(char i1)
{
  result_stream << "bar(char " << (int)i1 << ")";
}
#endif

void bar(float i1)
{
  result_stream << "bar(float " << i1 << ")";
}

double bar(int i1, int i2)
{
  result_stream << "bar(int " << i1 << ", int " << i2 << ")";
  return 1.0f;
}

struct test
{
  static void foo()
  {
    result_stream << "test::foo()";
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::ptr_fun0(&foo)();
  util->check_result(result_stream, "foo()");

  sigc::ptr_fun1(&foo)(1);
  util->check_result(result_stream, "foo(int 1)");

#if ENABLE_TEST_OF_OVERLOADED_FUNCTIONS
  sigc::ptr_fun1<char>(&bar)(2);
  util->check_result(result_stream, "bar(char 2)");

  sigc::ptr_fun1<float>(&bar)(2.0f);
  util->check_result(result_stream, "bar(float 2)");
#else
  sigc::ptr_fun1(&bar)(2.0f);
  util->check_result(result_stream, "bar(float 2)");
#endif

  sigc::ptr_fun2(&bar)(3, 5);
  util->check_result(result_stream, "bar(int 3, int 5)");

  sigc::ptr_fun(&test::foo)();
  util->check_result(result_stream, "test::foo()");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
