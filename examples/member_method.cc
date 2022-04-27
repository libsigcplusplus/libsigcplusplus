/* Copyright 2003 - 2016, The libsigc++ Development Team
 *
 *  Assigned to the public domain.  Use as you wish without
 *  restriction.
 */

#include <iostream>
#include <string>

#include <sigc++/sigc++.h>

class Something : public sigc::trackable
{
public:
  Something();

protected:
  void on_print(int a);

  using type_signal_print = sigc::signal<void(int)>;
  type_signal_print signal_print;
};

Something::Something()
{
  auto connection = signal_print.connect(sigc::mem_fun(*this, &Something::on_print));

  signal_print.emit(2);

  // This isn't necessary - it's just to demonstrate how to disconnect:
  connection.disconnect();
  signal_print.emit(3); // Prove that it is no longer connected.
}

void
Something::on_print(int a)
{
  std::cout << "on_print received: " << a << std::endl;
}

int
main()
{
  Something something;
  return 0;
}
