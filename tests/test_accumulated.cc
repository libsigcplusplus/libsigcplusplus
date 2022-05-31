/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <iomanip>
#include <vector>

namespace
{

TestUtilities* util = nullptr;
std::ostringstream result_stream;

struct arithmetic_mean_accumulator
{
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

template<typename Ret>
struct vector_accumulator
{
  template<typename T_iterator>
  std::vector<Ret> operator()(T_iterator first, T_iterator last) const
  {
    std::vector<Ret> vec;
    for (; first != last; ++first)
      vec.push_back(*first);
    return vec;
  }
};

int
foo(int i)
{
  const int result = 3 * i + 1;
  result_stream << "foo: " << result << ", ";
  return result;
}

int
bar(double i)
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

void
test_empty_signal()
{
  sigc::signal<int(int)>::accumulated<arithmetic_mean_accumulator> sig;
  sigc::signal<int(int)>::accumulated<vector_accumulator<int>> sig_vec;

  result_stream << "Result (empty slot list): " << sig(0);
  util->check_result(result_stream, "Result (empty slot list): -1");
  result_stream << "Vector result (empty slot list): "
                << (sig_vec(0).empty() ? "empty" : "not empty");
  util->check_result(result_stream, "Vector result (empty slot list): empty");
}

template<typename T_signal>
void
test_mean()
{
  typename T_signal::template accumulated<arithmetic_mean_accumulator> sig;

  A a;
  sig.connect(sigc::ptr_fun(&foo));
  sig.connect(sigc::mem_fun(a, &A::foo));
  sig.connect(sigc::ptr_fun(&bar));

  double dres = sig(1);
  result_stream << "Mean accumulator: Result (i=1): " << std::fixed << std::setprecision(3) << dres;
  util->check_result(
    result_stream, "foo: 4, A::foo: 6, bar: 2, Mean accumulator: Result (i=1): 4.000");

  dres = sig(11);
  result_stream << "Mean accumulator: Plain Result (i=11): " << std::fixed << std::setprecision(3)
                << dres;
  util->check_result(
    result_stream, "foo: 34, A::foo: 206, bar: 52, Mean accumulator: Plain Result (i=11): 97.333");
}

void
test_vector_accumulator()
{
  sigc::signal<int(int)>::accumulated<vector_accumulator<int>> sig_vec;

  A a;
  sig_vec.connect(sigc::ptr_fun(&foo));
  sig_vec.connect(sigc::mem_fun(a, &A::foo));
  sig_vec.connect(sigc::ptr_fun(&bar));

  auto res1 = sig_vec(1);
  result_stream << "Vector accumulator: Result (i=1): ";
  for (auto num : res1)
    result_stream << num << " ";
  util->check_result(
    result_stream, "foo: 4, A::foo: 6, bar: 2, Vector accumulator: Result (i=1): 4 6 2 ");

  auto res3 = sig_vec(3);
  result_stream << "Vector accumulator: Result (i=3): ";
  for (auto num : res3)
    result_stream << num << " ";
  util->check_result(
    result_stream, "foo: 10, A::foo: 46, bar: 12, Vector accumulator: Result (i=3): 10 46 12 ");
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_empty_signal();
  test_mean<sigc::signal<int(int)>>();
  test_mean<sigc::trackable_signal<int(int)>>();
  test_vector_accumulator();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
