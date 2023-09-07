/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <memory>

namespace
{

TestUtilities* util = nullptr;
std::ostringstream result_stream;

int
foo(int i)
{
  result_stream << "foo(int " << i << ") ";
  return 1;
}

struct A : public sigc::trackable
{
  int foo(int i)
  {
    result_stream << "A::foo(int " << i << ") ";
    return 1;
  }

  void bar(std::string& str)
  {
    result_stream << "A::foo(string '" << str << "') ";
    str = "foo was here";
  }
};

void
test_empty_signal()
{
  // signal
  sigc::signal<int(int)> sig;

  // emit empty signal
  sig(0);
  util->check_result(result_stream, "");
}

void
test_simple()
{
  sigc::signal<int(int)> sig;
  sig.connect([](int i) { return foo(i); });

  sig(1);
  util->check_result(result_stream, "foo(int 1) ");
}

int
bar(float i)
{
  result_stream << "bar(float " << i << ") ";
  return 1;
}

template<typename T_signal>
void
test_auto_disconnection()
{
  // signal
  T_signal sig;

  // connect some slots before emitting & test auto-disconnection
  {
    A a;
    sig.connect(sigc::ptr_fun(&foo));
    sig.connect_first(sigc::mem_fun(a, &A::foo));
    sig.connect_first(sigc::ptr_fun(&bar));
    sig(1);
    result_stream << sig.size();
    util->check_result(result_stream, "bar(float 1) A::foo(int 1) foo(int 1) 3");

  } // a dies => auto-disconnect

  sig(2);
  result_stream << sig.size();
  util->check_result(result_stream, "bar(float 2) foo(int 2) 2");
}

void
test_reference()
{
  // test reference
  A a;
  std::string str("guest book");
  sigc::signal<void(std::string&)> sigstr;
  sigstr.connect(sigc::mem_fun(a, &A::bar));
  sigstr(str);
  result_stream << str;
  util->check_result(result_stream, "A::foo(string 'guest book') foo was here");
}

void
test_make_slot()
{
  // test make_slot()
  sigc::signal<int(int)> sig;
  sig.connect(sigc::ptr_fun(&foo));
  sig.connect_first([](float i) { return bar(i); });
  sig.connect(sigc::ptr_fun(&foo));
  sigc::signal<int(int)> sig2;
  sig2.connect(sig.make_slot());
  sig2(3);
  util->check_result(result_stream, "bar(float 3) foo(int 3) foo(int 3) ");

  // Delete a trackable_signal that has been connected to sig2.
  sig2.clear();
  sig2.connect(sigc::ptr_fun(&bar));
  auto sig3 = std::make_unique<sigc::trackable_signal<int(int)>>();
  sig3->connect(sigc::ptr_fun(&foo));
  sig2.connect(sig3->make_slot());
  sig2(2);
  sig3.reset();
  sig2(42);
  util->check_result(result_stream, "bar(float 2) foo(int 2) bar(float 42) ");
}

void
test_clear_called_in_signal_handler()
{
  sigc::signal<void()> sig;
  sig.connect([]() { result_stream << ", slot 1, "; });
  sig.connect(
    [&sig]()
    {
      sig.clear();
      result_stream << "slot 2, ";
    });
  sig.connect([]() { result_stream << "slot 3, "; });
  result_stream << sig.size();
  sig.emit();
  result_stream << sig.size();
  sig.emit();
  util->check_result(result_stream, "3, slot 1, slot 2, 0");
}

void
test_clear_called_outside_signal_handler()
{
  sigc::signal<void()> sig;
  sig.connect([]() { result_stream << ", slot 1, "; });
  sig.connect([]() { result_stream << "slot 2, "; });
  sig.connect([]() { result_stream << "slot 3, "; });
  result_stream << sig.size();
  sig.emit();
  sig.clear();
  result_stream << sig.size();
  sig.emit();
  util->check_result(result_stream, "3, slot 1, slot 2, slot 3, 0");
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_empty_signal();
  test_simple();
  test_auto_disconnection<sigc::signal<int(int)>>();
  test_auto_disconnection<sigc::trackable_signal<int(int)>>();
  test_reference();
  test_make_slot();
  test_clear_called_in_signal_handler();
  test_clear_called_outside_signal_handler();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
