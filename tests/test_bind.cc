// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/bind.h>
#include <iostream>

using namespace sigc::functor;

struct foo 
{
  bool operator()(int i)
    {std::cout << "foo(int "<<i<<")"<<std::endl; return (i>0);}
  int operator()(int i,int j)
    {std::cout << "foo(int "<<i<<",int "<<j<<")"<<std::endl; return i+j;}
  void operator()(int i,int j,int k)
    {std::cout << "foo(int "<<i<<",int "<<j<<", int "<<k<<")"<<std::endl;}
};

// explicitly specify the return type of foo's operator() overload with no arguments
// (cannot be auto-detected):

namespace sigc {
namespace functor {

template <>
struct functor_trait<foo,false>
{
  typedef bool result_type;
};

} /* namespace functor */
} /* namespace sigc */


int bar(int i,int j) 
  {std::cout << "bar(int "<<i<<",int "<<j<<")"<<std::endl; return i+j;}

bool simple(bool test)
  {std::cout << "simple(bool "<<test<<")"<<std::endl; return test;}


int main()
{
  // replacing bind1st, bind2nd
  std::cout << bind<1>(foo(),-12345)(5) << std::endl;
  std::cout << bind<2>(foo(),-12345)(5) << std::endl;

  // multiple
  bind<1>(foo(),1,2)();

  // bind from end
  bind<0>(foo(),4)(3);

  // multiple beginning from end
  bind<0>(foo(),5,6)();

  // used together
  bind<1>(bind<1>(foo(),7),8)();

  // void return
  bind<1>(foo(),9,10)(11);

  // function pointer instead of functor
  bind<1>(&bar,12,13)();

  // test return type of bind_functor::operator() overload with no arguments
  std::cout << bind<0>(foo(),14)() << std::endl;
  std::cout << bind<0>(&simple, true)() << std::endl;
}
