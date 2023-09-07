/* Copyright 2023, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <type_traits>
#include <sigc++/connection.h>
#include <sigc++/scoped_connection.h>
#include <sigc++/signal.h>
#include <sigc++/trackable.h>

// Test the expected special members and conversions, esp. NOT copyable BUT movable.
static_assert( std::is_nothrow_default_constructible_v<sigc::scoped_connection>);
static_assert(!std::is_copy_constructible_v           <sigc::scoped_connection>);
static_assert(!std::is_copy_assignable_v              <sigc::scoped_connection>);
static_assert( std::is_nothrow_move_constructible_v   <sigc::scoped_connection>);
static_assert( std::is_move_assignable_v              <sigc::scoped_connection>);
static_assert( std::is_nothrow_swappable_v            <sigc::scoped_connection>);
// TODO: C++20: Test the stronger std::is_nothrow_convertible_v; it should pass.
static_assert( std::is_convertible_v<sigc::connection, sigc::scoped_connection>);
static_assert(!std::is_convertible_v<sigc::scoped_connection, sigc::connection>);
static_assert( std::is_assignable_v <sigc::scoped_connection, sigc::connection>);
static_assert(!std::is_assignable_v <sigc::connection, sigc::scoped_connection>);

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
  sigc::connection cona;

  {
    A a;
    sig.connect(sigc::mem_fun(a, &A::foo));
    conbar = sig.connect(&bar);
    confoo = sig.connect_first(&foo);
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(1);
    util->check_result(
      result_stream, "sig is connected to (size=3): foo(1) A::foo(1) bar(1) ");
  }
  // normal connections are still connected. mem_fun disconnected via trackable.
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(2);
  util->check_result(result_stream, "sig is connected to (size=2): foo(2) bar(2) ");

  {
    A a;
    sig.connect(sigc::mem_fun(a, &A::foo));
    sigc::scoped_connection sconfoo = sig.connect(&foo);
    sigc::scoped_connection sconbar = sig.connect_first(&bar);
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(3);
    util->check_result(
      result_stream, "sig is connected to (size=5): bar(3) foo(3) bar(3) A::foo(3) foo(3) ");
  }
  // scoped connections are now disconnected.
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(4);
  util->check_result(result_stream, "sig is connected to (size=2): foo(4) bar(4) ");

  // copying connection to a scoped connection disconnects when latter destroyed
  // copy-constructor:
  {
    sigc::scoped_connection sconfoo = confoo;
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(5);
    util->check_result(
      result_stream, "sig is connected to (size=2): foo(5) bar(5) ");
  }
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(6);
  util->check_result(
    result_stream, "sig is connected to (size=1): bar(6) ");
  // copy-assignment:
  confoo = sig.connect(&foo);
  {
    sigc::scoped_connection sconfoo = sig.connect(&bar);
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(7);
    util->check_result(
      result_stream, "sig is connected to (size=3): bar(7) foo(7) bar(7) ");
    // copy-assignment disconnects currently held connection & replaces with new
    sconfoo = confoo;
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(8);
    util->check_result(
      result_stream, "sig is connected to (size=2): bar(8) foo(8) ");
  }
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(9);
  util->check_result(
    result_stream, "sig is connected to (size=1): bar(9) ");

  // moving scoped_connection transfers ownership/disconnection to destination
  // move-constructor:
  {
    auto src = std::make_unique<sigc::scoped_connection>(sig.connect(&foo));
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(10);
    util->check_result(
      result_stream, "sig is connected to (size=2): bar(10) foo(10) ");

    sigc::scoped_connection dst = std::move(*src);
    src.reset(); // This will NOT disconnect from foo()
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(11);
    util->check_result(
      result_stream, "sig is connected to (size=2): bar(11) foo(11) ");
  }

  // move-assignment:
  {
    auto src = std::make_unique<sigc::scoped_connection>(sig.connect(&foo));
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(12);
    util->check_result(
      result_stream, "sig is connected to (size=2): bar(12) foo(12) ");

    sigc::scoped_connection dst;
    dst = std::move(*src);
    src.reset(); // This will NOT disconnect from foo()
    result_stream << "sig is connected to (size=" << sig.size() << "): ";
    sig(13);
    util->check_result(
      result_stream, "sig is connected to (size=2): bar(13) foo(13) ");
  }

  // dst from above is now destroyed
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(14);
  util->check_result(
    result_stream, "sig is connected to (size=1): bar(14) ");

  // swap
  sigc::scoped_connection sconfoo = sig.connect(&foo);
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(15);
  util->check_result(
    result_stream, "sig is connected to (size=2): bar(15) foo(15) ");
  sigc::scoped_connection sconbar = sig.connect(&bar);
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(16);
  util->check_result(
    result_stream, "sig is connected to (size=3): bar(16) foo(16) bar(16) ");
  swap(sconbar, sconfoo);
  // disconnect sconbar, which was swapped to refer to &foo
  sconbar.disconnect();
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(17);
  util->check_result(
    result_stream, "sig is connected to (size=2): bar(17) bar(17) ");

  // manual disconnection
  sconfoo.disconnect(); // was swapped to refer to 2nd &bar
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(18);
  util->check_result(
    result_stream, "sig is connected to (size=1): bar(18) ");

  // release
  sconfoo = sig.connect(&foo);
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(19);
  util->check_result(
    result_stream, "sig is connected to (size=2): bar(19) foo(19) ");
  sigc::connection rconfoo = sconfoo.release();
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(20);
  util->check_result(
    result_stream, "sig is connected to (size=2): bar(20) foo(20) ");
  rconfoo.disconnect();
  result_stream << "sig is connected to (size=" << sig.size() << "): ";
  sig(21);
  util->check_result(
    result_stream, "sig is connected to (size=1): bar(21) ");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
