/* Copyright 2007 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>
#include <algorithm>

namespace
{
std::ostringstream result_stream;

int
ident(int i)
{
  return i;
}

template<typename T>
struct min_accum
{
  template<typename I>
  decltype(auto) operator()(I i1, I i2)
  {
    return *std::min_element(i1, i2);
  }
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::signal<int()>::accumulated<min_accum<int>> signal;

  signal.connect(sigc::bind(sigc::ptr_fun(ident), 3));
  signal.connect(sigc::bind(sigc::ptr_fun(ident), 1));
  signal.connect(sigc::bind(sigc::ptr_fun(ident), 42));

  result_stream << signal();
  util->check_result(result_stream, "1");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
