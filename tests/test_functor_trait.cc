// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/adaptors/bind.h>
#include <sigc++/adaptors/compose.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/ptr_fun.h>

class trackable {};
struct A: public trackable { A() {} };

template <bool I_derived, class T_type> struct with_trackable;

template <class T_type>
struct with_trackable<false,T_type>
{
  static void perform(const T_type& t) 
  { std::cout << "other" <<std::endl; }
};

template <class T_type>
struct with_trackable<true,T_type>
{
  static void perform(const T_type& t) 
  { std::cout << "trackable" << std::endl; }
  static void perform(T_type* t) 
  { std::cout << "trackable*" << std::endl; }
  static void perform(const T_type* t) 
  { std::cout << "const trackable*" << std::endl; }
};

struct print
{
  void operator()(int i) const
    { std::cout << "int "<< i << std::endl; }
  template <class T>
  void operator()(const T& t) const
    { with_trackable<sigc::is_base_and_derived<trackable,T>::value,T>::perform(t); }
  template <class T>
  void operator()(const T* t) const
    { with_trackable<sigc::is_base_and_derived<trackable,T>::value,T>::perform(t); }
  template <class T>
  void operator()(T* t) const
    { with_trackable<sigc::is_base_and_derived<trackable,T>::value,T>::perform(t); }
};

void foo(int i,int j,int k)
{}

void bar(int i)
{}

int main()
{
  int i=1,j=2,k=3;
  A a;
  std::cout << "hit all targets" << std::endl;
  sigc::visit_each(print(),sigc::compose(sigc::bind(sigc::ptr_fun3(&foo),&a,j),sigc::ptr_fun1(&bar)));
  std::cout << "hit all ints" << std::endl;
  sigc::visit_each_type<int>(print(),sigc::compose(sigc::bind(sigc::ptr_fun3(&foo),&a,j),sigc::ptr_fun1(&bar)));
  std::cout << "hit all trackable" << std::endl;
  sigc::visit_each_type<trackable*>(print(),sigc::compose(sigc::bind(sigc::ptr_fun3(&foo),&a,j),sigc::ptr_fun1(&bar)));
}
