// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/trackable.h>
#include <sigc++/functors/slot.h>
//#include <sigc++/adaptors/bind.h>
#include <sigc++/functors/mem_fun.h>

class my_class: public sigc::trackable
{
  public:
    int i;
    virtual void foo() { std::cout << i << std::endl; }
};

int main()
{
  sigc::slot<void> sl;
  {
    my_class t;
    t.i=10;
    sl = sigc::mem_fun0(&t, &my_class::foo);
//    sl = bind<1>(&my_class::foo, &t); // TODO: shouldn't this work?
    sl();
  }
  int i=0;

  sl();
}
