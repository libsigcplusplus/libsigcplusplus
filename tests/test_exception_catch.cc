// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/exception_catch.h>
#include <iostream>
#include <stdexcept>

using namespace std;
using namespace sigc::functor;

struct f 
{
  int operator()(int i) 
    {cout << "f(int "<<i<<")"<<endl; 
     throw std::range_error("out of range");}
};
#if 0
struct g 
{
  int operator()() 
    {cout << "g()"<<endl; 
     throw std::range_error("out of range");}
};
#endif

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
  exception_catch(f(), my_catch())(1);
//  exception_catch(g(), my_catch())();
}
