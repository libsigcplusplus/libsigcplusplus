// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/functors/functors.h>
#include <sigc++/adaptors/lambda/lambda.h>

using namespace sigc::functor;

#ifndef SIGC_CXX_TYPEOF
// other template libraries (e.g. boost::lambda) have similar hacks built in
// to make lambda shift operators work with streams
namespace sigc { namespace functor { namespace internal {
template <class T_arg>
struct shiftleft_deduce_result_type<std::ostream&, T_arg>
{
  typedef std::ostream& type;
};
} } }
#endif

int foo(int i, int j)
  {std::cout << "foo(int "<<i<<", int "<<j<<")" << std::endl; return 4*i+j;}

void foo_void(int i)
  {std::cout << "foo_void(int "<<i<<")" << std::endl;}

struct bar
{
  int test(int i, int j)
    {std::cout << "bar::test(int "<<i<<", int "<<j<<")" << std::endl; return 4*i+j;}
  void test_void(int i)
    {std::cout << "bar::test_void(int "<<i<<")" << std::endl;}
};

main()
{
  // test lambda operators
  std::cout << (_1 + _2) (3,4) << std::endl;
  std::cout << (_1 + 1)  (3,4) << std::endl;
  std::cout << (_2 + 1)  (3,4) << std::endl;
  std::cout << (2 + _1)  (3,4) << std::endl;
  std::cout << (2 + _2)  (3,4) << std::endl;
  std::cout << (_1+_2*_3)(1,2,3) << std::endl;

       // c++ restrictions:
       // - ref() must be used to indicate that the value shall not be copied
       // - constant() is used to create a lambda and delay execution of "std::cout << 1"
       // - var() is used to create a lambda that holds a reference and is interchangable with ref() in lambda operator expressions
       // - cannot use std::endl without much hackery because it is defined as a template function
       // - cannot use "\n" without ref() because arrays cannot be copied
  (sigc::ref(std::cout) << constant(1) << sigc::ref("\n"))();
  (var(std::cout) << 1 << sigc::ref("\n"))();
  (sigc::ref(std::cout) << _1 << std::string("\n"))("hello world");
  (var(std::cout) << _1 << std::string("\n"))("hello world");

  // test grp adaptor
  bar the_bar;
  std::cout << (group(&foo, _1, _2)) (1, 2) << std::endl;
  std::cout << (group(&foo, _2, _1)) (1, 2) << std::endl;
  std::cout << (group(mem_fun(&bar::test), _1, _2, _3)) (sigc::ref(the_bar), 1, 2) << std::endl;

  // same functionality as bind
  std::cout << (group(&foo, _1, 2))  (1)    << std::endl;
  std::cout << (group(&foo, 1, 2))   ()     << std::endl;
  (group(ptr_fun(&foo_void), 1)) ();

  // same functionality as hide
  std::cout << (group(&foo, _1, _2)) (1,2,3) << std::endl;
  (group(ptr_fun(&foo_void), _2)) (1, 2);

  // same functionality as compose
  std::cout << (group(&foo, group(&foo, _1, _2), _3)) (1,2,3) << std::endl;
}
