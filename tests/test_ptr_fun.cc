// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/functors/ptr_fun.h>

using namespace std;
using namespace sigc::functor;

int foo()  
  {cout << "foo()" <<endl; return 1;}
void foo(int i1)   
  {cout << "foo(int "<< i1<< ')' <<endl; }
void foo(float i1)   
  {cout << "foo(float "<< i1<< ')' <<endl; }
double foo(int i1,int i2) 
  {cout << "foo("<<i1<<','<<i2<< ')' <<endl; return 1.0;}

int main()
{
   ptr_fun0(&foo)();
   ptr_fun1<int>(&foo)(1);
   ptr_fun1<float>(&foo)(1.0);
   ptr_fun2(&foo)(1,2);
}
