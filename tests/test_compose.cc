/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/compose.h>

namespace
{
std::ostringstream result_stream;

struct set
{
  double operator()(int i)
  {
    result_stream << "set(int " << i << ") ";
    return i * i;
  }

  double operator()(double i)
  {
    result_stream << "set(double " << i << ") ";
    return i * 5;
  }
};

struct set_void
{
  void operator()(double i) { result_stream << "set_void(double " << i << ")"; }
};

struct get
{
  double operator()()
  {
    result_stream << "get() ";
    return static_cast<double>(true);
  }

  double operator()(int i)
  {
    result_stream << "get(" << i << ") ";
    return i * 2;
  }

  double operator()(int i, int j)
  {
    result_stream << "get(" << i << ", " << j << ") ";
    return double(i) / double(j);
  }
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  result_stream << sigc::compose(set(), get())();
  util->check_result(result_stream, "get() set(double 1) 5");

  result_stream << sigc::compose(set(), get())(1);
  util->check_result(result_stream, "get(1) set(double 2) 10");

  result_stream << sigc::compose(set(), get())(1, 2);
  util->check_result(result_stream, "get(1, 2) set(double 0.5) 2.5");

  sigc::compose(set_void(), get())(3); // void test
  util->check_result(result_stream, "get(3) set_void(double 6)");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
