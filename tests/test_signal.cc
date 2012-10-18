// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <string>
#include <cstdlib>

namespace
{
std::ostringstream result_stream;

int foo(int i)
{
  result_stream << "foo(int " << i << ") ";
  return 1;
}

int bar(float i)
{
  result_stream << "bar(float " << i << ") ";
  return 1;
}

struct A : public sigc::trackable
{
  int foo(int i)
  {
    result_stream << "A::foo(int " << i << ") ";
    return 1;
  }

  void bar(std::string& str)
  {
    result_stream << "A::foo(string '" << str << "') ";
    str = "foo was here";
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // signal
  sigc::signal<int,int> sig;

  // emit empty signal
  sig(0);
  util->check_result(result_stream, "");

  // connect some slots before emitting & test auto-disconnection
  {
    A a;
    sig.connect(sigc::ptr_fun1(&foo));
    sig.connect(sigc::mem_fun1(&a, &A::foo));
    sig.connect(sigc::ptr_fun1(&bar));
    sig(1);
    result_stream << sig.size();
    util->check_result(result_stream, "foo(int 1) A::foo(int 1) bar(float 1) 3");

  } // a dies => auto-disconnect

  sig(2);
  result_stream << sig.size();
  util->check_result(result_stream, "foo(int 2) bar(float 2) 2");

  // test reference
  A a;
  std::string str("guest book");
  sigc::signal<void,std::string&> sigstr;
  sigstr.connect(sigc::mem_fun(&a, &A::bar));
  sigstr(str);
  result_stream << str;
  util->check_result(result_stream, "A::foo(string 'guest book') foo was here");

  // test make_slot()
  sig.connect(sigc::ptr_fun1(&foo));
  sigc::signal<int,int> sig2;
  sig2.connect(sig.make_slot());
  sig2(3);
  util->check_result(result_stream, "foo(int 3) bar(float 3) foo(int 3) ");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
