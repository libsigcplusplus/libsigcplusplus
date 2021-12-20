#include "testutilities.h"
#include <iostream>
#include <sigc++/signal.h>

struct MoveableStruct
{
};

namespace
{
TestUtilities* util = nullptr;
std::ostringstream result_stream;

struct foo
{
  void operator()(MoveableStruct&& /* x */) { result_stream << "foo(MoveableStruct&&)"; }
};

struct A
{
  void foo(MoveableStruct &&) { result_stream << "A::foo(MoveableStruct&&)"; }
};


} // end anonymous namespace

void
test_signal()
{
  sigc::signal<void(MoveableStruct &&)> signal;
  foo f;
  signal.connect(f);
  MoveableStruct x;
  signal(std::move(x));
  util->check_result(result_stream, "foo(MoveableStruct&&)");
}

void
test_slot()
{
  sigc::slot<void(MoveableStruct &&)> slot;
  foo f;
  slot = f;
  MoveableStruct x;
  slot(std::move(x));
  util->check_result(result_stream, "foo(MoveableStruct&&)");
}

void
test_mem_fun()
{
  sigc::slot<void(MoveableStruct &&)> slot;
  A a;
  slot = sigc::mem_fun(a, &A::foo);
  MoveableStruct x;
  slot(std::move(x));
  util->check_result(result_stream, "A::foo(MoveableStruct&&)");
}

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();
  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_signal();
  test_slot();
  test_mem_fun();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
} // end main()
