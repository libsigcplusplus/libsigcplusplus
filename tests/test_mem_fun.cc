// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

//#include <sigc++/functors/mem_fun.h>
#include <sigc++/sigc++.h>
#include <iostream>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

struct test
{
void foo(short i1)
  {std::cout << "const test::foo(short "<< i1<< ')' <<std::endl; }
void foo_const(int i1) const
  {std::cout << "const test::foo(int "<< i1<< ')' <<std::endl; }
void foo_volatile(float i1) volatile
  {std::cout << "const test::foo(float "<< i1<< ')' <<std::endl; }
void foo_const_volatile(double i1) const volatile
  {std::cout << "const test::foo(double "<< i1<< ')' <<std::endl; }

void foo_overloaded(char i1)
  {std::cout << "const test::foo(char "<< int(i1)<< ')' <<std::endl; }
/* TODO: put something like #ifndef FORTE ... #endif around:
void foo_overloaded(short i1)
  {std::cout << "const test::foo(char "<< (int)i1<< ')' <<std::endl; } */
double foo_overloaded(int i1,int i2)
  {std::cout << "test::foo("<<i1<<','<<i2<< ')' <<std::endl; return 1.0;}
};

int main()
{
   { /* test non-const */
     test t;
     sigc::mem_fun(&test::foo)(t, 1);  // on reference
     sigc::mem_fun(&test::foo)(&t, 1); // on pointer
   }
   { /* test const */
     test t;
     sigc::mem_fun(&test::foo_const)(t, 2);
     sigc::mem_fun(&test::foo_const)(&t, 2);
   }
   { /* test const with const object */
     const test t=test();
     sigc::mem_fun(&test::foo_const)(t, 3);
     sigc::mem_fun(&test::foo_const)(&t, 3);
   }
   { /* test non-const volatile */
     test t;
     sigc::mem_fun(&test::foo_volatile)(t, 4);  // on reference
     sigc::mem_fun(&test::foo_volatile)(&t, 4); // on pointer
   }
   { /* test const volatile */
     test t;
     sigc::mem_fun(&test::foo_const_volatile)(t, 5);  // on reference
     sigc::mem_fun(&test::foo_const_volatile)(&t, 5); // on pointer
   }
   { /* test const volatile with const object */
     const test t=test();
     sigc::mem_fun(&test::foo_const_volatile)(t, 6);  // on reference
     sigc::mem_fun(&test::foo_const_volatile)(&t, 6); // on pointer
   }
   { /* test overloaded */
//     test t;
/* TODO: put something like #ifndef FORTE (some older version, I think) or AIX xlC... #else ... #endif around:
     sigc::mem_fun1<char>(&test::foo_overloaded)(&t,7);
     sigc::mem_fun1<short>(&test::foo_overloaded)(&t,7); and: */
     
/*
     sigc::mem_fun1(&test::foo_overloaded)(&t, 7);
     sigc::mem_fun2(&test::foo_overloaded)(&t, 7, 8);
*/
   }
   { /* test bound */
     test t;
     sigc::mem_fun(t,&test::foo)(9);
     sigc::mem_fun(&t,&test::foo)(9);
     sigc::mem_fun(t,&test::foo_const)(9);
     sigc::mem_fun(&t,&test::foo_const)(9);
     sigc::mem_fun(t,&test::foo_volatile)(9);
     sigc::mem_fun(&t,&test::foo_volatile)(9);
     
/* TODO: put something like #ifndef AIX xlC ... #else ... #endif around:
     sigc::mem_fun2(t,&test::foo_overloaded)(9, 10);
     sigc::mem_fun2(&t,&test::foo_overloaded)(9, 10);
*/
   }
}
