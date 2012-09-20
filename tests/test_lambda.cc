// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <string>
#include <sigc++/functors/functors.h>
#include <sigc++/adaptors/lambda/lambda.h>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)
SIGC_USING_STD(string)
SIGC_USING_STD(ostream)

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
template <class T_arg>
struct lambda_action_deduce_result_type<bitwise<leftshift>, std::ostream&, T_arg>
{
  typedef std::ostream& type;
};
}

int foo(int i, int j)
  {std::cout << "foo(int "<<i<<", int "<<j<<")" << std::endl; return 4*i+j;}

void foo_void(int i)
  {std::cout << "foo_void(int "<<i<<")" << std::endl;}

struct bar
{
  int test(int i, int j)
    {std::cout << "bar::test(int "<<i<<", int "<<j<<")" << std::endl; return 4*i+j;}
  void test_void(int i)
    {std::cout << "bar::test_void(int "<<i<<")" << std::endl;}
};

void egon(std::string& str)
  {std::cout << "egon(string '"<<str<<"')" << std::endl; str="egon was here";}

struct book : public sigc::trackable
{
  book(const std::string& name) : name_(name) {}
  operator std::string& () {return name_;}
  std::string name_;
};

inline std::ostream& operator << (std::ostream& s, const book& b) { s << b.name_; return s; }


int main()
{
  // test lambda operators
  int a = 1;
  std::cout << "(_1 + _2) (3,4):    " << (_1 + _2) (3,4)      << std::endl;
  std::cout << "(_1 + 1)  (3,4):    " << (_1 + 1)  (3,4)      << std::endl;
  std::cout << "(_2 + 1)  (3,4):    " << (_2 + 1)  (3,4)      << std::endl;
  std::cout << "(2 + _1)  (3,4):    " << (2 + _1)  (3,4)      << std::endl;
  std::cout << "(2 + _2)  (3,4):    " << (2 + _2)  (3,4)      << std::endl;
  std::cout << "(_1+_2*_3)(1,2,3):  " << (_1+_2*_3)(1,2,3)    << std::endl;
  std::cout << "((++_1)*2)(1):      " << ((++_1)*2)(1)        << std::endl;
  std::cout << "((++_1)*2)(a):      " << ((++_1)*2)(a);
  std::cout << "; a: "                << a                    << std::endl;
// gcc can't compile lambda functions with sigc::ref() parameters.
// See https://bugzilla.gnome.org/show_bug.cgi?id=669128
// TODO: Can the compilation problems be fixed?
//  std::cout << "((++_1)*2)(ref(a)): " << ((++_1)*2)(sigc::ref(a));
//  std::cout << "; a: "                << a                    << std::endl;
  std::cout << "((++(*_1))*2)(&a):  " << ((++(*_1))*2)(&a);
  std::cout << "; a: "                << a                    << std::endl;
//  std::cout << "((--(*(&_1)))*2)(ref(a)): " << ((--(*(&_1)))*2)(sigc::ref(a));
//  std::cout << "; a: "                << a                    << std::endl;
  std::cout << "(-_1)     (-5):     " << (-_1)     (-5)       << std::endl;
  std::cout << "(var(&a)[0])():     " << (sigc::var(&a)[0])() << std::endl;
  std::cout << "(_1[_2])    (&a,0): " << (_1[_2])    (&a,0)   << std::endl;
  std::cout << "(*_1=_2)    (&a,1): " << (*_1=_2)    (&a,1)   << std::endl;

  // Comma operator, https://bugzilla.gnome.org/show_bug.cgi?id=342911
  a = -1;
  int b = -1;
  int c = -1;
  std::cout << "(var(c) = (var(a) = _1, var(b) = _2))(2,3): "
            << (sigc::var(c) = (sigc::var(a) = _1, sigc::var(b) = _2))(2,3);
  std::cout << "; a: " << a << "; b: " << b << "; c: " << c << std::endl;

       // c++ restrictions:
       // - ref() must be used to indicate that the value shall not be copied
       // - constant() is used to create a lambda and delay execution of "std::cout << 1"
       // - var() is used to create a lambda that holds a reference and is interchangable with ref() in lambda operator expressions
       // - cannot use std::endl without much hackery because it is defined as a template function
       // - cannot use "\n" without var() because arrays cannot be copied
//  (sigc::ref(std::cout) << sigc::constant(1) << sigc::var("\n"))();
  (sigc::ref(std::cout) << _1 << std::string("\n"))("hello world");
  (sigc::ref(std::cout) << sigc::static_cast_<int>(_1) << std::string("\n"))(1.234);
//  (sigc::var(std::cout) << 1 << sigc::var("\n"))();
  (sigc::var(std::cout) << _1 << std::string("\n"))("hello world");

  // auto-disconnect
  sigc::slot<void*> sl1; // TODO: why does the compiler demand void* ?
  {
    book guest_book("karl");
//    sl1 = (sigc::var(std::cout) << sigc::ref(guest_book) << sigc::var("\n"));
    sl1();
  }    // auto-disconnect // TODO: "Bus error" => fix bug !
  sl1(); // :-)


  // test grp adaptor
  bar the_bar;
  std::cout << (sigc::group(&foo, _1, _2)) (1, 2) << std::endl;
  std::cout << (sigc::group(&foo, _2, _1)) (1, 2) << std::endl;
  std::cout << (sigc::group(sigc::mem_fun(&bar::test), _1, _2, _3)) (sigc::ref(the_bar), 1, 2) << std::endl;

  // same functionality as bind
  std::cout << (sigc::group(&foo, _1, 2))  (1)    << std::endl;
  std::cout << (sigc::group(&foo, 1, 2))   ()     << std::endl;
  (sigc::group(sigc::ptr_fun(&foo_void), 1)) ();

  // auto-disconnect
  sigc::slot<void> sl2;
  {
    book guest_book("karl");
    sl2 = sigc::group(&egon, sigc::ref(guest_book));
    sl2();
    std::cout << static_cast<std::string&>(guest_book) << std::endl;
  }    // auto-disconnect
  sl2(); // :-)

  // same functionality as hide
  std::cout << (sigc::group(&foo, _1, _2)) (1,2,3) << std::endl;
  (sigc::group(sigc::ptr_fun(&foo_void), _2)) (1, 2);

  // same functionality as compose
  std::cout << (sigc::group(&foo, sigc::group(&foo, _1, _2), _3)) (1,2,3) << std::endl;

  // same functionality as retype
  std::cout << (sigc::group(&foo, sigc::static_cast_<int>(_1), 2)) (1.234) << std::endl;

  return 0;
}
