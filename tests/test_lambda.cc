/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <iostream>
#include <sstream>
#include <string>
#include <cstdlib>
#include <sigc++/functors/functors.h>
#include <sigc++/adaptors/lambda/lambda.h>
#include <sigc++/adaptors/retype_return.h>

#ifndef SIGCXX_DISABLE_DEPRECATED

using sigc::_1;
using sigc::_2;
using sigc::_3;
using sigc::_4;
using sigc::_5;
using sigc::_6;
using sigc::_7;

// other template libraries (e.g. boost::lambda) have similar hacks built in
// to make lambda shift operators work with streams
namespace sigc {
// There is no std::basic_ostringstream<>& std::basic_ostringstream<>::operator<<(T_arg a1).
// "my_ostringstream << xyz;" invokes std::basic_ostream<>& std::basic_ostream<>::operator<<(T_arg a1),
// which returns std::basic_ostream<>&.
template <class T_arg>
struct lambda_action_deduce_result_type<bitwise<leftshift>, std::ostringstream&, T_arg>
{
  typedef std::ostream& type;
};

template <class T_arg>
struct lambda_action_deduce_result_type<bitwise<leftshift>, std::ostream&, T_arg>
{
  typedef std::ostream& type;
};
} // end namespace sigc

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

} // end anonymous namespace

#endif // SIGCXX_DISABLE_DEPRECATED

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

#ifndef SIGCXX_DISABLE_DEPRECATED

  // test lambda operators
  int a = 1;
  result_stream << "(_1 + _2) (3,4):    " << (_1 + _2) (3,4);
  util->check_result(result_stream, "(_1 + _2) (3,4):    7");

  result_stream << "(_1 + 1)  (3,4):    " << (_1 + 1)  (3,4);
  util->check_result(result_stream, "(_1 + 1)  (3,4):    4");

  result_stream << "(_2 + 1)  (3,4):    " << (_2 + 1)  (3,4);
  util->check_result(result_stream, "(_2 + 1)  (3,4):    5");

  result_stream << "(2 + _1)  (3,4):    " << (2 + _1)  (3,4);
  util->check_result(result_stream, "(2 + _1)  (3,4):    5");

  result_stream << "(2 + _2)  (3,4):    " << (2 + _2)  (3,4);
  util->check_result(result_stream, "(2 + _2)  (3,4):    6");

  result_stream << "(_1+_2*_3)(1,2,3):  " << (_1+_2*_3)(1,2,3);
  util->check_result(result_stream, "(_1+_2*_3)(1,2,3):  7");

  result_stream << "((++_1)*2)(1):      " << ((++_1)*2)(1);
  util->check_result(result_stream, "((++_1)*2)(1):      4");

  result_stream << "((++_1)*2)(a):      " << ((++_1)*2)(a);
  result_stream << "; a: "                << a;
  util->check_result(result_stream, "((++_1)*2)(a):      4; a: 1");

// gcc can't compile lambda functions with sigc::ref() parameters.
// See https://bugzilla.gnome.org/show_bug.cgi?id=669128
// TODO: Can the compilation problems be fixed?
//  result_stream << "((++_1)*2)(ref(a)): " << ((++_1)*2)(sigc::ref(a));
//  result_stream << "; a: "                << a;
//  util->check_result(result_stream, "((++_1)*2)(ref(a)): 4; a: 2");

  result_stream << "((++(*_1))*2)(&a):  " << ((++(*_1))*2)(&a);
  result_stream << "; a: "                << a;
  util->check_result(result_stream, "((++(*_1))*2)(&a):  4; a: 2");

//  result_stream << "((--(*(&_1)))*2)(ref(a)): " << ((--(*(&_1)))*2)(sigc::ref(a));
//  result_stream << "; a: "                << a;
//  util->check_result(result_stream, "((--(*(&_1)))*2)(ref(a)): 4; a: 2");

  result_stream << "(-_1)     (-5):     " << (-_1)     (-5);
  util->check_result(result_stream, "(-_1)     (-5):     5");

  result_stream << "(var(&a)[0])():     " << (sigc::var(&a)[0])();
  util->check_result(result_stream, "(var(&a)[0])():     2");

  result_stream << "(_1[_2])    (&a,0): " << (_1[_2])    (&a,0);
  util->check_result(result_stream, "(_1[_2])    (&a,0): 2");

  result_stream << "(*_1=_2)    (&a,1): " << (*_1=_2)    (&a,1);
  util->check_result(result_stream, "(*_1=_2)    (&a,1): 1");

  // Comma operator, https://bugzilla.gnome.org/show_bug.cgi?id=342911
  a = -1;
  int b = -1;
  int c = -1;
  result_stream << "(var(c) = (var(a) = _1, var(b) = _2))(2,3): "
                << (sigc::var(c) = (sigc::var(a) = _1, sigc::var(b) = _2))(2,3);
  result_stream << "; a: " << a << "; b: " << b << "; c: " << c;
  util->check_result(result_stream, "(var(c) = (var(a) = _1, var(b) = _2))(2,3): 3; a: 2; b: 3; c: 3");

  // c++ restrictions:
  // - ref() must be used to indicate that the value shall not be copied
  // - constant() is used to create a lambda and delay execution of "result_stream << 1"
  // - var() is used to create a lambda that holds a reference and is interchangable
  //   with ref() in lambda operator expressions
  // - cannot use std::endl without much hackery because it is defined as a template function
  // - cannot use "\n" without var() because arrays cannot be copied

