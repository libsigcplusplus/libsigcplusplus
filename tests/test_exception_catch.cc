/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/exception_catch.h>

namespace
{
std::ostringstream result_stream;

struct f
{
  int operator()(int i)
  {
    result_stream << "f(int " << i << ") ";
    throw std::range_error("out of range ");
  }
};

struct g
{
  int operator()()
  {
    result_stream << "g() ";
    throw std::range_error("out of range ");
  }
};

struct g_void
{
  void operator()()
  {
    result_stream << "g_void() ";
    throw std::range_error("out of range ");
  }
};

struct my_catch
{
  int operator()()
  {
    try
    {
      throw;
    }
    catch (const std::range_error& e) // catch what types we know
    {
      result_stream << "caught " << e.what();
    }
    return 1;
    // all else continues out.
  }
};

struct my_catch_void
{
  void operator()()
  {
    try
    {
      throw;
    }
    catch (const std::range_error& e) // catch what types we know
    {
      result_stream << "caught " << e.what();
    }

    // all else continues out.
  }
};

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  result_stream << sigc::exception_catch(f(), my_catch())(2);
  util->check_result(result_stream, "f(int 2) caught out of range 1");

  result_stream << sigc::exception_catch(g(), my_catch())();
  util->check_result(result_stream, "g() caught out of range 1");

  sigc::exception_catch(g_void(), my_catch_void())(); // void test
  util->check_result(result_stream, "g_void() caught out of range ");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
