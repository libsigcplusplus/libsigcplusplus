// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/retype_return.h>
#include <sigc++/functors/slot.h>
#include <iostream>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

struct foo : public sigc::functor_base
{
  typedef float result_type;
  float operator()(int i) 
  {
    std::cout << "foo(int " << i << ")" << std::endl;
    return i;
  }

  float operator()(float i) 
  {
    std::cout << "foo(float " << i << ")" << std::endl;
    return i * 5;
  }
};

struct bar : public sigc::trackable, public sigc::functor_base
{
  typedef int result_type;
  int operator()(int i)
  {
    std::cout << "bar(int " << i << ")" << std::endl;
    return i;
  }
};

int main()
{
  // retype_return<int>
  std::cout << sigc::retype_return<int>(foo())(1.234f) << std::endl;

  // retype_return<void> / hide_return
  sigc::slot<void, int> sl;
  sl = sigc::retype_return<void>(bar());
  sl(5);
  sl = sigc::hide_return(bar());
  sl(6);
}
