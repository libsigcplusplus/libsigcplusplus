// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/hide.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct foo : public sigc::functor::functor_base
{
#ifdef SIGC_CXX_TYPEOF
  // if the compiler supports typeof(), result_type must only match the
  // return type of foo's operator() overload with no arguments (cannot be auto-detected in C++).
  typedef bool result_type;
  bool operator()()
    {cout << "foo()"<<endl; return true;}
  int operator()(int j) 
    {cout << "foo(int "<<j<<")"<<endl; return 1+j;}
#else
  // choose a type that can hold all return values
  typedef int result_type;
  int operator()()
    {cout << "foo()"<<endl; return true;}
  int operator()(int j) 
    {cout << "foo(int "<<j<<")"<<endl; return 1+j;}
#endif
};

struct foo_void : public sigc::functor::functor_base
{
  typedef void result_type;
  void operator()()
    {cout << "foo_void()"<<endl;}
};

namespace sigc {
namespace functor {

SIGC_FUNCTOR_TRAIT(foo,bool)

} /* namespace functor */
} /* namespace sigc */


int main()
{
  cout << hide<1>(foo())(1,2) << endl;
  cout << hide<2>(foo())(1,2) << endl;
  cout << hide<0>(foo())(1) << endl;
  hide<0>(foo_void())(1); // void test
}
