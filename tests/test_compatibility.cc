// -*- c++ -*-
/* Copyright 2003, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <string>

#include <sigc++/compatibility.h>
#include <sigc++/class_slot.h>
#include <sigc++/method_slot.h>
#include <sigc++/retype_return.h>
#include <sigc++/hide.h>
#include <sigc++/bind.h>
#include <sigc++/bind_return.h>
#include <sigc++/retype.h>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)
SIGC_USING_STD(string)

void print(const std::string &str)
  { std::cout << "print(str="<<str<<")" << std::endl; }

struct blah
{
  int test_int_int(int i)
    { std::cout << "blah::test_int_int(i="<<i<<")" << std::endl; return i*5; }
};

struct foo : public SigC::Object
{
  int test_int()
    { std::cout << "foo::test_int()" << std::endl; return 1; }
  void test_void()
    { std::cout << "foo::test_void()" << std::endl; }
  void test_void_string(const std::string& str)
    { std::cout << "foo::test_void_string(str="<<str<<")" << std::endl; }
};

struct bar : public foo
{
  float test_float_int(int i)
    { std::cout << "bar::test_float_int(i="<<i<<")" << std::endl; return i*2.5f; }
  float test_float_float(float f)
    { std::cout << "bar::test_float_float(f="<<f<<")" << std::endl; return f*2.5f; }
};

int main() {
  foo obj1;
  bar obj2;
  blah obj3;
  SigC::Signal1<void,const std::string&> printer;
  SigC::Signal1<int,int> sig1;
  SigC::Signal1<void,float> sig2;
  SigC::Signal0<float> sig3;
  SigC::Signal1<double,double> sig4;

  // SigC::SignalN, SigC::slot
  printer.connect(SigC::slot(print));
  printer.connect(SigC::slot(obj1, &foo::test_void_string));
  printer.connect(SigC::slot(obj2, &foo::test_void_string));
  printer("hello world");

  // SigC::Connection, SigC::slot_class
  SigC::Connection con = sig1.connect(SigC::slot_class(obj3, &blah::test_int_int));
  std::cout << sig1(1) << std::endl;
  con.disconnect();
  sig1(12345);

  // SigC::method_slot
  SigC::slot(&foo::test_void_string)(obj1, "hello again");
  SigC::slot(&foo::test_void_string)(obj2, "hello again");

  // SigC::retype_return
  sig1.connect(SigC::retype_return<int>(SigC::slot(obj2, &bar::test_float_int)));
  std::cout << sig1(1) << std::endl;

  // SigC::hide_return
  sig2.connect(SigC::hide_return(SigC::slot(obj2, &bar::test_float_float)));
  sig2(2);

  // SigC::hide
  sig1.clear();
  sig1.connect(SigC::hide<int>(SigC::slot(obj2, &foo::test_int)));
  std::cout << sig1(1) << std::endl;

  // SigC::bind
  sig3.connect(SigC::bind(SigC::slot(obj2, &bar::test_float_int), 3));
  std::cout << sig3() << std::endl;

  // SigC::bind_return
  sig3.clear();
  sig3.connect(SigC::bind_return(SigC::slot(obj1, &foo::test_void), 1.234));
  std::cout << sig3() << std::endl;

  // SigC::retype
  sig1.clear();
  sig1.connect(SigC::retype<int,int>(SigC::slot(obj2, &bar::test_float_float)));
  std::cout << sig1(1) << std::endl;
  sig4.connect(SigC::retype<double,double>(SigC::slot(obj2, &bar::test_float_float)));
  std::cout << sig4(1) << std::endl;

  return 0;
}
