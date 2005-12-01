// -*- c++ -*-
/* Copyright 2005, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/functors/slot.h>
#include <iostream>
#include <string>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)
SIGC_USING_STD(string)


void Foo() { std::cout << "Foo" << std::endl; }
void Bar() { std::cout << "Bar" << std::endl; }


int main(void)
{
   //sigc::slot<void> nullSlot;
   
   sigc::slot<void> theSlot(sigc::ptr_fun(&Foo)); //Note that sigc::ptr_fun() creates a sig::pointer_functor0.
   theSlot(); //This should output "Foo"

   theSlot.disconnect(); // This seems to do nothing. (because rep::parent_ is 0).
   theSlot(); //This should cause no output.

   theSlot = sigc::ptr_fun(&Bar); // ... but this works.
   theSlot(); //This should output "Bar".

   // Expected output:
   // Foo
   // Bar

   return 0;
}
