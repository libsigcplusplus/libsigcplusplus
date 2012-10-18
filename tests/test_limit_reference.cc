#include "testutilities.h"
#include <sigc++/sigc++.h>
#include <sstream>
#include <cstdlib>

namespace
{
std::ostringstream result_stream;

class Base
  : virtual public sigc::trackable
{
};

class Base2
{
public:
  virtual ~Base2()
  {}
};

class Derived
  : virtual public Base,
    public Base2
{
public:
  void method()
  {
    result_stream << "method()";
  }
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  Derived* instance = new Derived();
  sigc::slot<void> handler = sigc::mem_fun(instance, &Derived::method);
  handler();
  util->check_result(result_stream, "method()");

  sigc::slot<void> param =
    sigc::bind(sigc::slot<void, Derived&>(), sigc::ref(*instance));
  param();
  util->check_result(result_stream, "");

  sigc::slot<Derived> ret =
    sigc::bind_return(sigc::slot<void>(), sigc::ref(*instance));
  ret();
  util->check_result(result_stream, "");

  delete instance;

  handler();
  param();
  ret();
  util->check_result(result_stream, "");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
