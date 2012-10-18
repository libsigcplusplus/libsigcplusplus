// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <sstream>
#include <iomanip>
#include <vector>
#include <cstdlib>

namespace
{
std::ostringstream result_stream;

struct arithmetic_mean_accumulator
{
  typedef double result_type;
  template<typename T_iterator>
  double operator()(T_iterator first, T_iterator last) const
  {
    double value_ = 0;
    int n_ = 0;
    for (; first != last; ++first, ++n_)
      value_ += *first;
    return (n_ ? value_ / n_ : -1); // empty slot list <=> n_==0
  }
};

template<class Ret>
struct vector_accumulator
{
  typedef std::vector<Ret> result_type;
  template<typename T_iterator>
  result_type operator()(T_iterator first, T_iterator last) const
  {
    result_type vec;
    for (; first != last; ++first)
      vec.push_back(*first);
    return vec;
  }
};

int foo(int i)
{
  const int result = 3 * i + 1;
  result_stream << "foo: " << result << ", ";
  return result;
}

int bar(double i)
{
  const int result = 5 * int(i) - 3;
  result_stream << "bar: " << result << ", ";
  return result;
}

struct A : public sigc::trackable
{
  int foo(int i)
  {
    const int result = 20 * i - 14;
    result_stream << "A::foo: " << result << ", ";
    return result;
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

   sigc::signal<int,int>::accumulated<arithmetic_mean_accumulator> sig;
   sigc::signal<int,int>::accumulated<vector_accumulator<int> > sig_vec;

  result_stream << "Result (empty slot list): " << sig(0);
  util->check_result(result_stream, "Result (empty slot list): -1");
  result_stream << "Vector result (empty slot list): "
                << (sig_vec(0).empty() ? "empty" : "not empty");
  util->check_result(result_stream, "Vector result (empty slot list): empty");

  A a;
  sig.connect(sigc::ptr_fun1(&foo));
  sig.connect(sigc::mem_fun1(&a, &A::foo));
  sig.connect(sigc::ptr_fun1(&bar));

  sig_vec.connect(sigc::ptr_fun1(&foo));
  sig_vec.connect(sigc::mem_fun1(&a, &A::foo));
  sig_vec.connect(sigc::ptr_fun1(&bar));

  double dres = sig(1);
  result_stream << "Mean accumulator: Result (i=1): "
                << std::fixed << std::setprecision(3) << dres;
  util->check_result(result_stream,
    "foo: 4, A::foo: 6, bar: 2, Mean accumulator: Result (i=1): 4.000");

  dres = sig(11);
  result_stream << "Mean accumulator: Plain Result (i=11): "
                << std::fixed << std::setprecision(3) << dres;
  util->check_result(result_stream,
    "foo: 34, A::foo: 206, bar: 52, Mean accumulator: Plain Result (i=11): 97.333");

  std::vector<int> res1 = sig_vec(1);
  result_stream << "Vector accumulator: Result (i=1): ";
  for (std::vector<int>::iterator i = res1.begin(); i != res1.end(); ++i)
    result_stream << *i << " ";
  util->check_result(result_stream,
    "foo: 4, A::foo: 6, bar: 2, Vector accumulator: Result (i=1): 4 6 2 ");

  std::vector<int> res3 = sig_vec(3);
  result_stream << "Vector accumulator: Result (i=3): ";
  for (std::vector<int>::iterator i = res3.begin(); i != res3.end(); ++i)
    result_stream << *i << " ";
  util->check_result(result_stream,
    "foo: 10, A::foo: 46, bar: 12, Vector accumulator: Result (i=3): 10 46 12 ");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
