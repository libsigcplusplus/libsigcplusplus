// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/compose.h>
#include <iostream>

// assume existance of T_functor::result_type for unknown functor types:
namespace sigc { SIGC_FUNCTORS_HAVE_RESULT_TYPE }

struct set 
{
#ifdef SIGC_CXX_TYPEOF
  // if the compiler supports typeof(), result_type must only match the
  // return type of set's operator()(int) overload (cannot be auto-detected in C++).
  typedef int result_type;
  int operator()(int i) 
    {std::cout << "set(int "<<i<<")"<<std::endl; return i*i;}
  float operator()(float i) 
    {std::cout << "set(float "<<i<<")"<<std::endl; return i*5;}
#else
  // choose a type that can hold all return values
  typedef float result_type;
  float operator()(int i) 
    {std::cout << "set(int "<<i<<")"<<std::endl; return i*i;}
  float operator()(float i) 
    {std::cout << "set(float "<<i<<")"<<std::endl; return i*5;}
#endif
};

struct set_void
{
  typedef void result_type;
  void operator()(float i)
    { std::cout << "set_void(float "<<i<<")"<<std::endl; }
};

struct get
{
#ifdef SIGC_CXX_TYPEOF
  bool operator()()
    { std::cout << "get()"<<std::endl; return true; }
  int operator()(int i) 
    { std::cout << "get("<<i<<")"<<std::endl; return i*2; }
  float operator()(int i,int j) 
    { std::cout << "get("<<i<<","<<j<<")"<<std::endl; return float(i)/float(j); }
#else
  // choose a type that can hold all return values
  typedef float result_type;
  float operator()()
    { std::cout << "get()"<<std::endl; return true; }
  float operator()(int i) 
    { std::cout << "get("<<i<<")"<<std::endl; return i*2; }
  float operator()(int i,int j) 
    { std::cout << "get("<<i<<","<<j<<")"<<std::endl; return float(i)/float(j); }
#endif
};


int main()
{
  std::cout << sigc::compose(set(),get())() << std::endl;
  std::cout << sigc::compose(set(),get())(1) << std::endl;
  std::cout << sigc::compose(set(),get())(1,2) << std::endl;
  sigc::compose(set_void(),get())(3); //void test
}
