// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/sigc++.h>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

namespace
{

template <class T>
void bar(T)
{ std::cout << "unknown" << std::endl; }

template <>
void bar<int>(int)
{ std::cout << "int" << std::endl; }

template <>
void bar<double>(double)
{ std::cout << "double" << std::endl; }

struct foo : public sigc::functor_base
{
  typedef double result_type;
  int operator()(int i=1);
  double operator()(const int&,int);
};

struct foo2 :public foo
{};

} // anonymous namespace

int main(int, char**)
{
  bar(sigc::deduce_result_type<foo2,long>::type());
  bar(sigc::deduce_result_type<foo2,int,int>::type());
#ifdef FAIL
  bar(sigc::deduce_result_type<foo2,int,int,int>::type());
#endif

  return 0;
}
