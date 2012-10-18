// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/bind_return.h>
#include <sigc++/functors/slot.h>
#include <sstream>
#include <string>
#include <cstdlib>

namespace
{
std::ostringstream result_stream;

struct foo
{
  void operator()(int i)
  {
    result_stream << "foo(int " << i << ") ";
  }

  float operator()(float i)
  {
    result_stream << "foo(float " << i << ") ";
    return i*5;
  }
};

struct bar : public sigc::trackable
{
  bar(int i = 0) : i_(i) {}
  operator int() { return i_; }
  int i_;
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  result_stream << sigc::bind_return(foo(), -12345)(5);
  util->check_result(result_stream, "foo(int 5) -12345");

  // Here we just build a functor, not a slot. There is no such thing as a
  // default functor, or an invalidated functor. As such, functors can return
  // references.
  std::string str("guest book");
  // A convoluted way to do
  // sigc::bind_return(foo(), sigc::ref(str))(6) = "main";
  sigc::bind_return<sigc::reference_wrapper<std::string> >(foo(), sigc::ref(str))(6) = "main";
  result_stream << str;
  util->check_result(result_stream, "foo(int 6) main");

  // Here we build a slot (constructed from a functor). Slots cannot return
  // references: if they could, then what would be the return value of the
  // default slot or of an invalidated slot? On the other hand, slots are
  // guaranteed to be able to construct and return a valid default instance as
  // long as there exists a default constructor for it.
  //
  // Therefore, we use 'bar', and not 'bar&' for this slot signature.
  sigc::slot<bar, int> sl;
  {
    bar choco(-1);
    sl = sigc::bind_return(foo(),sigc::ref(choco));
    result_stream << sl(7);
    util->check_result(result_stream, "foo(int 7) -1");
  } // auto-disconnect

  result_stream << sl(8);
  util->check_result(result_stream, "0");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
