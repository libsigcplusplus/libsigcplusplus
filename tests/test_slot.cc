// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/functors/slot.h>

class foo
{
  public:
  void operator()(int i)            {std::cout << "foo(int "<<i<<")" << std::endl;}
  void operator()(std::string& str) {std::cout << "foo(string '"<<str<<"')" << std::endl; str="foo was here";}
  void operator()(int,int)          {std::cout << "foo(int,int)" << std::endl;}
};

int main()
{
  sigc::slot<void,int> c=foo();
  c(1);
  c=foo();
  c(2);

  // test reference
  sigc::slot<void,std::string&> s=foo();
  std::string str("guest book");
  s(str);
  std::cout << str << std::endl;
}
