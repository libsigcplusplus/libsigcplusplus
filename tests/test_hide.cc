// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/hide.h>
#include <iostream>

using namespace std;
using namespace sigc::functor;

struct foo 
{
  bool operator()()
    {cout << "foo()"<<endl; return true;}
  int operator()(int j) 
    {cout << "foo(int "<<j<<")"<<endl; return 1+j;}
};

namespace sigc {
namespace functor {

// explicitly specify the return type of foo's operator() overload with no arguments
// (cannot be auto-detected):
SIGC_FUNCTOR_TRAIT(foo,bool)

} /* namespace functor */
} /* namespace sigc */


int main()
{
  cout << hide<1>(foo())(1,2) << endl;
  cout << hide<2>(foo())(1,2) << endl;
  cout << hide<0>(foo())(1) << endl;
}
