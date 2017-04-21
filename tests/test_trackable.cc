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
  int i = 0;

  void foo() { result_stream << i; }
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
  }

  sl();
  util->check_result(result_stream, "");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
