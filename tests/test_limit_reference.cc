#include <sigc++/sigc++.h>

class Base
  : virtual public sigc::trackable
{
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
  void method()
  {}
};

int main(int argc, char **argv)
{
  Derived *instance = new Derived();
  sigc::slot<void> handler = sigc::mem_fun(instance, &Derived::method);
  sigc::slot<void> param =
    sigc::bind(sigc::slot<void, Derived &>(), sigc::ref(*instance));
  sigc::slot<Derived> ret =
    sigc::bind_return(sigc::slot<void>(), sigc::ref(*instance));
  delete instance;

  return 0;
}
