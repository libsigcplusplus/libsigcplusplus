// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/callof.h>

using namespace sigc;

template <class T>
void bar(T t)
{}

struct foo 
{
  int operator()(int i=1);
  double operator()(const int&,int);
};

struct foo2 :public foo
{};

main()
{
  bar(callof<foo2,long>::result_type());
  bar(callof<foo2,int,int>::result_type());
#ifdef FAIL
  bar(callof<foo2,int,int,int>::result_type());
#endif
}

