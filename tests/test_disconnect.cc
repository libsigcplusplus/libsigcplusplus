// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/connection.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <sstream>
#include <cstdlib>

//The Tru64 compiler seems to need this to avoid an unresolved symbol
//See bug #161503
#include <new>
SIGC_USING_STD(new)

namespace
{
std::ostringstream result_stream;

int foo(int i)
{
  result_stream << "foo(" << i << ") ";
  return 1;
}

int bar(double i)
{
  result_stream << "bar(" << i << ") ";
  return 1;
}

struct A : public sigc::trackable
{
  int foo(int i)
  {
    result_stream << "A::foo(" << i << ") ";
    return 1;
  }
};

void good_bye_world()
{
  result_stream << "Good bye world!";
}

struct B : public sigc::trackable
{
  B()
  {
    sig.connect(sigc::mem_fun(this, &B::destroy));
    sig.connect(sigc::mem_fun(this, &B::boom));
    sig.connect(sigc::ptr_fun(&good_bye_world));
  }

  void destroy()   // Calling destroy() during signal emission seems weird!
  {                // However, if this works, anything will work!
    delete this;
  }

  void boom()
  {
    result_stream << "boom!";
  }

  void emit()
  {
    sig.emit();
  }

  sigc::signal<void> sig;
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::signal<int, int> sig;
  sigc::signal<int, int>::iterator confoo;
  sigc::signal<int, int>::iterator conbar;
  sigc::connection cona;  // connection objects are safe to use beyond the life time of a signal.

  {
    A a;
    sig.connect(sigc::mem_fun1(&a, &A::foo));
    confoo = sig.connect(sigc::ptr_fun1(&foo));
    conbar = sig.connect(sigc::ptr_fun1(&bar));
    result_stream << "sig is connected to A::foo, foo, bar (size=" << sig.size() << "): ";
    sig(1);
    util->check_result(result_stream,
      "sig is connected to A::foo, foo, bar (size=3): A::foo(1) foo(1) bar(1) ");
  }                     // auto disconnection! iterators stay valid after disconnections.

  result_stream << "sig is connected to foo, bar (size=" << sig.size() << "): ";
  sig(2);
  util->check_result(result_stream, "sig is connected to foo, bar (size=2): foo(2) bar(2) ");

  A a;                  // iterators stay valid after further connections.
  cona = sig.slots().insert(conbar, sigc::mem_fun1(&a, &A::foo));
  result_stream << "sig is connected to foo, A::foo, bar (size=" << sig.size() << "): ";
  sig(3);
  util->check_result(result_stream,
    "sig is connected to foo, A::foo, bar (size=3): foo(3) A::foo(3) bar(3) ");

  conbar->disconnect(); // manual disconnection
  result_stream << "sig is connected to foo, A::foo (size=" << sig.size() << "): ";
  sig(4);
  util->check_result(result_stream, "sig is connected to foo, A::foo (size=2): foo(4) A::foo(4) ");

  confoo->disconnect(); // manual disconnection
  result_stream << "sig is connected to A::foo (size=" << sig.size() << "): ";
  sig(5);
  util->check_result(result_stream, "sig is connected to A::foo (size=1): A::foo(5) ");

  cona.disconnect();    // manual disconnection
  result_stream << "sig is empty (size=" << sig.size() << "): ";
  sig(6);
  util->check_result(result_stream, "sig is empty (size=0): ");

  cona.disconnect();    // already disconnected -> legal with connection objects, however, nothing happens ...

  result_stream << "deleting a signal during emission... ";
  B* b = new B;
  b->emit();
  util->check_result(result_stream, "deleting a signal during emission... Good bye world!");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
