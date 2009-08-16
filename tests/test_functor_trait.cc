// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/adaptors/bind.h>
#include <sigc++/adaptors/compose.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/ptr_fun.h>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

namespace
{

class trackable {};
struct A: public trackable { A() {} };

template <class T_type, bool I_derived = sigc::is_base_and_derived<trackable,T_type>::value>
struct with_trackable;

template <class T_type>
struct with_trackable<T_type,false>
{
  static void perform(const T_type&)
  { std::cout << "other" <<std::endl; }
};

template <class T_type>
struct with_trackable<T_type,true>
{
  static void perform(const T_type&)
  { std::cout << "trackable" << std::endl; }
  static void perform(T_type*)
  { std::cout << "trackable*" << std::endl; }
  static void perform(const T_type*)
  { std::cout << "const trackable*" << std::endl; }
};

struct print
{
  void operator()(int i) const
    { std::cout << "int: "<< i << std::endl; }
  template <class T>
  void operator()(const T& t) const
    { with_trackable<T>::perform(t); }
};

void foo(int, int, int)
{}

void bar(int)
{}

} // anonymous namespace

int main(int, char**)
{
  int i = 1, j = 2, k = 3;
  A a;
  std::cout << "hit all targets" << std::endl;
  sigc::visit_each(print(), sigc::compose(sigc::bind(sigc::ptr_fun3(&foo), sigc::ref(a), i), sigc::ptr_fun1(&bar)));
  std::cout << "hit all ints" << std::endl;
  sigc::visit_each_type<int>(print(), sigc::compose(sigc::bind(sigc::ptr_fun3(&foo), sigc::ref(a), j),sigc::ptr_fun1(&bar)));
  std::cout << "hit all trackable" << std::endl;
  sigc::visit_each_type<trackable>(print(), sigc::compose(sigc::bind(sigc::ptr_fun3(&foo), sigc::ref(a), k),sigc::ptr_fun1(&bar)));
}
