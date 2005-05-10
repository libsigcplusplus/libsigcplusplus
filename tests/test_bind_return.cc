// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/bind_return.h>
#include <sigc++/functors/slot.h>
#include <iostream>
#include <string>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)
SIGC_USING_STD(string)

struct foo 
{
  void operator()(int i) 
    {std::cout << "foo(int "<<i<<")"<<std::endl; }
  float operator()(float i) 
    {std::cout << "foo(float "<<i<<")"<<std::endl; return i*5;}
};

struct bar : public sigc::trackable
{
  bar(int i=0) : i_(i) {}
  operator int() {return i_;}
  int i_;
};

int main()
{
  std::cout << sigc::bind_return(foo(),-12345)(5) << std::endl;

  // Here we just build a functor, not a slot. There is no such thing as a
  // default functor, or an invalidated functor. As such, functors can return
  // references.
  std::string str("guest book");
  // A convoluted way to do
  // sigc::bind_return(foo(), sigc::ref(str))(6) = "main";
  sigc::bind_return<sigc::reference_wrapper<std::string> >(foo(), sigc::ref(str))(6) = "main";
  std::cout << str << std::endl;

  // Here we build a slot (constructed from a functor). Slots cannot return
  // references: if they could, then what would be the return value of the
  // default slot or of an invalidated slot? On the other hand, slots are
  // guaranteed to be able to construct and return a valid default instance as
  // long as there exists a default constructor for it.
  //
  // Therefore, we use 'bar', and not 'bar &' for this slot signature.
  sigc::slot<bar,int> sl;
  {
    bar choco(-1);
    sl = sigc::bind_return(foo(),sigc::ref(choco));
    std::cout << sl(7) << std::endl;
  } // auto-disconnect
  std::cout << sl(8) << std::endl;
}
