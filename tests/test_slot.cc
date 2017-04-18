/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/functors/slot.h>

// The Tru64 compiler seems to need this to avoid an unresolved symbol
// See bug #161503

namespace
{

TestUtilities* util = nullptr;
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

void
test_simple()
{
  // simple test
  sigc::slot<void(int)> s1 = foo();
  s1(1);
  util->check_result(result_stream, "foo(int 1)");

  s1 = foo();
  s1(2);
  util->check_result(result_stream, "foo(int 2)");
}

void
test_implicit_conversion()
{
  // test implicit conversion
  sigc::slot<void(char)> s2 = foo();
  s2(3);
  util->check_result(result_stream, "foo(int 3)");
}

void
test_reference()
{
  // test reference
  sigc::slot<void(std::string&)> sl1 = foo();
  std::string str("guest book");
  sl1(str);
  result_stream << str;
  util->check_result(result_stream, "foo(string 'guest book') foo was here");
}

void
test_operator_equals()
{
  // test operator=
  std::string str = "guest book";
  sigc::slot<void(std::string&)> sl1 = foo();
  sigc::slot<void(std::string&)> sl2;
  sl2 = sl1;
  sl1 = sl2;
  sl1(str);
  result_stream << str;
  util->check_result(result_stream, "foo(string 'guest book') foo was here");
}

void
test_copy_ctor()
{
  // test copy ctor
  sigc::slot<void(int)> s1 = foo();
  sigc::slot<void(int)> s1_clone(s1);
  s1_clone(4);
  util->check_result(result_stream, "foo(int 4)");
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_simple();
  test_implicit_conversion();
  test_reference();
  test_operator_equals();
  test_copy_ctor();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
