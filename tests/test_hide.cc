// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/hide.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct foo 
{
  int operator()(int j) 
    {cout << "foo(int "<<j<<")"<<endl; return 1+j;}
};

int main()
{
  cout << hide<1>(foo())(1,2) << endl;
  cout << hide<2>(foo())(1,2) << endl;
}
