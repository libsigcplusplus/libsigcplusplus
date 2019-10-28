/* Copyright (C) 2014 - 2016, The libsigc++ Development Team
 *
 * This file is part of libsigc++.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library. If not, see <http://www.gnu.org/licenses/>.
 */

#include "testutilities.h"
#include <iostream>
#include <sigc++/signal.h>
#include <sigc++/adaptors/adapts.h>

// SIGCTEST_CASE 1  Assume that class sigc::visitor has not been implemented.
//                  Don't test with MyClass2, which is expected to fail in this case.
// SIGCTEST_CASE 2  Assume that class sigc::visitor has not been implemented.
//                  Test with MyClass2, although it is expected to fail in this case.
// SIGCTEST_CASE 3  Assume that class sigc::visitor has been implemented.
//                  Test with MyClass2, which is expected to succeed in this case.
// See also https://bugzilla.gnome.org/show_bug.cgi?id=724496
#define SIGCTEST_CASE 3

namespace
{
std::ostringstream result_stream;
}

// namespace assumed to belong to an external package.
namespace ns_ext
{
class NsExtClass
{
};

template<typename T_action, typename T_functor>
void
visit_each(T_action&, const T_functor&)
{
  result_stream << "ns_ext::visit_each() ";
}

} // end namespace ns_ext

namespace
{
class MyClass1 : public sigc::trackable
{
public:
  explicit MyClass1(const std::string& str) : s(str) {}

  void execute(int i) { result_stream << s << i; }

private:
  std::string s;
};

class MyClass2
: public ns_ext::NsExtClass
, public sigc::trackable
{
public:
  explicit MyClass2(const std::string& str) : s(str) {}

  void execute(int i) { result_stream << s << i; }

private:
  std::string s;
};

} // end anonymous namespace

namespace ns1
{
// User-defined adaptor, as decribed in adaptor_trait.h.
template<typename T_functor>
struct MyAdaptor1 : public sigc::adapts<T_functor>
{
  decltype(auto) operator()() const
  {
    result_stream << "MyAdaptor1()() ";
    return this->functor_();
  }

  template<typename T_arg1>
  decltype(auto) operator()(T_arg1 arg1) const
  {
    result_stream << "MyAdaptor1()(arg1) ";
    return this->functor_(arg1);
  }

  template<typename T_arg1, typename T_arg2>
  decltype(auto) operator()(T_arg1 arg1, T_arg2 arg2) const
  {
    result_stream << "MyAdaptor1()(arg1, arg2) ";
    return this->functor_(arg1, arg2);
  }

  // Constructs a MyAdaptor1 object that wraps the passed functor.
  // Initializes adapts<T_functor>::functor_, which is invoked from operator()().
  explicit MyAdaptor1(const T_functor& functor) : sigc::adapts<T_functor>(functor) {}
};

template<typename T_action, typename T_functor>
void
visit_each(const T_action& action, const MyAdaptor1<T_functor>& target)
{
  visit_each(action, target.functor_);
}

template<typename T_functor>
inline MyAdaptor1<T_functor>
my_adaptor1(const T_functor& func)
{
  return MyAdaptor1<T_functor>(func);
}

} // end namespace ns1

#if SIGCTEST_CASE >= 3
// Specialization of sigc::visitor for MyAdaptor1.
namespace sigc
{
template<typename T_functor>
struct visitor<ns1::MyAdaptor1<T_functor>>
{
  template<typename T_action>
  static void do_visit_each(const T_action& action, const ns1::MyAdaptor1<T_functor>& target)
  {
    sigc::visit_each(action, target.functor_);
  }
};
} // end namespace sigc
#endif // SIGCTEST_CASE >= 3

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::slot<void(int)> sl1;

  {
    MyClass1 my_class1("x=");
    sl1 = sigc::mem_fun(my_class1, &MyClass1::execute);
    sl1(-2);
    util->check_result(result_stream, "x=-2");

  } // auto-disconnect sl1

  sl1(-2);
  util->check_result(result_stream, "");

#if SIGCTEST_CASE >= 2
  {
    MyClass2 my_class2("y=");
    sl1 = sigc::mem_fun(my_class2, &MyClass2::execute);
    sl1(2);
    util->check_result(result_stream, "y=2");

  } // auto-disconnect sl1

  sl1(2);
  util->check_result(result_stream, "");
#endif // SIGCTEST_CASE >= 2

  {
    MyClass1 my_class3("a=");
    sl1 = ns1::my_adaptor1(sigc::mem_fun(my_class3, &MyClass1::execute));
    sl1(42);
    util->check_result(result_stream, "MyAdaptor1()(arg1) a=42");

  } // auto-disconnect sl1

  sl1(42);
  util->check_result(result_stream, "");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
