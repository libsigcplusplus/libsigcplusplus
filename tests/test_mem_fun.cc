// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/functors/mem_fun.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct test
{
int foo()  
  {cout << "test::foo()" <<endl; return 1;}
void foo(int i1) const
  {cout << "const test::foo(int "<< i1<< ')' <<endl; }
void foo(float i1)   
  {cout << "test::foo(float "<< i1<< ')' <<endl; }
double foo(int i1,int i2) 
  {cout << "test::foo("<<i1<<','<<i2<< ')' <<endl; return 1.0;}
};

int main()
{
   { /* test non-const */
     test t;
     mem_fun0(&test::foo)(t);  // on reference
     mem_fun0(&test::foo)(&t); // on pointer

     mem_fun1<int>(&test::foo)(&t,1);
     mem_fun1<float>(&test::foo)(&t,1.0);
     mem_fun2(&test::foo)(&t,1,2);
   }
   { /* test const */
     const test t=test();
     mem_fun1<int>(&test::foo)(&t,1);
     mem_fun1<int>(&test::foo)(t,1);
   }
   { /* test bound */
     test t;
     mem_fun0(&t,&test::foo)();
     mem_fun1<int>(&t,&test::foo)(1);
     mem_fun1<float>(&t,&test::foo)(1.0);
     mem_fun2(&t,&test::foo)(1,2);
   }
}
