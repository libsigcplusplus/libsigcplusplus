// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/trackable.h>
#include <sigc++/functors/slot.h>
#include <sigc++/adaptors/bind.h>
#include <sigc++/functors/mem_fun.h>

using namespace std;
using namespace sigc;
using namespace sigc::functor;

class my_class: public trackable
{
  public:
    int i;
    virtual void foo() { cout << i << endl; }
};

int main()
{
  slot<void> cl;
  {
    my_class t;
    t.i=10;
    cl = mem_fun0(&t, &my_class::foo);
//    cl = bind<1>(&my_class::foo, &t);
    cl();
  }
  int i=0;

  cl();
}
