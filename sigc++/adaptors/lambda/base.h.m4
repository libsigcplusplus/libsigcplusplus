dnl Copyright 2002, Karl Einar Nelson 
dnl 
dnl This library is free software; you can redistribute it and/or 
dnl modify it under the terms of the GNU Lesser General Public 
dnl License as published by the Free Software Foundation; either 
dnl version 2.1 of the License, or (at your option) any later version. 
dnl 
dnl This library is distributed in the hope that it will be useful, 
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of 
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
dnl Lesser General Public License for more details. 
dnl 
dnl You should have received a copy of the GNU Lesser General Public 
dnl License along with this library; if not, write to the Free Software 
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
dnl
divert(-1)
include(template.macros.m4)

define([LAMBDA_DO],[dnl
  template <LOOP(class T_arg%1,$1)>
  typename callof<LIST(T_type,LOOP(T_arg%1,$1))>::result_type
  operator ()(LOOP(T_arg%1 _A_%1,$1)) const 
    { 
      return value_.template operator()<LOOP(_P_(T_arg%1),$1)>
             (LOOP(_A_%1,$1)); 
    }
])
define([LAMBDA_DO_VALUE],[dnl
  template <LOOP(class T_arg%1,$1)>
  T_type operator ()(LOOP(T_arg%1 _A_%1,$1)) const 
    { return value_; }
])

divert(0)dnl
#ifndef _SIGC_LAMBDA_BASE_HPP_
#define _SIGC_LAMBDA_BASE_HPP_
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc {

/********************************************************************/

// dummy structure to keep track of the where we are.
struct lambda_base : public functor::adaptor_base {};

template <class T_type> struct lambda;

namespace internal {

template <class T_type, bool I_islambda=is_base_and_derived<lambda_base,T_type>::value> struct lambda_core;

template <class T_type>
struct lambda_core<T_type,true> : public lambda_base
{
  typedef T_type lambda_type;

FOR(1,CALL_SIZE,[[LAMBDA_DO(%1)]])

  lambda_core() {}
  lambda_core(const T_type& v)
    : value_(v) {}

  template <class T1,class T2>
  lambda_core(const T1& v1,const T2& v2)
    : value_(v1,v2) {}

  T_type value_;
};

template <class T_type>
struct lambda_core<T_type,false> : public lambda_base
{
  typedef lambda<T_type> lambda_type;

FOR(1,CALL_SIZE,[[LAMBDA_DO_VALUE(%1)]])

  lambda_core(typename type_trait<T_type>::take v)
    : value_(v) {}

  T_type value_;
};

} /* namespace internal */

template <class T_type>
struct lambda : public internal::lambda_core<T_type>
{
  lambda()
    {}
  lambda(typename type_trait<T_type>::take v)
    : internal::lambda_core<T_type>(v) 
    {}
};


} /* namespace sigc */

#endif /* _SIGC_LAMBDA_BASE_HPP_ */
