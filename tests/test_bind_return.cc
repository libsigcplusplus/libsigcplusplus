// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/bind_return.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct foo 
{
  void operator()(int i) 
    {cout << "foo(int "<<i<<")"<<endl; }
  float operator()(float i) 
    {cout << "foo(float "<<i<<")"<<endl; return i*5;}
};

int main()
{
  cout << bind_return(foo(),-12345)(5) << endl;
}
