/* Copyright (C) 2014 The libsigc++ Development Team
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
#include <string>
#include <iostream>
#include <sstream>
#include <cstdlib>
#include <sigc++/signal.h>

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

template <class T_action, class T_functor>
void visit_each(T_action&, const T_functor&)
{
  result_stream << "ns_ext::visit_each() ";
}

} // end namespace ns_ext

namespace
{
class MyClass1 : public sigc::trackable
{
public:
  MyClass1(const std::string& str) : s(str) {}

  void execute(int i)
  {
    result_stream << s << i;
  }
private:
  std::string s;
};

class MyClass2 : public ns_ext::NsExtClass, public sigc::trackable
{
public:
  MyClass2(const std::string& str) : s(str) {}

  void execute(int i)
  {
    result_stream << s << i;
  }
private:
  std::string s;
};

} // end anonymous namespace

namespace ns1
{
// User-defined adaptor, as decribed in adaptor_trait.h.
template <class T_functor>
struct MyAdaptor1 : public sigc::adapts<T_functor>
{
  template <class T_arg1=void, class T_arg2=void>
  struct deduce_result_type
  { typedef typename sigc::deduce_result_type<T_functor, T_arg1, T_arg2>::type type; };
  typedef typename sigc::functor_trait<T_functor>::result_type result_type;

  result_type
  operator()() const
  {
    result_stream << "MyAdaptor1()() ";
    return this->functor_();
  }

  template <class T_arg1>
  typename deduce_result_type<T_arg1>::type
  operator()(T_arg1 _A_arg1) const
  {
    result_stream << "MyAdaptor1()(_A_arg1) ";
    return this->functor_(_A_arg1);
  }

  template <class T_arg1, class T_arg2>
  typename deduce_result_type<T_arg1, T_arg2>::type
  operator()(T_arg1 _A_arg1, T_arg2 _A_arg2) const
  {
    result_stream << "MyAdaptor1()(_A_arg1, _A_arg2) ";
    return this->functor_(_A_arg1, _A_arg2);
  }

  // Constructs a MyAdaptor1 object that wraps the passed functor.
  // Initializes adapts<T_functor>::functor_, which is invoked from operator()().
  explicit MyAdaptor1(const T_functor& _A_functor)
    : sigc::adapts<T_functor>(_A_functor) {}
};

template <class T_action, class T_functor>
void visit_each(const T_action& _A_action,
                const MyAdaptor1<T_functor>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
}

template <typename T_functor>
inline MyAdaptor1<T_functor>
my_adaptor1(const T_functor& _A_func)
{
  return MyAdaptor1<T_functor>(_A_func);
}

} // end namespace ns1

#if SIGCTEST_CASE >= 3
// Specialization of sigc::visitor for MyAdaptor1.
namespace sigc
{
template <class T_functor>
struct visitor<ns1::MyAdaptor1<T_functor> >
{
  template <class T_action>
  static void do_visit_each(const T_action& _A_action,
                            const ns1::MyAdaptor1<T_functor>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
  }
};
} // end namespace sigc
#endif // SIGCTEST_CASE >= 3


int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::slot<void, int> sl1;

  {
    MyClass1 my_class1("x=");
    sl1 = sigc::mem_fun(&my_class1, &MyClass1::execute);
    sl1(-2);
    util->check_result(result_stream, "x=-2");

  } // auto-disconnect sl1

  sl1(-2);
  util->check_result(result_stream, "");

#if SIGCTEST_CASE >= 2
  {
    MyClass2 my_class2("y=");
    sl1 = sigc::mem_fun(&my_class2, &MyClass2::execute);
    sl1(2);
    util->check_result(result_stream, "y=2");

  } // auto-disconnect sl1

  sl1(2);
  util->check_result(result_stream, "");
#endif // SIGCTEST_CASE >= 2

  {
    MyClass1 my_class3("a=");
    sl1 = ns1::my_adaptor1(sigc::mem_fun(&my_class3, &MyClass1::execute));
    sl1(42);
    util->check_result(result_stream, "MyAdaptor1()(_A_arg1) a=42");

  } // auto-disconnect sl1

  sl1(42);
  util->check_result(result_stream, "");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
