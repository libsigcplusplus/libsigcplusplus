dnl Copyright 2002, The libsigc++ Development Team 
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
  template <LOOP(class T_arg%1, $1)>
  typename deduce_result_type<LOOP(T_arg%1,$1)>::type
  operator ()(LOOP(T_arg%1 _A_%1, $1)) const 
    { return value_.template operator()<LOOP(_P_(T_arg%1), $1)>
             (LOOP(_A_%1, $1)); 
    }

])dnl
define([LAMBDA_DO_VALUE],[dnl
  template <LOOP(class T_arg%1, $1)>
  T_type operator ()(LOOP(T_arg%1 _A_%1, $1)) const 
    { return value_; }

])dnl

divert(0)dnl
#ifndef _SIGC_LAMBDA_BASE_HPP_
#define _SIGC_LAMBDA_BASE_HPP_
#include <sigc++/adaptors/adaptor_trait.h>


namespace sigc {
namespace functor {

// dummy structure to keep track of the where we are.
struct lambda_base : public adaptor_base {};

template <class T_type> struct lambda;


namespace internal {

template <class T_type, class T_return = typename functor_trait<T_type>::result_type, bool I_islambda = is_base_and_derived<lambda_base, T_type>::value> struct lambda_core;

template <class T_type, class T_return>
struct lambda_core<T_type, T_return, true> : public lambda_base
{
  template <LOOP(class T_arg%1=void,CALL_SIZE)>
  struct deduce_result_type
    { typedef typename T_type::deduce_result_type<LOOP(T_arg%1,CALL_SIZE)>::type type; };
  typedef T_return result_type;
  typedef T_type   lambda_type;

  result_type
  operator()() const;

FOR(1,CALL_SIZE,[[LAMBDA_DO(%1)]])dnl
  lambda_core() {}
  lambda_core(const T_type& v)
    : value_(v) {}

  template <class T1, class T2>
  lambda_core(const T1& v1, const T2& v2)
    : value_(v1, v2) {}

  T_type value_;
};

template <class T_type, class T_return>
typename lambda_core<T_type, T_return, true>::result_type
lambda_core<T_type, T_return, true>::operator()() const
  { return value_(); }


/*// void specialization
template <class T_type>
struct lambda_core<T_type, void, true> : public lambda_base
{
  template <LOOP(class T_arg%1=void,CALL_SIZE)>
  struct deduce_result_type
    { typedef typename T_type::deduce_result_type<LOOP(T_arg%1,CALL_SIZE)>::type type; };
  typedef T_type lambda_type;
  typedef void   result_type;

  void
  operator()() const;

FOR(1,CALL_SIZE,[[LAMBDA_DO(%1)]])dnl
  lambda_core() {}
  lambda_core(const T_type& v)
    : value_(v) {}

  template <class T1, class T2>
  lambda_core(const T1& v1, const T2& v2)
    : value_(v1, v2) {}

  T_type value_;
};

template <class T_type>
typename lambda_core<T_type, void, true>::result_type
lambda_core<T_type, void, true>::operator()() const
  { value_(); }*/


template <class T_type, class T_return>
struct lambda_core<T_type, T_return, false> : public lambda_base
{
  template <LOOP(class T_arg%1=void,CALL_SIZE)>
  struct deduce_result_type
    { typedef T_type type; };
  typedef T_type result_type; // all operator() overloads return T_type.
                              // T_return == functor_trait<T_type>::result_type can be extracted at any other point.
  typedef lambda<T_type> lambda_type;

  T_type operator()() const;

FOR(1,CALL_SIZE,[[LAMBDA_DO_VALUE(%1)]])dnl
  lambda_core(typename type_trait<T_type>::take v)
    : value_(v) {}

  T_type value_;
};

template <class T_type, class T_return>
T_type lambda_core<T_type, T_return, false>::operator()() const
  { return value_; }

} /* namespace internal */


template <class T_action, class T_functor, class T_return, bool I_islambda>
void visit_each(const T_action& _A_action,
                const internal::lambda_core<T_functor, T_return, I_islambda>& _A_target)
{
  visit_each(_A_action, _A_target.value_);
}


template <class T_type>
struct lambda : public internal::lambda_core<T_type>
{
  typedef typename internal::lambda_core<T_type>::result_type result_type;

  lambda()
    {}
  lambda(typename type_trait<T_type>::take v)
    : internal::lambda_core<T_type>(v) 
    {}
};


} /* namespace functor */
} /* namespace sigc */

#endif /* _SIGC_LAMBDA_BASE_HPP_ */
