// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/compose.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct set 
{
  void operator()(int i) 
    {cout << "set(int "<<i<<")"<<endl; }
  float operator()(float i) 
    {cout << "set(float "<<i<<")"<<endl; return i*5;}
};

struct get
{
  int operator()(int i) 
    { cout << "get("<<i<<")"<<endl; return i*2; }
  float operator()(int i,int j) 
    { cout << "get("<<i<<","<<j<<")"<<endl; return float(i)/float(j); }
};

int main()
{
  compose(set(),get())(1);
  cout << compose(set(),get())(1,2) << endl;
}
