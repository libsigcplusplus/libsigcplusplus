// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/connection.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;
using sigc::signal;
using sigc::connection;

int foo(int i) { cout << "foo: " << i << endl; return 1;}
int bar(float i) { cout << "bar: " << i << endl; return 1;}

struct A : public sigc::trackable 
{
  int foo(int i) { cout << "A::foo: " << i << endl; return 1;}
};

void good_bye_world() { cout << "Good bye world!" << endl; }

struct B : public sigc::trackable
{
  B()
    {
      sig.connect(mem_fun(this, &B::destroy));
      sig.connect(mem_fun(this, &B::boom));
      sig.connect(ptr_fun(&good_bye_world));
    }

  void destroy()     // Calling destroy() during signal emission seems weird!
    { delete this; } // However, if this works, anything will work!

  void boom()
    { cout << "boom!" << endl; }

  void emit()
    { sig.emit(); }

  signal<void> sig;
};

int main()
{
   signal<int,int> sig;
   signal<int,int>::iterator confoo, conbar;
   connection cona;  // connection objects are safe to use beyond the life time of a signal.

   {
     A a;
     sig.connect(mem_fun1(&a, &A::foo));
     confoo = sig.connect(ptr_fun1(&foo));
     conbar = sig.connect(ptr_fun1(&bar));
     cout << "sig is connected to A::foo, foo, bar (size=" << sig.size() << "): " << endl;
     sig(1);
   }                     // auto disconnection! iterators stay valid after disconnections.

   cout << "sig is connected to foo, bar (size=" << sig.size() << "): " << endl;
   sig(2);

   A a;                  // iterators stay valid after further connections.
   cona = sig.slots().insert(conbar, mem_fun1(&a, &A::foo));
   cout << "sig is connected to foo, A::foo, bar (size=" << sig.size() << "): " << endl;
   sig(3);

   conbar->disconnect(); // manual disconnection
   cout << "sig is connected to foo, A::foo (size=" << sig.size() << "): " << endl;
   sig(4);

   confoo->disconnect(); // manual disconnection
   cout << "sig is connected to A::foo (size=" << sig.size() << "): " << endl;
   sig(5);

   cona.disconnect();    // manual disconnection
   cout << "sig is empty (size=" << sig.size() << "): " << endl;
   sig(6);

   cona.disconnect();    // already disconnected -> legal with connection objects, however, nothing happens ...

   cout << "deleting a signal during emission..." << endl;
   B* b = new B;
   b->emit();
}
