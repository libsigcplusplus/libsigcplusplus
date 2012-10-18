// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/functors/slot.h>
#include <sstream>
#include <string>
#include <cstdlib>

//The Tru64 compiler seems to need this to avoid an unresolved symbol
//See bug #161503
#include <new>
SIGC_USING_STD(new)

namespace
{
std::ostringstream result_stream;

class foo
{
public:
  void operator()(int i)
  {
    result_stream << "foo(int " << i << ")";
  }

  void operator()(std::string& str)
  {
    result_stream << "foo(string '" << str << "') ";
    str="foo was here";
  }

  void operator()(int, int)
  {
    result_stream << "foo(int, int)";
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // simple test
  sigc::slot<void,int> s1 = foo();
  s1(1);
  util->check_result(result_stream, "foo(int 1)");

  s1 = foo();
  s1(2);
  util->check_result(result_stream, "foo(int 2)");

  // test implicit conversion
  sigc::slot<void,char> s2 = foo();
  s2(3);
  util->check_result(result_stream, "foo(int 3)");

  // test reference
  sigc::slot<void,std::string&> sl1 = foo();
  std::string str("guest book");
  sl1(str);
  result_stream << str;
  util->check_result(result_stream, "foo(string 'guest book') foo was here");

  // test operator=
  str = "guest book";
  sigc::slot<void,std::string&> sl2;
  sl2 = sl1;
  sl1 = sl2;
  sl1(str);
  result_stream << str;
  util->check_result(result_stream, "foo(string 'guest book') foo was here");

  // test copy ctor
  sigc::slot<void,int> s1_clone(s1);
  s1_clone(4);
  util->check_result(result_stream, "foo(int 4)");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
