// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/bind.h>
#include <sigc++/functors/slot.h>
#include <iostream>

using namespace sigc::functor;
using sigc::trackable;

struct foo 
{
  bool operator()(int i)
    {std::cout << "foo(int "<<i<<")" << std::endl; return (i>0);}
  int operator()(int i,int j)
    {std::cout << "foo(int "<<i<<",int "<<j<<")" << std::endl; return i+j;}
  void operator()(int i,int j,int k)
    {std::cout << "foo(int "<<i<<",int "<<j<<", int "<<k<<")" << std::endl;}
};


namespace sigc {
namespace functor {

// explicitly specify the return type of foo's operator() overload with no arguments
// (cannot be auto-detected):
SIGC_FUNCTOR_TRAIT(foo,bool)

} /* namespace functor */
} /* namespace sigc */


int bar(int i,int j) 
  {std::cout << "bar(int "<<i<<",int "<<j<<")" << std::endl; return i+j;}

bool simple(bool test)
  {std::cout << "simple(bool "<<test<<")" << std::endl; return test;}

void egon(std::string& str)
  {std::cout << "egon(string '"<<str<<"')" << std::endl; str="egon was here";}


struct book : public trackable
{
  book(const std::string& name) : name_(name) {}
  operator std::string& () {return name_;}
  std::string name_;
};


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

  // test references
  std::string str("guest book");
  bind<0,std::string&>(&egon,str)(); // Tell bind that is shall store a reference.
  std::cout << str << std::endl;     // (This cannot be the default behaviour: just think about what happens if str dies!)

  slot<void> c;
  {
    book guest_book("karl");
    c = bind<0,book&>(&egon,guest_book);
    c();
    std::cout << (std::string&)guest_book << std::endl;
  }    // auto-disconnect
  c(); // :-)
}
