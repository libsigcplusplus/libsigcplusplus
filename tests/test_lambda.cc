// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/functors/functors.h>
#include <sigc++/adaptors/lambda/lambda.h>

using namespace std;
using namespace sigc;
using namespace sigc::functor;

int foo(int i, int j) { return 4*i+j; }

main()
{
   cout << (_1 + _2) (3,4) << endl;
   cout << (_1 + 1) (3,4) << endl;
   cout << (_2 + 1) (3,4) << endl;
   cout << (2 + _1) (3,4) << endl;
   cout << (2 + _2) (3,4) << endl;

   cout << (_1+_2*_3) (1,2,3) << endl;

   cout << ( functor::ptr_fun(&foo) % grp (_1, _2)) (1, 2) << endl;
   cout << ( functor::ptr_fun(&foo) % grp (_2, _1)) (1, 2) << endl;

//   (lambda<ostream&>(cout) << 1)(1);
//   (lambda<ostream&>(cout) << _L1) ("hello world");
}
