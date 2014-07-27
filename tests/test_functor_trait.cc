/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sstream>
#include <cstdlib>
#include <sigc++/adaptors/bind.h>
#include <sigc++/adaptors/compose.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/ptr_fun.h>

namespace
{
std::ostringstream result_stream;

class trackable {};

struct A : public trackable { A() {} };

template <class T_type, bool I_derived = sigc::is_base_and_derived<trackable,T_type>::value>
struct with_trackable;

template <class T_type>
struct with_trackable<T_type,false>
{
  static void perform(const T_type&)
  {
    result_stream << "other ";
  }
};

template <class T_type>
struct with_trackable<T_type,true>
{
  static void perform(const T_type&)
  {
    result_stream << "trackable ";
  }

  static void perform(T_type*)
  {
    result_stream << "trackable* ";
  }

  static void perform(const T_type*)
  {
    result_stream << "const trackable* ";
  }
};

struct print
{
  void operator()(int i) const
  {
    result_stream << "int: " << i << " ";
  }

  template <class T>
  void operator()(const T& t) const
  {
    with_trackable<T>::perform(t);
  }
};

void foo(int, int, int)
{}

void bar(int)
{}

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  int i = 1;
  int j = 2;
  int k = 3;
  A a;
  result_stream << "hit all targets: ";
  sigc::visit_each(print(), sigc::compose(sigc::bind(sigc::ptr_fun3(&foo), sigc::ref(a), i), sigc::ptr_fun1(&bar)));
  util->check_result(result_stream, "hit all targets: other trackable int: 1 other ");

  result_stream << "hit all ints: ";
  sigc::visit_each_type<int>(print(), sigc::compose(sigc::bind(sigc::ptr_fun3(&foo), sigc::ref(a), j),sigc::ptr_fun1(&bar)));
  util->check_result(result_stream, "hit all ints: int: 2 ");

  result_stream << "hit all trackable: ";
  sigc::visit_each_type<trackable>(print(), sigc::compose(sigc::bind(sigc::ptr_fun3(&foo), sigc::ref(a), k),sigc::ptr_fun1(&bar)));
  util->check_result(result_stream, "hit all trackable: trackable ");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
