// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <iostream>
#include <sigc++/adaptors/bind.h>
#include <sigc++/adaptors/compose.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/ptr_fun.h>

using namespace std;
using namespace sigc::functor;

class trackable {};
struct A: public trackable { A() {} };

template  <bool I_derived, class T_type> struct with_trackable;

template <class T_type>
struct with_trackable<false,T_type>
{
  static void perform(const T_type& t) 
  { cout << "other" <<endl; }
};

template <class T_type>
struct with_trackable<true,T_type>
{
  static void perform(const T_type& t) 
  { cout << "trackable" << endl; }
  static void perform(T_type* t) 
  { cout << "trackable*" << endl; }
  static void perform(const T_type* t) 
  { cout << "const trackable*" << endl; }
};

struct print
{
  void operator()(int i) const
    { cout << "int "<< i << endl; }
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
  cout << "hit all targets" << endl;
  visit_each(print(),compose(bind<1>(ptr_fun3(&foo),&a,j),ptr_fun1(&bar)));
  cout << "hit all ints" << endl;
  visit_each_type<int>(print(),compose(bind<1>(ptr_fun3(&foo),&a,j),ptr_fun1(&bar)));
  cout << "hit all trackable" << endl;
  visit_each_type<trackable*>(print(),compose(bind<1>(ptr_fun3(&foo),&a,j),ptr_fun1(&bar)));
}
