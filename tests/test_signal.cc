// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;
using sigc::signal;

int foo(int i)   {cout << "foo(int "<<i<<")" << endl; return 1;}
int bar(float i) {cout << "bar(float "<<i<<")" << endl; return 1;}

struct A : public sigc::trackable
{
  int  foo(int i)       {cout << "A::foo(int "<<i<<")" << endl; return 1;}
  void bar(string& str) {cout << "A::foo(string '"<<str<<"')" << endl; str="foo was here";}
};

int main()
{
  signal<int,int> sig;
  {
    A a;
    sig.connect(ptr_fun1(&foo));
    sig.connect(mem_fun1(&a, &A::foo));
    sig.connect(ptr_fun1(&bar));
    sig(1);
    cout << sig.size() << endl;
  } // a dies => auto-disconnect
  cout << sig.size() << endl;
  sig(2);

  // test reference
  A a;
  string str("guest book");
  signal<void,string&> sigstr;
  sigstr.connect(mem_fun(&a, &A::bar));
  sigstr(str);
  cout << str << endl;
}
