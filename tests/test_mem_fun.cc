/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>

namespace
{

TestUtilities* util = nullptr;
std::ostringstream result_stream;

struct test
{
  void foo(short i1) { result_stream << "test::foo(short " << i1 << ')'; }

  void foo_const(int i1) const { result_stream << "test::foo_const(int " << i1 << ')'; }

  void foo_volatile(float i1) volatile
  {
    result_stream << "test::foo_volatile(float " << i1 << ')';
  }

  void foo_const_volatile(double i1) const volatile
  {
    result_stream << "test::foo_const_volatile(double " << i1 << ')';
  }

  void foo_overloaded(char i1) { result_stream << "test::foo_overloaded(char " << int(i1) << ')'; }

  void foo_overloaded(short i1)
  {
    result_stream << "test::foo_overloaded(short " << (int)i1 << ')';
  }

  double foo_overloaded(int i1, int i2)
  {
    result_stream << "test::foo_overloaded(int " << i1 << ", int " << i2 << ')';
    return 1.0;
  }
};

} // end anonymous namespace

void
test_non_const()
{
  test t;
  sigc::mem_fun (&test::foo)(t, 1);
  util->check_result(result_stream, "test::foo(short 1)");
}

void
test_const()
{
  test t;
  sigc::mem_fun (&test::foo_const)(t, 2);
  util->check_result(result_stream, "test::foo_const(int 2)");
}

void
test_const_with_const_object()
{
  const auto t = test();
  sigc::mem_fun (&test::foo_const)(t, 3);
  util->check_result(result_stream, "test::foo_const(int 3)");
}

void
test_non_const_volatile()
{
  test t;
  sigc::mem_fun (&test::foo_volatile)(t, 4);
  util->check_result(result_stream, "test::foo_volatile(float 4)");
}

void
test_const_volatile()
{
  test t;
  sigc::mem_fun (&test::foo_const_volatile)(t, 5);
  util->check_result(result_stream, "test::foo_const_volatile(double 5)");
}

void
test_const_volatile_with_const_object()
{
  const auto t = test();
  sigc::mem_fun (&test::foo_const_volatile)(t, 6);
  util->check_result(result_stream, "test::foo_const_volatile(double 6)");
}

void
test_overloaded()
{
  test t;

  // We need to specify the types when using overloaded functions.

  sigc::mem_fun<void, test, char> (&test::foo_overloaded)(t, 7);
  util->check_result(result_stream, "test::foo_overloaded(char 7)");

  sigc::mem_fun<void, test, short> (&test::foo_overloaded)(t, 7);
  util->check_result(result_stream, "test::foo_overloaded(short 7)");

  sigc::mem_fun<double, test, int, int> (&test::foo_overloaded)(t, 7, 8);
  util->check_result(result_stream, "test::foo_overloaded(int 7, int 8)");
}

void
test_bound()
{
  test t;
  sigc::mem_fun(t, &test::foo)(9);
  util->check_result(result_stream, "test::foo(short 9)");

  sigc::mem_fun(t, &test::foo)(9);
  util->check_result(result_stream, "test::foo(short 9)");

  sigc::mem_fun(t, &test::foo_const)(9);
  util->check_result(result_stream, "test::foo_const(int 9)");

  sigc::mem_fun(t, &test::foo_const)(9);
  util->check_result(result_stream, "test::foo_const(int 9)");

  sigc::mem_fun(t, &test::foo_volatile)(9);
  util->check_result(result_stream, "test::foo_volatile(float 9)");

  sigc::mem_fun(t, &test::foo_volatile)(9);
  util->check_result(result_stream, "test::foo_volatile(float 9)");

  sigc::mem_fun<double, test, test, int, int>(t, &test::foo_overloaded)(9, 10);
  util->check_result(result_stream, "test::foo_overloaded(int 9, int 10)");
}

class TestAutoDisconnect : public sigc::trackable
{
public:
  void foo() { result_stream << "TestAutoDisconnect::foo() called."; }
};

void
test_auto_disconnect()
{
  // Check that slot doesn't try to call a method on a destroyed instance,
  // when the instance's class derives from trackable.
  sigc::slot<void()> slot_of_member_method;
  {
    TestAutoDisconnect t;
    slot_of_member_method = sigc::mem_fun(t, &TestAutoDisconnect::foo);

    // The method should be called:
    slot_of_member_method();
    util->check_result(result_stream, "TestAutoDisconnect::foo() called.");
  }

  // The method should not be called:
  slot_of_member_method();
  util->check_result(result_stream, "");
}

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_non_const();
  test_const();
  test_const_with_const_object();
  test_non_const_volatile();
  test_const_volatile();
  test_const_volatile_with_const_object();

  test_overloaded();

  test_bound();

  test_auto_disconnect();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
