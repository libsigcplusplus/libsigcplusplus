// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>
#include <sstream>
#include <cstdlib>

//TODO: put something like #ifndef FORTE (some older version, I think) or AIX xlC... #else ... #endif around:
#define ENABLE_TEST_OF_OVERLOADED_FUNCTIONS 0

namespace
{
std::ostringstream result_stream;

struct test
{
  void foo(short i1)
  {
    result_stream << "test::foo(short " << i1 << ')';
  }

  void foo_const(int i1) const
  {
    result_stream << "test::foo_const(int " << i1 << ')';
  }

  void foo_volatile(float i1) volatile
  {
    result_stream << "test::foo_volatile(float " << i1 << ')';
  }

  void foo_const_volatile(double i1) const volatile
  {
    result_stream << "test::foo_const_volatile(double " << i1 << ')';
  }

  void foo_overloaded(char i1)
  {
    result_stream << "test::foo_overloaded(char " << int(i1) << ')';
  }

#if ENABLE_TEST_OF_OVERLOADED_FUNCTIONS
  void foo_overloaded(short i1)
  {
    result_stream << "test::foo_overloaded(short " << (int)i1 << ')';
  }
#endif

  double foo_overloaded(int i1, int i2)
  {
    result_stream << "test::foo_overloaded(int " << i1 << ", int " << i2 << ')';
    return 1.0;
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  { /* test non-const */
    test t;
    sigc::mem_fun(&test::foo)(t, 1);  // on reference
    util->check_result(result_stream, "test::foo(short 1)");

    sigc::mem_fun(&test::foo)(&t, 1); // on pointer
    util->check_result(result_stream, "test::foo(short 1)");
  }
  { /* test const */
    test t;
    sigc::mem_fun(&test::foo_const)(t, 2);
    util->check_result(result_stream, "test::foo_const(int 2)");

    sigc::mem_fun(&test::foo_const)(&t, 2);
    util->check_result(result_stream, "test::foo_const(int 2)");
  }
  { /* test const with const object */
    const test t = test();
    sigc::mem_fun(&test::foo_const)(t, 3);
    util->check_result(result_stream, "test::foo_const(int 3)");

    sigc::mem_fun(&test::foo_const)(&t, 3);
    util->check_result(result_stream, "test::foo_const(int 3)");
  }
  { /* test non-const volatile */
    test t;
    sigc::mem_fun(&test::foo_volatile)(t, 4);  // on reference
    util->check_result(result_stream, "test::foo_volatile(float 4)");

    sigc::mem_fun(&test::foo_volatile)(&t, 4); // on pointer
    util->check_result(result_stream, "test::foo_volatile(float 4)");
  }
  { /* test const volatile */
    test t;
    sigc::mem_fun(&test::foo_const_volatile)(t, 5);  // on reference
    util->check_result(result_stream, "test::foo_const_volatile(double 5)");

    sigc::mem_fun(&test::foo_const_volatile)(&t, 5); // on pointer
    util->check_result(result_stream, "test::foo_const_volatile(double 5)");
  }
  { /* test const volatile with const object */
    const test t = test();
    sigc::mem_fun(&test::foo_const_volatile)(t, 6);  // on reference
    util->check_result(result_stream, "test::foo_const_volatile(double 6)");

    sigc::mem_fun(&test::foo_const_volatile)(&t, 6); // on pointer
    util->check_result(result_stream, "test::foo_const_volatile(double 6)");
  }
#if ENABLE_TEST_OF_OVERLOADED_FUNCTIONS
  { /* test overloaded */
    test t;
    sigc::mem_fun1<char>(&test::foo_overloaded)(&t, 7);
    util->check_result(result_stream, "test::foo_overloaded(char 7)");

    sigc::mem_fun1<short>(&test::foo_overloaded)(&t, 7);
    util->check_result(result_stream, "test::foo_overloaded(short 7)");

    //sigc::mem_fun1(&test::foo_overloaded)(&t, 7);
    //util->check_result(result_stream, "test::foo_overloaded(short 7)");

    sigc::mem_fun2(&test::foo_overloaded)(&t, 7, 8);
    util->check_result(result_stream, "test::foo_overloaded(int 7, int 8)");
  }
#endif
  { /* test bound */
    test t;
    sigc::mem_fun(t, &test::foo)(9);
    util->check_result(result_stream, "test::foo(short 9)");

    sigc::mem_fun(&t, &test::foo)(9);
    util->check_result(result_stream, "test::foo(short 9)");

    sigc::mem_fun(t, &test::foo_const)(9);
    util->check_result(result_stream, "test::foo_const(int 9)");

    sigc::mem_fun(&t, &test::foo_const)(9);
    util->check_result(result_stream, "test::foo_const(int 9)");

    sigc::mem_fun(t, &test::foo_volatile)(9);
    util->check_result(result_stream, "test::foo_volatile(float 9)");

    sigc::mem_fun(&t, &test::foo_volatile)(9);
    util->check_result(result_stream, "test::foo_volatile(float 9)");

#if ENABLE_TEST_OF_OVERLOADED_FUNCTIONS
    sigc::mem_fun2(t, &test::foo_overloaded)(9, 10);
    util->check_result(result_stream, "test::foo_overloaded(int 9, int 10)");

    sigc::mem_fun2(&t, &test::foo_overloaded)(9, 10);
    util->check_result(result_stream, "test::foo_overloaded(int 9, int 10)");
#endif
  }

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
