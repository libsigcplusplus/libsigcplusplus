// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/retype_return.h>
#include <sigc++/functors/slot.h>
#include <sstream>
#include <cstdlib>

namespace
{
std::ostringstream result_stream;

struct foo : public sigc::functor_base
{
  typedef float result_type;

  float operator()(int i)
  {
    result_stream << "foo(int " << i << ") ";
    return i;
  }

  float operator()(float i)
  {
    result_stream << "foo(float " << i << ") ";
    return i * 5;
  }
};

struct bar : public sigc::trackable, public sigc::functor_base
{
  typedef int result_type;

  int operator()(int i)
  {
    result_stream << "bar(int " << i << ")";
    return i;
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // retype_return<int>
  result_stream << sigc::retype_return<int>(foo())(1.234f);
  util->check_result(result_stream, "foo(float 1.234) 6");

  // retype_return<void> / hide_return
  sigc::slot<void, int> sl;
  sl = sigc::retype_return<void>(bar());
  sl(5);
  util->check_result(result_stream, "bar(int 5)");

  sl = sigc::hide_return(bar());
  sl(6);
  util->check_result(result_stream, "bar(int 6)");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
