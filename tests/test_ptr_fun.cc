// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
//#include <sigc++/functors/ptr_fun.h>
#include <sigc++/sigc++.h>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

int foo()
  {std::cout << "foo()" << std::endl; return 1;}
void foo(int i1)
  {std::cout << "foo(int "<<i1<<")" << std::endl;}

/* TODO: put something like #ifndef FORTE ... #endif around:
void bar(char i1)
  {std::cout << "foo(char "<<(int)i1<<")" << std::endl;} */
void bar(float i1)
  {std::cout << "foo(float "<<i1<<")" << std::endl;}
double bar(int i1,int i2)
  {std::cout << "foo(int "<<i1<<", int "<<i2<< ")" <<std::endl; return 1.0f;}

struct test {
  static void foo() {std::cout << "test::foo()" <<std::endl;}
};

int main()
{
  sigc::ptr_fun0(&foo)();
  sigc::ptr_fun1(&foo)(1);
/* TODO: put something like #ifndef FORTE ... #else ... #endif around:
  sigc::ptr_fun1<char>(&bar)(2);
  sigc::ptr_fun1<float>(&bar)(2.0f); and: */
  sigc::ptr_fun1(&bar)(2.0f);
  sigc::ptr_fun2(&bar)(3,5);
  sigc::ptr_fun(&test::foo)();
}
