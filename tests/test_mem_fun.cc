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
void foo(char i1)
  {cout << "const test::foo(char "<< (int)i1<< ')' <<endl; }
void foo(short i1)
  {cout << "const test::foo(short "<< (int)i1<< ')' <<endl; }
void foo(int i1) const
  {cout << "const test::foo(int "<< i1<< ')' <<endl; }
void foo(float i1) volatile
  {cout << "const test::foo(float "<< i1<< ')' <<endl; }
void foo(double i1) const volatile
  {cout << "const test::foo(double "<< i1<< ')' <<endl; }

double foo(int i1,int i2)
  {cout << "test::foo("<<i1<<','<<i2<< ')' <<endl; return 1.0;}
};

int main()
{
   { /* test non-const */
     test t;
     mem_fun1<char>(&test::foo)(t,1);  // on reference
     mem_fun1<char>(&test::foo)(&t,1); // on pointer
   }
   { /* test const */
     test t;
     mem_fun1<int>(&test::foo)(t,2);
     mem_fun1<int>(&test::foo)(&t,2);
   }
   { /* test const with const object */
     const test t=test();
     mem_fun1<int>(&test::foo)(t,3);
     mem_fun1<int>(&test::foo)(&t,3);
   }
   { /* test non-const volatile */
     test t;
     mem_fun1<float>(&test::foo)(t,4);  // on reference
     mem_fun1<float>(&test::foo)(&t,4); // on pointer
   }
   { /* test const volatile */
     test t;
     mem_fun1<double>(&test::foo)(t,5);  // on reference
     mem_fun1<double>(&test::foo)(&t,5); // on pointer
   }
   { /* test const volatile with const object */
     const test t=test();
     mem_fun1<double>(&test::foo)(t,6);  // on reference
     mem_fun1<double>(&test::foo)(&t,6); // on pointer
   }
   { /* test multiple overloads */
     test t;
     mem_fun1<int>(&test::foo)(&t,7);
     mem_fun1<float>(&test::foo)(&t,7.0);
     mem_fun2(&test::foo)(&t,7,8);
   }
   { /* test bound */
     test t;
     mem_fun1<short>(t,&test::foo)(9);
     mem_fun1<short>(&t,&test::foo)(9);
     mem_fun1<int>(t,&test::foo)(9);
     mem_fun1<int>(&t,&test::foo)(9);
     mem_fun1<float>(t,&test::foo)(9.0);
     mem_fun1<float>(&t,&test::foo)(9.0);
     mem_fun2(t,&test::foo)(9,10);
     mem_fun2(&t,&test::foo)(9,10);
   }
}
