// -*- c++ -*-
/* Copyright 2003, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <string>

#include <sigc++/compatibility.h>

void print(const std::string &str)
  {std::cout << str;}

int main() {
  SigC::Signal1<void,const std::string&> printer;
  printer.connect(SigC::slot(print));
  printer("hello world\n");
  return 0;
}
