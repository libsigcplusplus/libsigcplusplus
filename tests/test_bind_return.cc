// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/bind_return.h>
#include <sigc++/functors/slot.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;
using sigc::trackable;

struct foo 
{
  void operator()(int i) 
    {cout << "foo(int "<<i<<")"<<endl; }
  float operator()(float i) 
    {cout << "foo(float "<<i<<")"<<endl; return i*5;}
};

struct bar : public trackable
{
  bar(int i=0) : i_(i) {}
  operator int() {return i_;}
  int i_;
};

int main()
{
  cout << bind_return(foo(),-12345)(5) << endl;

  // test references
  string str("guest book");
  bind_return<string&>(foo(),str)(6) = "main";
  cout << str << endl;

  slot<bar,int> c; // bar, not bar&: slots cannot return references
  {
    bar choco(-1);
    c = bind_return<bar&>(foo(),choco);
    cout << c(7) << endl;
  } // auto-disconnect
  cout << c(8) << endl;
}
