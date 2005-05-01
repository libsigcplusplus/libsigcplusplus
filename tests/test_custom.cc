#include <sigc++/sigc++.h>


class Base : virtual public sigc::trackable
{
public:
  
};

class Base2
{
public:
  virtual ~Base2()
  {}
};


class Derived
  : virtual public Base,
    public Base2
{
public:
  Derived()
  {
    
  }
};

void handler(Derived &dlg)
{}

int main(int argc, char **argv)
{
  sigc::signal<void> signal_something;

  Derived* param = new Derived();
  signal_something.connect(sigc::bind( sigc::ptr_fun(&handler), sigc::ref(*param) ));
  delete param;

  return 0;
}
