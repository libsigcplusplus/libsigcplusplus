// -*- c++ -*-
/* Copyright 2002, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <sigc++/adaptors/retype.h>
#include <iostream>

SIGC_USING_STD(cout)
SIGC_USING_STD(endl)

struct foo : public sigc::trackable
{
  float test_int(int i) 
  {
    std::cout << "foo(int " << i << ")" << std::endl;
    return i * 1.5f;
  }
  float test_float(float f)
  {
    std::cout << "foo(float " << f << ")" << std::endl;
    return f * 5;
  }
};

void bar(short s)
{
  std::cout << "bar(short " << s << ")" << std::endl;
}

int main()
{
  foo foo_;
  std::cout << sigc::retype(sigc::mem_fun(foo_, &foo::test_int))(1.234f) << std::endl;
  std::cout << sigc::retype(sigc::mem_fun(foo_, &foo::test_float))(5) << std::endl;
  sigc::retype(sigc::ptr_fun(&bar))(6.789f);

  sigc::slot<float,float> s1 = sigc::retype(sigc::mem_fun(foo_, &foo::test_int));
  sigc::slot<float,int>   s2 = sigc::retype(sigc::mem_fun(foo_, &foo::test_float));
  sigc::slot<void,double> s3 = sigc::retype(sigc::ptr_fun(&bar));
  std::cout << s1(1.234f) << std::endl;
  std::cout << s2(5) << std::endl;
  s3(6.789);

  s2 = sigc::retype(s1);
  std::cout << s2(5) << std::endl;
}
