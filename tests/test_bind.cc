// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/bind.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct foo 
{
  int operator()(int i,int j) 
    {cout << "foo(int "<<i<<",int "<<j<<")"<<endl; return i+j;}
};

int bar(int i,int j) 
  {cout << "bar(int "<<i<<",int "<<j<<")"<<endl; return i+j;}


int main()
{
  // replacing bind1st, bind2nd
  cout << bind<1>(foo(),-12345)(5) << endl;
  cout << bind<2>(foo(),-12345)(5) << endl;

  // multiple
  bind<1>(foo(),3,4)();

  // bind from end
  bind<0>(foo(),3)(1);

  // used together
  bind<1>(bind<1>(foo(),1),2)();

  // using a function
  bind<1>(&bar,1,2)();
}
