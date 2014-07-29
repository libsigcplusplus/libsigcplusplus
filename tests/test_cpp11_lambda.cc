/* Copyright (C) 2012 The libsigc++ Development Team
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

// The purpose of this test case is threefold.
// - Test that C++11 lambda expressions can be used in connection with sigc::slot
//   and sigc::signal.
// - Show that libsigc++ lambda expressions can be replaced by C++11 lambda
//   expressions. It's shown here as a preparation for deprecating and eventually
//   deleting the libsigc++ lambda expressions.
//   See https://bugzilla.gnome.org/show_bug.cgi?id=672555
// - Test the code examples in the documentation in sigc++/adaptors/lambda/base.h
//   and sigc++/adaptors/lambda/group.h.
//
// At present (August 2012) this test case contains approximately the same tests
// as test_lambda.cc, but with libsigc++ lambda expressions replaced by C++11
// lambda expressions, where possible.
// The only real disadvantage of the C++11 lambda expressions is that a slot that
// contains an object derived from sigc::trackable is not automatically disconnected
// when the object is deleted, if a reference to the object is stored in a C++11
// lambda expression, connected to the slot. But if you use sigc::track_obj(),
// the slot is automatically disconnected. Thus, the disadvantage is insignificant.
//
// To test the C++11 lambda expressions with gcc 4.6.3 (and probably some later
// versions of gcc; gcc 4.7.x also understands -std=c++11):
//   make CXXFLAGS='-g -O2 -std=c++0x' test_cpp11_lambda
//   ./test_cpp11_lambda
//   echo $?
// If test_cpp11_lambda writes nothing and the return code is 0, the test has passed.

#if __cplusplus >= 201103L || defined(__GXX_EXPERIMENTAL_CXX0X__) || _MSC_VER >= 1700
#  define USING_CPP11_LAMBDA_EXPRESSIONS
#endif

#include "testutilities.h"
#include <string>
#include <iostream>
#include <sstream>
#include <functional>
#include <cstdlib>
#include <sigc++/functors/functors.h>
#include <sigc++/bind.h>
#include <sigc++/reference_wrapper.h>
#include <sigc++/adaptors/track_obj.h>
#include <sigc++/signal.h>

#ifdef USING_CPP11_LAMBDA_EXPRESSIONS
namespace sigc
{
  SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE
}

namespace
{
std::ostringstream result_stream;

int foo(int i, int j)
{
  result_stream << "foo(int " << i << ", int " << j << ") ";
  return 4*i + j;
}

void foo_void(int i)
{
  result_stream << "foo_void(int " << i << ")";
}

struct bar
{
  int test(int i, int j)
  {
    result_stream << "bar::test(int " << i << ", int " << j << ") ";
    return 4*i + j;
  }

  void test_void(int i)
  {
    result_stream << "bar::test_void(int " << i << ")";
  }
};

void egon(std::string& str)
{
  result_stream << "egon(string '" << str << "')";
  str = "egon was here";
}

struct book : public sigc::trackable
{
  explicit book(const std::string& name) : name_(name) {}
  operator std::string& () { return name_; }
  std::string name_;
};

inline std::ostringstream& operator << (std::ostringstream& s, const book& b)
{
  s << b.name_;
  return s;
}

void foo_group1(int i, int j)
{
  result_stream << "foo_group1(int " << i << ", int " << j << ")";
}

int bar_group1(int i)
{
  result_stream << "bar_group1(int " << i << ") ";
  return i + 2;
}

void foo_group2(int i)
{
  result_stream << "foo_group2(int " << i << ")";
}

void foo_group3(int& i)
{
  result_stream << "foo_group3(int " << i << ")";
  ++i;
}

struct bar_group4 : public sigc::trackable
{
};

void foo_group4(bar_group4&)
{
  result_stream << "foo_group4(bar_group4&)";
}

} // end anonymous namespace

#endif // USING_CPP11_LAMBDA_EXPRESSIONS


int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

#ifdef USING_CPP11_LAMBDA_EXPRESSIONS

  // test lambda operators
  int a = 1;
  //std::cout << "(_1 + _2) (3,4):    " << (_1 + _2) (3,4)      << std::endl;
  result_stream << ([] (int a, int b) -> int { return a + b; }(3,4));
  util->check_result(result_stream, "7");

  //std::cout << "(_1 + 1)  (3,4):    " << (_1 + 1)  (3,4)      << std::endl;
  result_stream << ([] (int a, int) -> int { return a + 1; }(3,4));
  util->check_result(result_stream, "4");

  //std::cout << "(_2 + 1)  (3,4):    " << (_2 + 1)  (3,4)      << std::endl;
  result_stream << ([] (int, int b) -> int { return b + 1; }(3,4));
  util->check_result(result_stream, "5");

  //std::cout << "(2 + _1)  (3,4):    " << (2 + _1)  (3,4)      << std::endl;
  result_stream << ([] (int a, int) -> int { return 2 + a; }(3,4));
  util->check_result(result_stream, "5");

  //std::cout << "(2 + _2)  (3,4):    " << (2 + _2)  (3,4)      << std::endl;
  result_stream << ([] (int, int b) -> int { return 2 + b; }(3,4));
  util->check_result(result_stream, "6");

  //std::cout << "(_1+_2*_3)(1,2,3):  " << (_1+_2*_3)(1,2,3)    << std::endl;
  result_stream << ([] (int a, int b, int c) -> int { return a + b*c; }(1,2,3));
  util->check_result(result_stream, "7");

  //std::cout << "((++_1)*2)(1):      " << ((++_1)*2)(1)        << std::endl;
  result_stream << ([] (int a) -> int { return ++a * 2; }(1));
  util->check_result(result_stream, "4");

  //std::cout << "((++_1)*2)(a):      " << ((++_1)*2)(a);
  //std::cout << "; a: "                << a                    << std::endl;
  result_stream << ([] (int x) -> int { return ++x * 2; }(a)) << " " << a;
  util->check_result(result_stream, "4 1");

  // gcc can't compile libsigc++ lambda expressions with sigc::ref() parameters.
  // See https://bugzilla.gnome.org/show_bug.cgi?id=669128
  //  std::cout << "((++_1)*2)(ref(a)): " << ((++_1)*2)(sigc::ref(a));
  //  std::cout << "; a: "                << a                    << std::endl;
  result_stream << ([] (std::reference_wrapper<int> x) -> int { return ++x * 2; }(std::ref(a)));
  result_stream << " " << a;
  util->check_result(result_stream, "4 2");
  result_stream << ([] (int& x) -> int { return ++x * 2; }(a));
  result_stream << " " << a;
  util->check_result(result_stream, "6 3");

  //std::cout << "((++(*_1))*2)(&a):  " << ((++(*_1))*2)(&a);
  //std::cout << "; a: "                << a                    << std::endl;
  result_stream << ([] (int* x) -> int { return ++(*x) * 2; }(&a));
  result_stream << " " << a;
  util->check_result(result_stream, "8 4");

  //  std::cout << "((--(*(&_1)))*2)(ref(a)): " << ((--(*(&_1)))*2)(sigc::ref(a));
  //  std::cout << "; a: "                << a                    << std::endl;
  result_stream << ([] (std::reference_wrapper<int> x) -> int { return --(*(&x)) * 2; }(std::ref(a)));
  result_stream << " " << a;
  util->check_result(result_stream, "6 3");
  result_stream << ([] (int& x) -> int { return --(*(&x)) * 2; }(a));
  result_stream << " " << a;
  util->check_result(result_stream, "4 2");

  //std::cout << "(-_1)     (-5):     " << (-_1)     (-5)       << std::endl;
  result_stream << ([] (int x) -> int { return -x; }(-5));
  util->check_result(result_stream, "5");

  //std::cout << "(var(&a)[0])():     " << (sigc::var(&a)[0])() << std::endl;
  result_stream << ([&a]() -> int { return a; }());
  util->check_result(result_stream, "2");

  //std::cout << "(_1[_2])    (&a,0): " << (_1[_2])    (&a,0)   << std::endl;
  result_stream << ([] (int* x, int y) -> int { return x[y]; }(&a,0));
  util->check_result(result_stream, "2");

  //std::cout << "(*_1=_2)    (&a,1): " << (*_1=_2)    (&a,1)   << std::endl;
  result_stream << ([] (int* x, int y) -> int { *x = y; return *x; }(&a,1));
  util->check_result(result_stream, "1");

  // Comma operator, https://bugzilla.gnome.org/show_bug.cgi?id=342911
  a = -1;
  int b = -1;
  int c = -1;
  //std::cout << "(var(c) = (var(a) = _1, var(b) = _2))(2,3): "
  //          << (sigc::var(c) = (sigc::var(a) = _1, sigc::var(b) = _2))(2,3);
  //std::cout << "; a: " << a << "; b: " << b << "; c: " << c << std::endl;
  result_stream << ([&a,&b,&c](int x, int y) -> int { return c = (a = x, b = y); }(2,3));
  result_stream << " " << a << " " << b << " " << c;
  util->check_result(result_stream, "3 2 3 3");

  // c++ restrictions:
  // - ref() must be used to indicate that the value shall not be copied
  // - constant() is used to create a lambda and delay execution of "std::cout << 1"
  // - var() is used to create a lambda that holds a reference and is interchangable with ref() in lambda operator expressions
  // - cannot use std::endl without much hackery because it is defined as a template function
  // - cannot use "\n" without var() because arrays cannot be copied
  //  (sigc::ref(std::cout) << sigc::constant(1) << sigc::var("\n"))();
  [](){ result_stream << 1 << "\n"; }();
  util->check_result(result_stream, "1\n");

  //(sigc::ref(std::cout) << _1 << std::string("\n"))("hello world");
  [](const char* a){ result_stream << a << std::string("\n"); }("hello world");
  util->check_result(result_stream, "hello world\n");

  //(sigc::ref(std::cout) << sigc::static_cast_<int>(_1) << std::string("\n"))(1.234);
  [](double a){ result_stream << static_cast<int>(a) << std::string("\n"); }(1.234);
  util->check_result(result_stream, "1\n");

  //  (sigc::var(std::cout) << 1 << sigc::var("\n"))();
  [](){ result_stream << 1 << "\n"; }();
  util->check_result(result_stream, "1\n");

  //(sigc::var(std::cout) << _1 << std::string("\n"))("hello world");
  [](const char* a){ result_stream << a << std::string("\n"); }("hello world");
  util->check_result(result_stream, "hello world\n");

  // auto-disconnect
  // Here's an area where the libsigc++ lambda expressions are advantageous.
  // If you want to auto-disconnect a slot with a C++11 lambda expression
  // that contains references to sigc::trackable-derived objects, you must use
  // sigc::track_obj().
  sigc::slot<void, std::ostringstream&> sl1;
  {
    book guest_book("karl");
    //sl1 = (sigc::var(std::cout) << sigc::ref(guest_book) << sigc::var("\n"));
    // sl1 = [&guest_book](std::ostringstream& stream){ stream << guest_book << "\n"; }; // no auto-disconnect
    sl1 = sigc::track_obj([&guest_book](std::ostringstream& stream){ stream << guest_book << "\n"; }, guest_book);
    sl1(result_stream);
    util->check_result(result_stream, "karl\n");

  } // auto-disconnect

  sl1(result_stream);
  util->check_result(result_stream, "");

  // test group adaptor, here replaced by std::bind
  bar the_bar;
  //std::cout << (sigc::group(&foo, _1, _2)) (1, 2) << std::endl;
  result_stream << std::bind(&foo, std::placeholders::_1, std::placeholders::_2)(1, 2);
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  //std::cout << (sigc::group(&foo, _2, _1)) (1, 2) << std::endl;
  result_stream << std::bind(&foo, std::placeholders::_2, std::placeholders::_1)(1, 2);
  util->check_result(result_stream, "foo(int 2, int 1) 9");

  //std::cout << (sigc::group(sigc::mem_fun(&bar::test), _1, _2, _3)) (sigc::ref(the_bar), 1, 2) << std::endl;
  // std::ref(the_bar) is not necessary. It can make the call ambiguous.
  // Even without std::ref() the_bar is not copied.
  result_stream << std::bind(std::mem_fn(&bar::test), std::placeholders::_1,
    std::placeholders::_2, std::placeholders::_3)(the_bar, 1, 2);
  util->check_result(result_stream, "bar::test(int 1, int 2) 6");

  // same functionality as bind
  //std::cout << (sigc::group(&foo, _1, 2))  (1)    << std::endl;
  result_stream << std::bind(&foo, std::placeholders::_1, 2)(1);
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  //std::cout << (sigc::group(&foo, 1, 2))   ()     << std::endl;
  result_stream << std::bind(&foo, 1, 2)();
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  //(sigc::group(sigc::ptr_fun(&foo_void), 1)) ();
  std::bind(sigc::ptr_fun(&foo_void), 1)();
  util->check_result(result_stream, "foo_void(int 1)");

  // std::bind() does not work well together with sigc::slot and sigc::signal::connect().
  // std::bind() typically creates a functor whose operator()() is a variadic template.
  // SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE can't deduce the result type
  // of such a functor.
  // If the result of std::bind() is assigned to a std::function, the created
  // functor has an unambiguous operator()().

  // auto-disconnect
  sigc::slot<void> sl2;
  {
    book guest_book("karl");
    //sl2 = sigc::group(&egon, sigc::ref(guest_book));
    // sl2 = [&guest_book] () { egon(guest_book); }; // no auto-disconnect
    // sl2 = std::bind(&egon, std::ref(guest_book)); // does not compile (gcc 4.6.3)
    sl2 = sigc::track_obj([&guest_book] () { egon(guest_book); }, guest_book);
    sl2();
    util->check_result(result_stream, "egon(string 'karl')");

    //std::cout << static_cast<std::string&>(guest_book) << std::endl;
    result_stream << static_cast<std::string&>(guest_book);
    util->check_result(result_stream, "egon was here");

  } // auto-disconnect

  sl2();
  util->check_result(result_stream, "");

  // More auto-disconnect
  {
    book guest_book("charlie");
    //sl2 = sigc::group(&egon, sigc::ref(guest_book));
    // sl2 = std::bind(&egon, std::ref(guest_book)); // does not compile (gcc 4.6.3)
    std::function<void()> fn2 = std::bind(&egon, std::ref(guest_book));
    //sl2 = fn2; // no auto-disconnect
    sl2 = sigc::track_obj(fn2, guest_book);
    sl2();
    util->check_result(result_stream, "egon(string 'charlie')");

    //std::cout << static_cast<std::string&>(guest_book) << std::endl;
    result_stream << static_cast<std::string&>(guest_book);
    util->check_result(result_stream, "egon was here");

  } // auto-disconnect

  sl2();
  util->check_result(result_stream, "");

  // same functionality as hide
  //std::cout << (sigc::group(&foo, _1, _2)) (1,2,3) << std::endl;
  result_stream << std::bind(&foo, std::placeholders::_1, std::placeholders::_2)(1,2,3);
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  //(sigc::group(sigc::ptr_fun(&foo_void), _2)) (1, 2);
  std::bind(&foo_void, std::placeholders::_2)(1, 2);
  util->check_result(result_stream, "foo_void(int 2)");

  // same functionality as compose
  //std::cout << (sigc::group(&foo, sigc::group(&foo, _1, _2), _3)) (1,2,3) << std::endl;
  result_stream << std::bind(&foo, std::bind(&foo, std::placeholders::_1, std::placeholders::_2),
    std::placeholders::_3)(1,2,3);
  util->check_result(result_stream, "foo(int 1, int 2) foo(int 6, int 3) 27");

  // same functionality as retype
  //std::cout << (sigc::group(&foo, sigc::static_cast_<int>(_1), 2)) (1.234) << std::endl;
  result_stream << ([] (double x) -> int { return foo(static_cast<int>(x), 2); }(1.234));
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  // Code examples with C++11 lambda expressions and std::bind, which can replace
  // libsigc++ examples in the documentation of libsigc++ lambdas and sigc::group.
  // -----------------------------------------------------------------------------

  //--- sigc++/adaptors/lambda/macros/base.h.m4

  //std::cout << sigc::_1(10,20,30); // returns 10
  result_stream << ([] (int x, int, int) -> int { return x; }(10,20,30));
  util->check_result(result_stream, "10");

  //std::cout << sigc::_2(10,20,30); // returns 20
  result_stream << ([] (int, int y, int) -> int { return y; }(10,20,30));
  util->check_result(result_stream, "20");

  //std::cout << (sigc::_1 + 5)(3); // returns (3 + 5)
  result_stream << ([] (int x) -> int { return x + 5; }(3));
  util->check_result(result_stream, "8");

  //std::cout << (sigc::_1 * sigc::_2)(7,10); // returns (7 * 10)
  result_stream << ([] (int x, int y) -> int { return x * y; }(7,10));
  util->check_result(result_stream, "70");

  //int main(int argc, char* argv[])
  //{
  //  int data;
  //  sigc::signal<int> readValue;
  //
  //  readValue.connect(sigc::var(data));
  //
  //  data = 3;
  //  std::cout << readValue() << std::endl; //Prints 3.
  //
  //  data = 5;
  //  std::cout << readValue() << std::endl; //Prints 5.
  //}
  {
    int data;
    sigc::signal<int> readValue;

    readValue.connect([&data] () -> int { return data; });

    data = 3;
    result_stream << readValue();
    util->check_result(result_stream, "3");

    data = 5;
    result_stream << readValue();
    util->check_result(result_stream, "5");
  }

  //--- sigc++/adaptors/lambda/macros/group.h.m4

  // argument binding ...
  //sigc::group(&foo,10,sigc::_1)(20); //fixes the first argument and calls foo(10,20)
  std::bind(&foo_group1, 10, std::placeholders::_1)(20);
  util->check_result(result_stream, "foo_group1(int 10, int 20)");

  //sigc::group(&foo,sigc::_1,30)(40); //fixes the second argument and calls foo(40,30)
  std::bind(&foo_group1, std::placeholders::_1, 30)(40);
  util->check_result(result_stream, "foo_group1(int 40, int 30)");

  // argument reordering ...
  //sigc::group(&foo,sigc::_2,sigc::_1)(1,2); //calls foo(2,1)
  std::bind(&foo_group1, std::placeholders::_2, std::placeholders::_1)(1,2);
  util->check_result(result_stream, "foo_group1(int 2, int 1)");

  // argument hiding ...
  //sigc::group(&foo,sigc::_1,sigc::_2)(1,2,3); //calls foo(1,2)
  std::bind(&foo_group1, std::placeholders::_1, std::placeholders::_2)(1,2,3);
  util->check_result(result_stream, "foo_group1(int 1, int 2)");

  // functor composition ...
  //sigc::group(&foo,sigc::_1,sigc::group(&bar,sigc::_2))(1,2); //calls foo(1,bar(2))
  std::bind(&foo_group1,  std::placeholders::_1, std::bind(&bar_group1, std::placeholders::_2))(1,2);
  util->check_result(result_stream, "bar_group1(int 2) foo_group1(int 1, int 4)");

  // algebraic expressions ...
  // sigc::group(&foo,sigc::_1*sigc::_2,sigc::_1/sigc::_2)(6,3); //calls foo(6*3,6/3)
  [] (int x, int y) { foo_group1(x*y, x/y); }(6,3);
  util->check_result(result_stream, "foo_group1(int 18, int 2)");

  {
    sigc::signal<void,int,int> some_signal;
    //some_signal.connect(sigc::group(&foo,sigc::_2));
    //some_signal.connect(std::bind(&foo_group2, std::placeholders::_2)); // does not compile (gcc 4.6.3)
    some_signal.connect([](int, int y) { foo_group2(y); });
    some_signal.emit(1,2);
    util->check_result(result_stream, "foo_group2(int 2)");
  }

  {
    int some_int = 0;
    sigc::signal<void> some_signal;
    //some_signal.connect(sigc::group(&foo,sigc::ref(some_int)));
    //some_signal.connect(std::bind(&foo_group3, std::ref(some_int))); // does not compile (gcc 4.6.3)
    //some_signal.connect(sigc::bind(&foo_group3, sigc::ref(some_int))); // compiles, but we prefer std::bind() or C++11 lambda
    some_signal.connect([&some_int](){ foo_group3(some_int); });
    some_signal.emit();
    result_stream << " " << some_int;
    util->check_result(result_stream, "foo_group3(int 0) 1");
  }

  {
    //struct bar : public sigc::trackable {} some_bar;
    sigc::signal<void> some_signal;
    {
      bar_group4 some_bar;
      //some_signal.connect(sigc::group(&foo,sigc::ref(some_bar)));
      // disconnected automatically if some_bar goes out of scope
      //some_signal.connect([&some_bar](){ foo_group4(some_bar); }); // no auto-disconnect
      //some_signal.connect(sigc::bind(&foo_group4, sigc::ref(some_bar))); // auto-disconnects, but we prefer C++11 lambda
      some_signal.connect(sigc::track_obj([&some_bar](){ foo_group4(some_bar); }, some_bar));
      some_signal.emit();
      util->check_result(result_stream, "foo_group4(bar_group4&)");
    }
    some_signal.emit();
    util->check_result(result_stream, "");
  }
  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

#else // not USING_CPP11_LAMBDA_EXPRESSIONS
  std::cout << "The compiler capabilities don't allow test of C++11 lambda expressions." << std::endl;
  // Return code 77 tells automake's test harness to skip this test.
  return util->get_result_and_delete_instance() ? 77 : EXIT_FAILURE;
#endif
} // end main()
