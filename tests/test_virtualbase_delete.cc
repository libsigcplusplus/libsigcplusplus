#include <sigc++/sigc++.h>


class Base : virtual public sigc::trackable
{
public:
   sigc::signal<void> signal_something;
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
     signal_something.connect(sigc::mem_fun(this, &Derived::handler));
  }

private:
   void handler()
   {}
};

int main(int argc, char **argv)
{
   Derived* instance = new Derived();
   delete instance;

   return 0;
}
