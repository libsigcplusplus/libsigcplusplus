// Configuration-time test program, used in Meson build.
// Corresponds to the M4 macro SIGC_CXX_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD.

#include <iostream>

class Thing
{
  public:
  Thing()
  {}

  template <class T>
  void operator()(T a, T b)
  {
    T c = a + b;
    std::cout << c << std::endl;
  }
};

template<class T2>
class OtherThing
{
public:
  void do_something()
  {
     Thing thing_;
     thing_.operator()<T2>(1, 2);
     //This fails with or without the template keyword, on SUN Forte C++ 5.3, 5.4, and 5.5:
  }
};

int main()
{
  OtherThing<int> thing;
  thing.do_something();
  return 0;
}
