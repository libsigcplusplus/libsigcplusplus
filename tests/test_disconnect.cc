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

//The Tru64 compiler seems to need this to avoid an unresolved symbol
//See bug #161503
#include <new>
SIGC_USING_STD(new)

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

int foo(int i)    { std::cout << "foo: " << i << std::endl; return 1;}
int bar(double i) { std::cout << "bar: " << i << std::endl; return 1;}

struct A : public sigc::trackable 
{
  int foo(int i) { std::cout << "A::foo: " << i << std::endl; return 1;}
};

void good_bye_world() { std::cout << "Good bye world!" << std::endl; }

struct B : public sigc::trackable
{
  B()
    {
      sig.connect(sigc::mem_fun(this, &B::destroy));
      sig.connect(sigc::mem_fun(this, &B::boom));
      sig.connect(sigc::ptr_fun(&good_bye_world));
    }

  void destroy()     // Calling destroy() during signal emission seems weird!
    { delete this; } // However, if this works, anything will work!

  void boom()
    { std::cout << "boom!" << std::endl; }

  void emit()
    { sig.emit(); }

  sigc::signal<void> sig;
};

int main()
{
  sigc::signal<int,int> sig;
  sigc::signal<int,int>::iterator confoo, conbar;
  sigc::connection cona;  // connection objects are safe to use beyond the life time of a signal.

  {
    A a;
    sig.connect(sigc::mem_fun1(&a, &A::foo));
    confoo = sig.connect(sigc::ptr_fun1(&foo));
    conbar = sig.connect(sigc::ptr_fun1(&bar));
    std::cout << "sig is connected to A::foo, foo, bar (size=" << sig.size() << "): " << std::endl;
    sig(1);
  }                     // auto disconnection! iterators stay valid after disconnections.

  std::cout << "sig is connected to foo, bar (size=" << sig.size() << "): " << std::endl;
  sig(2);

  A a;                  // iterators stay valid after further connections.
  cona = sig.slots().insert(conbar, sigc::mem_fun1(&a, &A::foo));
  std::cout << "sig is connected to foo, A::foo, bar (size=" << sig.size() << "): " << std::endl;
  sig(3);

  conbar->disconnect(); // manual disconnection
  std::cout << "sig is connected to foo, A::foo (size=" << sig.size() << "): " << std::endl;
  sig(4);

  confoo->disconnect(); // manual disconnection
  std::cout << "sig is connected to A::foo (size=" << sig.size() << "): " << std::endl;
  sig(5);

  cona.disconnect();    // manual disconnection
  std::cout << "sig is empty (size=" << sig.size() << "): " << std::endl;
  sig(6);

  cona.disconnect();    // already disconnected -> legal with connection objects, however, nothing happens ...

  std::cout << "deleting a signal during emission..." << std::endl;
  B* b = new B;
  b->emit();
}
