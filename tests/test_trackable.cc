// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/trackable.h>
#include <sigc++/functors/slot.h>
#include <sigc++/functors/mem_fun.h>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

class my_class: public sigc::trackable
{
public:
  int i;
  void foo() { std::cout << i << std::endl; }
};

int main()
{
  sigc::slot<void> sl;
  {
    my_class t;
    t.i = 10;
    sl = sigc::mem_fun0(&t, &my_class::foo);
    sl();
  }

  sl();
}
