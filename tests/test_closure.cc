// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/functors/closure.h>

using namespace std;
using namespace sigc::functor;

class foo
{
  public:
  void operator()(int i) {cout << "foo(int "<<i<<")" << endl;}
  void operator()(int,int) {cout << "foo(int,int)" << endl;}
};

int main()
{
  closure<void,int> c=foo();
  c(1);
  c=foo();
  c(2);
}
