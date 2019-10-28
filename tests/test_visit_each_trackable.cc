/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sstream>
#include <functional> //For std::ref().
#include <cstdlib>
#include <sigc++/adaptors/bind.h>
#include <sigc++/adaptors/compose.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/ptr_fun.h>

namespace
{

TestUtilities* util = nullptr;
std::ostringstream result_stream;

struct A : public sigc::trackable
{
  A() {}
};

template<typename T_type, bool I_derived = std::is_base_of<sigc::trackable, T_type>::value>
struct with_trackable;

template<typename T_type>
struct with_trackable<T_type, false>
{
  static void perform(const T_type&) { result_stream << "other "; }
};

template<typename T_type>
struct with_trackable<T_type, true>
{
  static void perform(const T_type&) { result_stream << "trackable "; }

  static void perform(T_type*) { result_stream << "trackable* "; }

  static void perform(const T_type*) { result_stream << "const trackable* "; }
};

struct print
{
  void operator()(int i) const { result_stream << "int: " << i << " "; }

  template<typename T>
  void operator()(const T& t) const
  {
    with_trackable<T>::perform(t);
  }
};

void
foo(int, int, int)
{
}

void
bar(int)
{
}

} // end anonymous namespace

void
test_hit_all_targets()
{
  int i = 1;
  A a;
  result_stream << "hit all targets: ";
  sigc::visit_each(
    print(), sigc::compose(sigc::bind(sigc::ptr_fun(&foo), std::ref(a), i), sigc::ptr_fun(&bar)));
  util->check_result(result_stream, "hit all targets: other trackable int: 1 other ");
}

void
test_hit_all_trackable()
{
  int i = 3;
  A a;
  result_stream << "hit all trackable: ";
  sigc::visit_each_trackable(
    print(), sigc::compose(sigc::bind(sigc::ptr_fun(&foo), std::ref(a), i), sigc::ptr_fun(&bar)));
  util->check_result(result_stream, "hit all trackable: trackable ");
}

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_hit_all_targets();
  test_hit_all_trackable();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
