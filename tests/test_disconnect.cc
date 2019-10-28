/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/adaptors/compose.h>

// The Tru64 compiler seems to need this to avoid an unresolved symbol
// See bug #161503

namespace
{
std::ostringstream result_stream;

int
foo(int i)
{
  result_stream << "foo(" << i << ") ";
  return 1;
}

int
bar(double i)
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

void
good_bye_world()
{
  result_stream << "Good bye world!";
}

struct B : public sigc::trackable
{
  B()
  {
    sig.connect(sigc::mem_fun(*this, &B::destroy));
    sig.connect(sigc::mem_fun(*this, &B::boom));
    sig.connect(sigc::ptr_fun(&good_bye_world));
  }

  void destroy() // Calling destroy() during signal emission seems weird!
  { // However, if this works, anything will work!
    delete this; // valgrind reports a small memory leak, that's all.
  }

  void boom() { result_stream << "boom!"; }

  void emit() { sig.emit(); }

  sigc::signal<void()> sig;
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::signal<int(int)> sig;
  sigc::connection confoo;
  sigc::connection conbar;
  sigc::connection cona; // connection objects are safe to use beyond the life time of a signal.

  {
    A a;
    sig.connect(sigc::mem_fun(a, &A::foo));
    confoo = sig.connect(sigc::ptr_fun(&foo));
    conbar = sig.connect(sigc::ptr_fun(&bar));
    result_stream << "sig is connected to A::foo, foo, bar (size=" << sig.size() << "): ";
    sig(1);
    util->check_result(
      result_stream, "sig is connected to A::foo, foo, bar (size=3): A::foo(1) foo(1) bar(1) ");
  } // auto disconnection! iterators stay valid after disconnections.

  result_stream << "sig is connected to foo, bar (size=" << sig.size() << "): ";
  sig(2);
  util->check_result(result_stream, "sig is connected to foo, bar (size=2): foo(2) bar(2) ");

  A a; // iterators stay valid after further connections.
  cona = sig.connect(sigc::mem_fun(a, &A::foo));
  result_stream << "sig is connected to foo, A::foo, bar (size=" << sig.size() << "): ";
  sig(3);
  util->check_result(
    result_stream, "sig is connected to foo, A::foo, bar (size=3): foo(3) bar(3) A::foo(3) ");

  conbar.disconnect(); // manual disconnection
  result_stream << "sig is connected to foo, A::foo (size=" << sig.size() << "): ";
  sig(4);
  util->check_result(result_stream, "sig is connected to foo, A::foo (size=2): foo(4) A::foo(4) ");

  confoo.disconnect(); // manual disconnection
  result_stream << "sig is connected to A::foo (size=" << sig.size() << "): ";
  sig(5);
  util->check_result(result_stream, "sig is connected to A::foo (size=1): A::foo(5) ");

  cona.disconnect(); // manual disconnection
  result_stream << "sig is empty (size=" << sig.size() << "): ";
  sig(6);
  util->check_result(result_stream, "sig is empty (size=0): ");

  cona.disconnect(); // already disconnected -> legal with connection objects, however, nothing
                     // happens ...

  {
    A a2;
    sig.connect(sigc::compose(sigc::mem_fun(a2, &A::foo), &foo));
    result_stream << "sig is connected to compose(A::foo, foo) (size=" << sig.size() << "): ";
    sig(7);
    util->check_result(
      result_stream, "sig is connected to compose(A::foo, foo) (size=1): foo(7) A::foo(1) ");
  }
  result_stream << "sig is empty (size=" << sig.size() << "): ";
  sig(8);
  util->check_result(result_stream, "sig is empty (size=0): ");

  { // A slot# within a slot
    A a2;
    sigc::slot<int(int)> setter = sigc::mem_fun(a2, &A::foo);
    sig.connect(sigc::compose(setter, &foo));
    result_stream << "sig is connected to compose(slot1(A::foo), foo) (size=" << sig.size()
                  << "): ";
    sig(9);
    util->check_result(
      result_stream, "sig is connected to compose(slot1(A::foo), foo) (size=1): foo(9) A::foo(1) ");
  }
  result_stream << "sig is empty (size=" << sig.size() << "): ";
  sig(10);
  util->check_result(result_stream, "sig is empty (size=0): ");

  { // A slot within a slot
    A a2;
    sigc::slot<int(int)> setter = sigc::mem_fun(a2, &A::foo);
    sig.connect(sigc::compose(setter, &foo));
    result_stream << "sig is connected to compose(slot(A::foo), foo) (size=" << sig.size() << "): ";
    sig(11);
    util->check_result(
      result_stream, "sig is connected to compose(slot(A::foo), foo) (size=1): foo(11) A::foo(1) ");
  }
  result_stream << "sig is empty (size=" << sig.size() << "): ";
  sig(12);
  util->check_result(result_stream, "sig is empty (size=0): ");

  result_stream << "deleting a signal during emission... ";
  auto b = new B; // This is deleted by B::destroy().
  b->emit();
  util->check_result(result_stream, "deleting a signal during emission... Good bye world!");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
