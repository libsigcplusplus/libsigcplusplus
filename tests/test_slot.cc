// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/functors/slot.h>
#include <iostream>
#include <string>

//The Tru64 compiler seems to need this to avoid an unresolved symbol
//See bug #161503
#include <new>
SIGC_USING_STD(new)

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)
SIGC_USING_STD(string)

class foo
{
  public:
  void operator()(int i)            {std::cout << "foo(int "<<i<<")" << std::endl;}
  void operator()(std::string& str) {std::cout << "foo(string '"<<str<<"')" << std::endl; str="foo was here";}
  void operator()(int,int)          {std::cout << "foo(int,int)" << std::endl;}
};

int main()
{
  // simple test
  sigc::slot<void,int> s1 = foo();
  s1(1);
  s1 = foo();
  s1(2);

  // test implicit conversion
  sigc::slot<void,char> s2 = foo();
  s2(3);

  // test reference
  sigc::slot<void,std::string&> sl1 = foo();
  std::string str("guest book");
  sl1(str);
  std::cout << str << std::endl;

  // test operator=
  str = "guest book";
  sigc::slot<void,std::string&> sl2;
  sl2 = sl1;
  sl1 = sl2;
  sl1(str);
  std::cout << str << std::endl;

  // test copy ctor
  sigc::slot<void,int> s1_clone(s1);
}
