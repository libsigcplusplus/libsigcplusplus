/* Copyright 2003, The libsigc++ Development Team
 *
 *  Assigned to the public domain.  Use as you wish without
 *  restriction.
 */

#include <iostream>
#include <string>

#include <sigc++/signal.h>
#include <sigc++/functors/ptr_fun.h>

using namespace std;
using namespace sigc;

void print(const string &str)
{
  cout << str;
}

main()
{
  signal<void, const string&> printer;
  
  printer.connect(ptr_fun(&print));
  
  printer("hello world\n");
}
