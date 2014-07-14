// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sstream>
#include <cstdlib>
#include <sigc++/sigc++.h>

namespace
{
std::ostringstream result_stream;

template <class T>
void bar(T)
{
  result_stream << "unknown";
}

template <>
void bar<int>(int)
{
  result_stream << "int";
}

template <>
void bar<double>(double)
{
  result_stream << "double";
}

struct foo : public sigc::functor_base
{
  typedef double result_type;

  int operator()(int i = 1);
  double operator()(const int&, int);
};

struct foo2 : public foo
{};

struct foo3 : public sigc::functor_base
{
  typedef int result_type;

  int operator()(int i = 1);
  double operator()(const int&, int);
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  bar(sigc::deduce_result_type<foo2, long>::type());
  util->check_result(result_stream, "double");

  bar(sigc::deduce_result_type<foo2, int, int>::type());
  util->check_result(result_stream, "double");

  bar(sigc::deduce_result_type<foo3, int, int>::type());
  util->check_result(result_stream, "int");

#ifdef FAIL
  bar(sigc::deduce_result_type<foo2, int, int, int>::type());
  util->check_result(result_stream, "double");
#endif

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
