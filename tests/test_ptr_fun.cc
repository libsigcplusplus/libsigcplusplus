// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/functors/ptr_fun.h>

int foo()  
  {std::cout << "foo()" <<std::endl; return 1;}
void foo(int i1)   
  {std::cout << "foo(int "<< i1<< ')' <<std::endl; }
void foo(float i1)   
  {std::cout << "foo(float "<< i1<< ')' <<std::endl; }
double foo(int i1,int i2) 
  {std::cout << "foo("<<i1<<','<<i2<< ')' <<std::endl; return 1.0;}

int main()
{
  sigc::ptr_fun0(&foo)();
  sigc::ptr_fun1<int>(&foo)(1);
  sigc::ptr_fun1<float>(&foo)(1.0);
  sigc::ptr_fun2(&foo)(1,2);
}
