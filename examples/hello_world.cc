/* Copyright 2003, The libsigc++ Development Team
 *
 *  Assigned to the public domain.  Use as you wish without
 *  restriction.
 */

#include <iostream>
#include <string>

#include <sigc++/sigc++.h>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)
SIGC_USING_STD(string)

void on_print(const std::string& str)
{
  std::cout << str;
}

int main()
{
  sigc::signal<void, const std::string&> signal_print;
  
  signal_print.connect( sigc::ptr_fun(&on_print) );
  
  signal_print.emit("hello world\n");

  return 0;
}
