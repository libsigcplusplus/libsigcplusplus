// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/exception_catch.h>
#include <iostream>
#include <stdexcept>

using namespace std;
using namespace sigc::functor;

#ifndef SIGC_CXX_TYPEOF
struct f : public sigc::functor::functor_base
{
  typedef int result_type;
#else
struct f
{
#endif
  int operator()(int i) 
    {cout << "f(int "<<i<<")"<<endl; 
     throw std::range_error("out of range");}
};

struct g : public sigc::functor::functor_base
{
  // also necessary if the compiler supports typeof() because the return type of
  // g's operator() overload with no arguments cannot be auto-detected in C++:
  typedef int result_type;
  int operator()() 
    {cout << "g()"<<endl; 
     throw std::range_error("out of range");}
};

struct g_void : public sigc::functor::functor_base
{
  typedef void result_type;
  void operator()()
    {cout << "g_void()"<<endl;
     throw std::range_error("out of range");}
};


struct my_catch
{
  int operator()()
  {
    try { throw; } 
    catch (std::range_error e) // catch what types we know
      {
        cerr << "caught "<< e.what() <<endl;
      }
    return 1;
    // all else continues out.
  }
};


int main()
{
  cout << exception_catch(f(), my_catch())(1) << endl;
  cout << exception_catch(g(), my_catch())() << endl;
  exception_catch(g_void(), my_catch())(); // void test
}