// sigc::constant was removed 2004-08-21 by commit
// http://git.gnome.org/browse/libsigc++2/commit/?id=4a09791de9fa79d5f9ec8fbe76bf53ca1cc57ea6
//  (sigc::ref(result_stream) << sigc::constant(1) << sigc::var("\n"))();
//  util->check_result(result_stream, "1\n");

  (sigc::ref(result_stream) << _1 << std::string("\n"))("hello world");
  util->check_result(result_stream, "hello world\n");

  (sigc::ref(result_stream) << sigc::static_cast_<int>(_1) << std::string("\n"))(1.234);
  util->check_result(result_stream, "1\n");

  (sigc::var(result_stream) << 1 << sigc::var("\n"))();
  util->check_result(result_stream, "1\n");

  (sigc::var(result_stream) << _1 << std::string("\n"))("hello world");
  util->check_result(result_stream, "hello world\n");

  // auto-disconnect
  //
  // sigc::var(result_stream) returns std::ostream&, but the compiler dislikes
  // both slot<std::ostream>, slot<std::ostream&> and slot<std::ostream*>.
  sigc::slot<void> sl1;
  {
    book guest_book("karl");
    sl1 = sigc::hide_return(sigc::var(result_stream) << sigc::ref(guest_book) << sigc::var("\n"));
    sl1();
    util->check_result(result_stream, "karl\n");
  } // auto-disconnect
  sl1();
  util->check_result(result_stream, "");

  // test group adaptor
  bar the_bar;
  result_stream << (sigc::group(&foo, _1, _2)) (1, 2);
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  result_stream << (sigc::group(&foo, _2, _1)) (1, 2);
  util->check_result(result_stream, "foo(int 2, int 1) 9");

  result_stream << (sigc::group(sigc::mem_fun(&bar::test), _1, _2, _3)) (sigc::ref(the_bar), 1, 2);
  util->check_result(result_stream, "bar::test(int 1, int 2) 6");

  // same functionality as bind
  result_stream << (sigc::group(&foo, _1, 2))  (1);
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  result_stream << (sigc::group(&foo, 1, 2))   ();
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  (sigc::group(sigc::ptr_fun(&foo_void), 1)) ();
  util->check_result(result_stream, "foo_void(int 1)");

  // auto-disconnect
  sigc::slot<void> sl2;
  {
    book guest_book("karl");
    sl2 = sigc::group(&egon, sigc::ref(guest_book));
    sl2();
    util->check_result(result_stream, "egon(string 'karl')");

    result_stream << static_cast<std::string&>(guest_book);
    util->check_result(result_stream, "karl");

  } // auto-disconnect
  sl2(); // :-)
  util->check_result(result_stream, "");

  // same functionality as hide
  result_stream << (sigc::group(&foo, _1, _2)) (1,2,3);
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  (sigc::group(sigc::ptr_fun(&foo_void), _2)) (1, 2);
  util->check_result(result_stream, "foo_void(int 2)");

  // same functionality as compose
  result_stream << (sigc::group(&foo, sigc::group(&foo, _1, _2), _3)) (1,2,3);
  util->check_result(result_stream, "foo(int 1, int 2) foo(int 6, int 3) 27");

  // same functionality as retype
  result_stream << (sigc::group(&foo, sigc::static_cast_<int>(_1), 2)) (1.234);
  util->check_result(result_stream, "foo(int 1, int 2) 6");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

#else // SIGCXX_DISABLE_DEPRECATED
  std::cout << "libsigc++ lambdas are deprecated. They are not tested." << std::endl;
  // Return code 77 tells automake's test harness to skip this test.
  return util->get_result_and_delete_instance() ? 77 : EXIT_FAILURE;
#endif
} // end main()
