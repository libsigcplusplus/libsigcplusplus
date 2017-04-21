/* Copyright 2005 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>
#include <cstring>

namespace
{
std::ostringstream result_stream;

void
Foo(sigc::trackable&)
{
  result_stream << "Foo(x)";
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  std::ostringstream pointer_stream;
  auto t = new sigc::trackable();
  pointer_stream << t;
  result_stream << "sigc::trackable instance at " << pointer_stream.str();
  util->check_result(result_stream, "sigc::trackable instance at " + pointer_stream.str());
  pointer_stream.str("");

  sigc::slot<void()> foo = sigc::bind(sigc::ptr_fun(Foo), std::ref(*t));
  foo();
  util->check_result(result_stream, "Foo(x)");

  // This invalidates foo.
  delete t;

  // Try to crash if the invalid slot parameter is used by libsigc++,
  // and get a debugger backtrace at the point that it happens.
  //
  // Comment this out to get a meaningful backtrace from valgrind.
  //
  // Try to pollute the memory previously occupied by the sigc::trackable
  // instance. The hope is that with a regular memory allocator (i.e. not
  // valgrind), we end up with buffer == (void *)t.
  void* buffer = malloc(sizeof(sigc::trackable));
  memset(buffer, 0xFF, sizeof(sigc::trackable));
  pointer_stream << buffer;
  result_stream << "         Polluted buffer at " << pointer_stream.str();
  util->check_result(result_stream, "         Polluted buffer at " + pointer_stream.str());
  pointer_stream.str("");

  // Now copy foo: up to libsigc++ version 2.0.11, the copy constructor fails
  // because the pointer value it dereferences does not point to a
  // sigc::trackable anymore, it now points to a polluted buffer.
  sigc::slot<void()> bar = foo;
  bar();
  util->check_result(result_stream, "");

  free(buffer);

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
