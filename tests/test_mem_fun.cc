// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/functors/mem_fun.h>
#include <iostream>

struct test
{
void foo(char i1)
  {std::cout << "const test::foo(char "<< (int)i1<< ')' <<std::endl; }
void foo(short i1)
  {std::cout << "const test::foo(short "<< (int)i1<< ')' <<std::endl; }
void foo(int i1) const
  {std::cout << "const test::foo(int "<< i1<< ')' <<std::endl; }
void foo(float i1) volatile
  {std::cout << "const test::foo(float "<< i1<< ')' <<std::endl; }
void foo(double i1) const volatile
  {std::cout << "const test::foo(double "<< i1<< ')' <<std::endl; }

double foo(int i1,int i2)
  {std::cout << "test::foo("<<i1<<','<<i2<< ')' <<std::endl; return 1.0;}
};

int main()
{
   { /* test non-const */
     test t;
     sigc::mem_fun1<char>(&test::foo)(t,1);  // on reference
     sigc::mem_fun1<char>(&test::foo)(&t,1); // on pointer
   }
   { /* test const */
     test t;
     sigc::mem_fun1<int>(&test::foo)(t,2);
     sigc::mem_fun1<int>(&test::foo)(&t,2);
   }
   { /* test const with const object */
     const test t=test();
     sigc::mem_fun1<int>(&test::foo)(t,3);
     sigc::mem_fun1<int>(&test::foo)(&t,3);
   }
   { /* test non-const volatile */
     test t;
     sigc::mem_fun1<float>(&test::foo)(t,4);  // on reference
     sigc::mem_fun1<float>(&test::foo)(&t,4); // on pointer
   }
   { /* test const volatile */
     test t;
     sigc::mem_fun1<double>(&test::foo)(t,5);  // on reference
     sigc::mem_fun1<double>(&test::foo)(&t,5); // on pointer
   }
   { /* test const volatile with const object */
     const test t=test();
     sigc::mem_fun1<double>(&test::foo)(t,6);  // on reference
     sigc::mem_fun1<double>(&test::foo)(&t,6); // on pointer
   }
   { /* test multiple overloads */
     test t;
     sigc::mem_fun1<int>(&test::foo)(&t,7);
     sigc::mem_fun1<float>(&test::foo)(&t,7.0);
     sigc::mem_fun2(&test::foo)(&t,7,8);
   }
   { /* test bound */
     test t;
     sigc::mem_fun1<short>(t,&test::foo)(9);
     sigc::mem_fun1<short>(&t,&test::foo)(9);
     sigc::mem_fun1<int>(t,&test::foo)(9);
     sigc::mem_fun1<int>(&t,&test::foo)(9);
     sigc::mem_fun1<float>(t,&test::foo)(9.0);
     sigc::mem_fun1<float>(&t,&test::foo)(9.0);
     sigc::mem_fun2(t,&test::foo)(9,10);
     sigc::mem_fun2(&t,&test::foo)(9,10);
   }
}
