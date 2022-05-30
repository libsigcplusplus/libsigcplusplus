/* Copyright 2005 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>

namespace
{
std::ostringstream result_stream;

class Base : virtual public sigc::trackable
{
public:
  Base() {}

  Base(const Base& src) = default;
  Base& operator=(const Base& src) = default;
  Base(Base&& src) = delete;
  Base& operator=(Base&& src) = delete;
};

class Base2
{
public:
  virtual ~Base2() {}
};

class Derived
: virtual public Base
, public Base2
{
public:
  void method() { result_stream << "method()"; }
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  auto instance = new Derived();
  sigc::slot<void()> handler = sigc::mem_fun(*instance, &Derived::method);
  handler();
  util->check_result(result_stream, "method()");

  sigc::slot<void()> param = sigc::bind(sigc::slot<void(Derived&)>(), std::ref(*instance));
  param();
  util->check_result(result_stream, "");

  sigc::slot<Derived()> ret = sigc::bind_return(sigc::slot<void()>(), std::ref(*instance));
  ret();
  util->check_result(result_stream, "");

  delete instance;

  handler();
  param();
  ret();
  util->check_result(result_stream, "");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
