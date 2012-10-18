// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/adaptors/bind.h>
#include <sigc++/functors/slot.h>
#include <sstream>
#include <string>
#include <cstdlib>

namespace
{
std::ostringstream result_stream;

struct foo : public sigc::functor_base
{
  // choose a type that can hold all return values
  typedef int result_type;

  int operator()(int i)
  {
    result_stream << "foo(int " << i << ") ";
    return i > 0;
  }

  int operator()(int i, int j)
  {
    result_stream << "foo(int " << i << ", int "<< j << ") ";
    return i + j;
  }

  int operator()(int i, int j, int k)
  {
    result_stream << "foo(int " << i << ", int " << j << ", int " << k << ") ";
    return 0;
  }
};

struct foo_void : public sigc::functor_base
{
  typedef void result_type;

  void operator()(int i)
  {
    result_stream << "foo_void(int " << i << ")";
  }
};

int bar(int i, int j)
{
  result_stream << "bar(int " << i << ", int " << j << ") ";
  return i + j;
}

bool simple(bool test)
{
  result_stream << "simple(bool " << test << ") ";
  return test;
}

void egon(std::string& str)
{
  result_stream << "egon(string '" << str << "')";
  str = "egon was here";
}


struct book : public sigc::trackable
{
  book(const std::string& name) : name_(name) {}
  std::string& get_name()  { return name_; }
  operator std::string& () { return get_name(); }

private:
  std::string name_;

  //non-copyable:
  book(const book&);
  book& operator=(const book&);
};

} // end anonymous namespace

int main(int argc, char* argv[])
{
  TestUtilities* util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  // replacing bind1st, bind2nd
  result_stream << sigc::bind<0>(foo(), -12345)(5);
  util->check_result(result_stream, "foo(int -12345, int 5) -12340");

  result_stream << sigc::bind<1>(foo(), -12345)(5);
  util->check_result(result_stream, "foo(int 5, int -12345) -12340");

  // multiple
  sigc::bind(foo(), 1, 2)();
  util->check_result(result_stream, "foo(int 1, int 2) ");

  // bind from end
  sigc::bind<-1>(foo(), 4)(3);
  util->check_result(result_stream, "foo(int 3, int 4) ");

  sigc::bind(foo(), 4)(3);
  util->check_result(result_stream, "foo(int 3, int 4) ");

  // used together
  sigc::bind<0>(sigc::bind<0>(foo(), 7), 8)();
  util->check_result(result_stream, "foo(int 7, int 8) ");

  // void return
  sigc::bind(foo(), 9, 10)(11); // (only returned void if typeof() would be supported)
  util->check_result(result_stream, "foo(int 11, int 9, int 10) ");

  sigc::bind(foo_void(), 12)();
  util->check_result(result_stream, "foo_void(int 12)");

  // function pointer instead of functor
  sigc::bind(&bar, 13, 14)();
  util->check_result(result_stream, "bar(int 13, int 14) ");

  // method pointer instead of functor
  book test_book("otto");
  result_stream << sigc::bind<0>(&book::get_name, sigc::ref(test_book))();
  util->check_result(result_stream, "otto");

  // test return type of bind_functor::operator() overload with no arguments
  result_stream << sigc::bind(foo(), 15)();
  util->check_result(result_stream, "foo(int 15) 1");

  result_stream << sigc::bind(&simple, true)();
  util->check_result(result_stream, "simple(bool 1) 1");

  // test references
  std::string str("guest book");
  sigc::bind(&egon, sigc::ref(str))(); // Tell bind that it shall store a reference.
  result_stream << " " << str; // (This cannot be the default behaviour: just think about what happens if str dies!)
  util->check_result(result_stream, "egon(string 'guest book') egon was here");

  sigc::slot<void> sl;
  {
    book guest_book("karl");
    sl = sigc::bind(&egon, sigc::ref(guest_book));
    sl();
    result_stream << " " << static_cast<std::string&>(guest_book);
    util->check_result(result_stream, "egon(string 'karl') egon was here");
  } // auto-disconnect

  sl();
  util->check_result(result_stream, "");
  // This causes a crash when using g++ 3.3.4 or 3.3.5 (but not 3.4.x) when not specifying
  // the exact template specialization in visit_each_type() - see the comments there.
  // It looks like the auto-disconnect does not work, so the last sl() call tries
  // to access the guest_book data again.

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
