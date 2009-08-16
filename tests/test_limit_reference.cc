#include <sigc++/sigc++.h>

namespace
{

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

} // anonymous namespace

int main(int, char**)
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
