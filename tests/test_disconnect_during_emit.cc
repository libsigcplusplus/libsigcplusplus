// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/trackable.h>
#include <sigc++/signal.h>
#include <sigc++/connection.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <iostream>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

sigc::connection connection;

class HandlerClass : public sigc::trackable
{
public:
  void handler()
  {
    std::cout << "handler called" << std::endl;
    connection.disconnect();
  }
};
  

int main()
{
  HandlerClass instance;
  
  sigc::signal<void> signal_test;
  signal_test.connect( sigc::mem_fun(instance, &HandlerClass::handler) );
  signal_test.emit();
}
