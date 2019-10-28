/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/trackable.h>
#include <sigc++/functors/slot.h>

namespace
{
std::ostringstream result_stream;

class my_class : public sigc::trackable
{
public:
  my_class() : i(0) {}

  my_class(const my_class& src) = delete;
  my_class& operator=(const my_class& src) = delete;

  my_class(my_class&& src) noexcept : sigc::trackable(std::move(src)), i(std::move(src.i))
  {
    src.i = 0;
  }

  my_class& operator=(my_class&& src) noexcept
  {
    sigc::trackable::operator=(std::move(src));
    i = std::move(src.i);
    src.i = 0; // Make the moved-from object zeroed. Undefined behaviour would be acceptable too.
    return *this;
  }

  void foo() { result_stream << i; }

  int i;
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::slot<void()> sl;
  {
    my_class t;
    t.i = 10;
    sl = sigc::mem_fun(t, &my_class::foo);
    sl();
    util->check_result(result_stream, "10");

    // Create another trackable via a move:
    my_class t2(std::move(t));
    t2.i = 15;
    result_stream.clear();

    sl = sigc::mem_fun(t2, &my_class::foo);

    sl();
    util->check_result(result_stream, "15");
  }

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
