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

namespace
{
std::ostringstream result_stream;

sigc::connection connection;

class HandlerClass : public sigc::trackable
{
public:
  void handler()
  {
    result_stream << "handler called";
    connection.disconnect();
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  HandlerClass instance;

  sigc::signal<void> signal_test;
  connection = signal_test.connect(sigc::mem_fun(instance, &HandlerClass::handler));
  result_stream << "Number of signal handlers before signal emission: " << signal_test.size();
  util->check_result(result_stream, "Number of signal handlers before signal emission: 1");
  signal_test.emit();
  util->check_result(result_stream, "handler called");
  result_stream << "Number of signal handlers after signal emission: " << signal_test.size();
  util->check_result(result_stream, "Number of signal handlers after signal emission: 0");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
