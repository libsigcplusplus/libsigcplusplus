// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <iostream>
#include <vector>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

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
      return (n_ ? value_ / n_ : -1); // empty slot list <=> n_==0
    }
};

template<class Ret>
struct vector_accumulator
{
  typedef std::vector<Ret> result_type;
  template<typename T_iterator>
  result_type operator()(T_iterator first, T_iterator last) const
    {
      result_type vec;
      for (; first != last; ++first)
        vec.push_back(*first);
      return vec;
    }
};

int foo(int i)    { std::cout << "foo: " << 3*i+1 << std::endl; return 3*i+1;}
int bar(double i) { std::cout << "bar: " << 5*int(i)-3 << std::endl; return 5*int(i)-3;}

struct A : public sigc::trackable 
{
  int foo(int i) { std::cout << "A::foo: " << 20*i-14 << std::endl; return 20*i-14;}
};

int main()
{
   sigc::signal<int,int>::accumulated<arithmetic_mean_accumulator> sig;
   sigc::signal<int,int>::accumulated<vector_accumulator<int> > sig_vec;

   std::cout << "Result (empty slot list): " << sig(0) << std::endl;
   std::cout << "Vector result (empty slot list): "
             << (sig_vec(0).empty() ? "empty" : "not empty") << std::endl;

   A a;
   sig.connect(sigc::ptr_fun1(&foo));
   sig.connect(sigc::mem_fun1(&a, &A::foo));
   sig.connect(sigc::ptr_fun1(&bar));
   
   sig_vec.connect(sigc::ptr_fun1(&foo));
   sig_vec.connect(sigc::mem_fun1(&a, &A::foo));
   sig_vec.connect(sigc::ptr_fun1(&bar));

   std::cout << "Mean accumulator: Result (i=1): " << sig(1) << std::endl;
   std::cout << "Mean accumulator: Plain Result (i=11): " << sig(11) << std::endl;
   
   std::vector<int> res1 = sig_vec(1);
   std::vector<int> res3 = sig_vec(3);
   
   std::cout << "Vector accumulator: Result (i=1): ";
   for (std::vector<int>::iterator i = res1.begin(); i != res1.end(); ++i)
     std::cout << *i << " ";
   std::cout << std::endl;
   
   std::cout << "Vector accumulator: Result (i=3): ";
   for (std::vector<int>::iterator i = res3.begin(); i != res3.end(); ++i)
     std::cout << *i << " ";
   std::cout << std::endl;
   
   return 0;
}
