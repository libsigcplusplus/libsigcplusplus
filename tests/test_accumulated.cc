// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <iostream>

struct arithmetic_mean_accumulator
{
  typedef double result_type;
  template<typename T_iterator>
  double operator()(T_iterator first, T_iterator last) const
    {
      double value_ = 0;
      int n_ = 0;
      for (; first != last; ++first, ++n_)
        value_ += *first;
      return value_ / n_;
    }
};

int foo(int i)   { std::cout << "foo: " << 3*i+1 << std::endl; return 3*i+1;}
int bar(float i) { std::cout << "bar: " << 5*(int)i-3 << std::endl; return 5*(int)i-3;}

struct A : public sigc::trackable 
{
  int foo(int i) { std::cout << "A::foo: " << 20*i-14 << std::endl; return 20*i-14;}
};

int main()
{
   sigc::signal<int,int>::accumulated<arithmetic_mean_accumulator> sig;

   A a;
   sig.connect(sigc::ptr_fun1(&foo));
   sig.connect(sigc::mem_fun1(&a, &A::foo));
   sig.connect(sigc::ptr_fun1(&bar));

   std::cout << "Result (i=1): " << sig(1) << std::endl;
   std::cout << "Result (i=11): " << sig(11) << std::endl;
}
