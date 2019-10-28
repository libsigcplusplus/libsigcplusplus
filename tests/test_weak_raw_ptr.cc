/* Copyright 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/weak_raw_ptr.h>
#include <cassert>

namespace
{

TestUtilities* util = nullptr;
std::ostringstream result_stream;

class A : public sigc::trackable
{
public:
  void something() { result_stream << "method called"; }
};

} // end anonymous namespace

void
test_weak_ptr_becomes_null()
{
  const auto a = new A();
  sigc::internal::weak_raw_ptr<A> raw_ptr(a);
  assert(raw_ptr);

  // Call something on A, via the weak_raw_ptr<>,
  // just to make sure that it doesn't get optimised away:
  raw_ptr->something();
  util->check_result(result_stream, "method called");

  delete a;

  // Deleting the A should have made the weak_raw_ptr<A> become invalid.
  assert(!raw_ptr);
}

void
test_weak_ptr_disconnects_self()
{
  const auto a = new A();
  {
    sigc::internal::weak_raw_ptr<A> raw_ptr(a);

    // Call something on A, via the weak_raw_ptr<>,
    // just to make sure that it doesn't get optimised away:
    raw_ptr->something();
    util->check_result(result_stream, "method called");
  }

  // If the weak_raw_ptr has not asked A to stop notifying it,
  // then we would expect some undefined behaviour here,
  // when a tries to notify the now-destroyed weak_raw_ptr.
  delete a;
}

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_weak_ptr_becomes_null();
  test_weak_ptr_disconnects_self();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
