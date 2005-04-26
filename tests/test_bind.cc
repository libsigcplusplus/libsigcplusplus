// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/bind.h>
#include <sigc++/functors/slot.h>
#include <iostream>
#include <string>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)
SIGC_USING_STD(string)

struct foo : public sigc::functor_base
{
  // choose a type that can hold all return values
  typedef int result_type;
  int operator()(int i)
    {std::cout << "foo(int "<<i<<")" << std::endl; return (i>0);}
    
  int operator()(int i, int j)
    {std::cout << "foo(int "<<i<<",int "<<j<<")" << std::endl; return i+j;}
    
  int operator()(int i, int j, int k)
    {std::cout << "foo(int "<<i<<",int "<<j<<", int "<<k<<")" << std::endl; return 0;}
};

struct foo_void : public sigc::functor_base
{
  typedef void result_type;
  void operator()(int i)
    {std::cout << "foo_void(int "<<i<<")" << std::endl;}
};


int bar(int i,int j) 
  {std::cout << "bar(int "<< i << ", int " << j << ")" << std::endl; return i+j;}

bool simple(bool test)
  {std::cout << "simple(bool " << test <<")" << std::endl; return test;}

void egon(std::string& str)
  {std::cout << "egon(string '" << str <<"')" << std::endl; str="egon was here";}


struct book : public sigc::trackable
{
  book(const std::string& name) : name_(name) {}
  std::string& get_name()  {return name_;}
  operator std::string& () {return get_name();}

private:
  std::string name_;

  //non-copyable:
  book(const book&);
  book& operator=(const book&);
};


int main()
{
  // replacing bind1st, bind2nd
  std::cout << sigc::bind<0>(foo(),-12345)(5) << std::endl;
  std::cout << sigc::bind<1>(foo(),-12345)(5) << std::endl;

  // multiple
  sigc::bind(foo(),1,2)();

  // bind from end
  sigc::bind<-1>(foo(),4)(3);
  sigc::bind(foo(),4)(3);

  // used together
  sigc::bind<0>(sigc::bind<0>(foo(),7),8)();

  // void return
  sigc::bind(foo(),9,10)(11); // (only returned void if typeof() would be supported)
  sigc::bind(foo_void(),12)();

  // function pointer instead of functor
  sigc::bind(&bar,13,14)();

  // method pointer instead of functor
  book test_book("otto");
  sigc::bind<0>(&book::get_name, sigc::ref(test_book))();

  // test return type of bind_functor::operator() overload with no arguments
  std::cout << sigc::bind(foo(),15)() << std::endl;
  std::cout << sigc::bind(&simple, true)() << std::endl;

  // test references
  std::string str("guest book");
  sigc::bind(&egon, sigc::ref(str))(); // Tell bind that is shall store a reference.
  std::cout << str << std::endl;     // (This cannot be the default behaviour: just think about what happens if str dies!)

  sigc::slot<void> sl;
  {
    book guest_book("karl");
    sl = sigc::bind(&egon, sigc::ref(guest_book));
    sl();
    std::cout << static_cast<std::string&>(guest_book) << std::endl;
  }    // auto-disconnect

  //sl();
  // This causes a crash when using g++ 3.3.4 or 3.3.5 (but not 3.4.x) when not specifying the exact template
  // specialization in visit_each_type() - see the comments there.
  // It looks like the auto-disconnect does not work, so the last sl() call tries to access the guest_book data again.
}
