// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/exception_catch.h>
#include <iostream>
#include <stdexcept>

SIGC_USING_STD(cout)
SIGC_USING_STD(cerr)
SIGC_USING_STD(endl)
SIGC_USING_STD(exception)

struct f : public sigc::functor_base
{
  typedef int result_type;
  int operator()(int i) 
    {std::cout << "f(int "<<i<< ")"<< std::endl; 
     throw std::range_error("out of range");}
};

struct g : public sigc::functor_base
{
  typedef int result_type;
  int operator()() 
    {std::cout << "g()" << std::endl;
     throw std::range_error("out of range");}
};

struct g_void : public sigc::functor_base
{
  typedef void result_type;
  void operator()()
    {std::cout << "g_void()" << std::endl;
     throw std::range_error("out of range");}
};


struct my_catch
{
  int operator()()
  {
    try { throw; } 
    catch (std::range_error e) // catch what types we know
      {
        std::cerr << "caught "<< e.what() <<std::endl;
      }
    return 1;
    // all else continues out.
  }
};


int main()
{
  std::cout << sigc::exception_catch(f(), my_catch())(1) << std::endl;
  std::cout << sigc::exception_catch(g(), my_catch())() << std::endl;
  sigc::exception_catch(g_void(), my_catch())(); // void test
}
