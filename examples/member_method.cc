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

class Something : public sigc::trackable
{
public:
  Something();

protected:

  virtual void on_print(int a);
  
  typedef sigc::signal<void, int> type_signal_print;
  type_signal_print signal_print;
    
};

Something::Something()
{
  type_signal_print::iterator iter = signal_print.connect( sigc::mem_fun(this, &Something::on_print) );

  signal_print.emit(2);

  //This isn't necessary - it's just to demonstrate how to disconnect:
  iter->disconnect();
  signal_print.emit(3); //Prove that it is no longer connected.
}

void Something::on_print(int a)
{
  std::cout << "on_print recieved: " << a << std::endl;
}

int main()
{
  Something something;  
  return 0;
}
