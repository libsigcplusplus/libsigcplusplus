// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#define SIGC_FUNCTORS_HAVE_RESULT_TYPE // assume existance of T_functor::result_type for unknown functor types
#include <sigc++/adaptors/compose.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct set 
{
  // explicitly specify the return type of set's operator()(int) overload
  // (cannot be auto-detected):
  typedef int result_type;

  int operator()(int i) 
    {cout << "set(int "<<i<<")"<<endl; return i*i;}
  float operator()(float i) 
    {cout << "set(float "<<i<<")"<<endl; return i*5;}
};

struct get
{
  bool operator()()
    { cout << "get()"<<endl; return true; }
  int operator()(int i) 
    { cout << "get("<<i<<")"<<endl; return i*2; }
  float operator()(int i,int j) 
    { cout << "get("<<i<<","<<j<<")"<<endl; return float(i)/float(j); }
};


int main()
{
  cout << compose(set(),get())() << endl;
  cout << compose(set(),get())(1) << endl;
  cout << compose(set(),get())(1,2) << endl;
}
