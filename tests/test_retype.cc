/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/retype.h>

namespace
{

TestUtilities* util = nullptr;
std::ostringstream result_stream;

struct foo : public sigc::trackable
{
  float test_int(int i)
  {
    result_stream << "foo::test_int(int " << i << ") ";
    return i * 1.5f;
  }

  float test_float(float f)
  {
    result_stream << "foo::test_float(float " << f << ") ";
    return f * 5;
  }
};

void
bar(short s)
{
  result_stream << "bar(short " << s << ")";
}

void
test_member_int()
{
  foo foo_;
  result_stream << sigc::retype(sigc::mem_fun(foo_, &foo::test_int))(1.234f);
  util->check_result(result_stream, "foo::test_int(int 1) 1.5");
}

void
test_member_float()
{
  foo foo_;
  result_stream << sigc::retype(sigc::mem_fun(foo_, &foo::test_float))(5);
  util->check_result(result_stream, "foo::test_float(float 5) 25");
}

void
test_ptr_fun()
{
  sigc::retype(sigc::ptr_fun(&bar))(6.789f);
  util->check_result(result_stream, "bar(short 6)");
}

void
test_member_int_with_slot()
{
  foo foo_;
  sigc::slot<float(float)> s1 = sigc::retype(sigc::mem_fun(foo_, &foo::test_int));
  result_stream << s1(1.234f);
  util->check_result(result_stream, "foo::test_int(int 1) 1.5");
}

void
test_member_float_with_slot()
{
  foo foo_;
  sigc::slot<float(int)> s2 = sigc::retype(sigc::mem_fun(foo_, &foo::test_float));
  result_stream << s2(5);
  util->check_result(result_stream, "foo::test_float(float 5) 25");
}

void
test_ptr_fun_with_slot()
{
  sigc::slot<void(double)> s3 = sigc::retype(sigc::ptr_fun(&bar));
  s3(6.789);
  util->check_result(result_stream, "bar(short 6)");
}

void
test_retype_slot()
{
  foo foo_;
  sigc::slot<float(float)> s1 = sigc::retype(sigc::mem_fun(foo_, &foo::test_int));
  sigc::slot<float(int)> s2 = sigc::retype(s1);
  result_stream << s2(5);
  util->check_result(result_stream, "foo::test_int(int 5) 7.5");
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  test_member_int();
  test_member_float();
  test_ptr_fun();

  test_member_int_with_slot();
  test_member_float_with_slot();
  test_ptr_fun_with_slot();

  test_retype_slot();

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
