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


struct A {
   void foo();
};


int main()
{
   cout << "sizes of public classes:" << endl;

   cout << "  trackable:              " << sizeof(sigc::trackable) << endl;
   cout << "  slot<void>:             " << sizeof(slot<void>) << endl;
   cout << "  signal<void>:           " << sizeof(signal<void>) << endl;
   cout << "  signal<void>::iterator: " << sizeof(signal<void>::iterator) << endl;


   cout << endl << "sizes of internal classes:" << endl;

   cout << "  trackable_dependency:   " << sizeof(sigc::internal::trackable_dependency) << endl;
   cout << "  trackable_dep_list:     " << sizeof(sigc::internal::trackable_dep_list) << endl;
   cout << "  slot_rep:               " << sizeof(internal::slot_rep) << endl;
   cout << "  typed_slot_rep<mem_functor0<void,A> >: "
        << sizeof(internal::typed_slot_rep<mem_functor0<void,A> >) << endl;
   cout << "  signal_impl:            " << sizeof(sigc::internal::signal_impl) << endl;
}
