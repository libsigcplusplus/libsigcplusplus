#include "testutilities.h"
#include <sigc++/sigc++.h>
#include <sstream>
#include <algorithm>
#include <functional>
#include <cstdlib>

namespace
{
std::ostringstream result_stream;

int ident(int i)
{
  return i;
}

template<typename T>
struct min_accum
{
  typedef T result_type;

  template<class I>
#ifndef SIGC_HAVE_SUN_REVERSE_ITERATOR
  typename std::iterator_traits<I>::value_type operator()(I i1, I i2)
#else
  typename I::value_type operator()(I i1, I i2)
#endif
  {
    return *std::min_element(i1, i2);
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::signal0<int,min_accum<int> > signal;

  signal.connect(sigc::bind(sigc::ptr_fun(ident), 3));
  signal.connect(sigc::bind(sigc::ptr_fun(ident), 1));
  signal.connect(sigc::bind(sigc::ptr_fun(ident), 42));

  result_stream << signal();
  util->check_result(result_stream, "1");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
