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
    { return value_.LIBSIGC_TEMPLATE_PREFIX SIGC_WORKAROUND_OPERATOR_PARENTHESES<LOOP(_P_(T_arg%1), $1)>
             (LOOP(_A_%1, $1)); 
    }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <LOOP(class T_arg%1, $1)>
  typename deduce_result_type<LOOP(T_arg%1,$1)>::type
  sun_forte_workaround(LOOP(T_arg%1 _A_%1, $1)) const
    { return operator()(LOOP(_A_%1, $1)); }
  #endif //SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD

])dnl
define([LAMBDA_DO_VALUE],[dnl
  template <LOOP(class T_arg%1, $1)>
  result_type operator ()(LOOP(T_arg%1 _A_%1, $1)) const 
    { return value_; }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <LOOP(class T_arg%1, $1)>
  result_type sun_forte_workaround(LOOP(T_arg%1 _A_%1, $1)) const
    { return operator()(LOOP(_A_%1, $1)); }
  #endif //SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD

])dnl

divert(0)dnl
#ifndef _SIGC_LAMBDA_BASE_HPP_
#define _SIGC_LAMBDA_BASE_HPP_
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc {

/** @defgroup lambdas Lambdas
 * libsigc++ ships with basic lambda functionality and the sigc::group adaptor that uses lambdas to transform a functor's parameter list.
 *
 * The lambda selectors sigc::_1, sigc::_2, ..., sigc::_9 are used to select the
 * first, second, ..., nineth argument from a list.
 *
 * @par Examples:
 *   @code
 *   std::cout << sigc::_1(10,20,30); // returns 10
 *   std::cout << sigc::_2(10,20,30); // returns 20
 *   ...
 *   @endcode
 *
 * Operators are defined so that lambda selectors can be used e.g. as placeholders in
 * arithmetic expressions.
 *
 * @par Examples:
 *   @code
 *   std::cout << (sigc::_1 + 5)(3); // returns (3 + 5)
 *   std::cout << (sigc::_1 * sigc::_2)(7,10); // returns (7 * 10)
 */

// dummy structure to keep track of the where we are.
struct lambda_base : public adaptor_base {};

template <class T_type> struct lambda;


namespace internal {

template <class T_type, bool I_islambda = is_base_and_derived<lambda_base, T_type>::value> struct lambda_core;

template <class T_type>
struct lambda_core<T_type, true> : public lambda_base
{
  template <LOOP(class T_arg%1=void,CALL_SIZE)>
  struct deduce_result_type
    { typedef typename T_type::template deduce_result_type<LOOP(_P_(T_arg%1),CALL_SIZE)>::type type; };
  typedef typename T_type::result_type result_type;
  typedef T_type lambda_type;

  result_type
  operator()() const;

FOR(1,CALL_SIZE,[[LAMBDA_DO(%1)]])dnl
  lambda_core() {}

  explicit lambda_core(const T_type& v)
    : value_(v) {}
dnl
dnl  TODO: I have no idea what the following ctor was written for. Remove it?
dnl  template <class T1, class T2>
dnl  lambda_core(const T1& v1, const T2& v2)
dnl    : value_(v1, v2) {}

  T_type value_;
};

template <class T_type>
typename lambda_core<T_type, true>::result_type
lambda_core<T_type, true>::operator()() const
  { return value_(); }


template <class T_type>
struct lambda_core<T_type, false> : public lambda_base
{
  template <LOOP(class T_arg%1=void,CALL_SIZE)>
  struct deduce_result_type
    { typedef T_type type; };
  typedef T_type result_type; // all operator() overloads return T_type.
  typedef lambda<T_type> lambda_type;

  result_type operator()() const;

FOR(1,CALL_SIZE,[[LAMBDA_DO_VALUE(%1)]])dnl
  explicit lambda_core(typename type_trait<T_type>::take v)
    : value_(v) {}

  T_type value_;
};

template <class T_type>
typename lambda_core<T_type, false>::result_type lambda_core<T_type, false>::operator()() const
  { return value_; }

} /* namespace internal */


template <class T_action, class T_functor, bool I_islambda>
void visit_each(const T_action& _A_action,
                const internal::lambda_core<T_functor, I_islambda>& _A_target)
{
  visit_each(_A_action, _A_target.value_);
}


// forward declarations for lambda operators other<subscript> and other<assign>
template <class T_type>
struct other;
struct subscript;
struct assign;

template <class T_action, class T_type1, class T_type2>
struct lambda_operator;


// lambda
template <class T_type>
struct lambda : public internal::lambda_core<T_type>
{
  typedef lambda<T_type> self;

  lambda()
    {}

  lambda(typename type_trait<T_type>::take v)
    : internal::lambda_core<T_type>(v) 
    {}

  // operators for other<subscript>
  template <class T_arg>
  lambda<lambda_operator<other<subscript>, self, T_arg> >
  operator [[]] (const lambda<T_arg>& a) const
    { return lambda<lambda_operator<other<subscript>, self, T_arg> >(lambda_operator<other<subscript>, self, T_arg>(this->value_, a.value_)); }
  template <class T_arg>
  lambda<lambda_operator<other<subscript>, self, T_arg> >
  operator [[]] (const T_arg& a) const
    { return lambda<lambda_operator<other<subscript>, self, T_arg> >(lambda_operator<other<subscript>, self, T_arg>(this->value_, a)); }

  // operators for other<assign>
  template <class T_arg>
  lambda<lambda_operator<other<assign>, self, T_arg> >
  operator = (const lambda<T_arg>& a) const
    { return lambda<lambda_operator<other<assign>, self, T_arg> >(lambda_operator<other<assign>, self, T_arg>(this->value_, a.value_)); }
  template <class T_arg>
  lambda<lambda_operator<other<assign>, self, T_arg> >
  operator = (const T_arg& a) const
    { return lambda<lambda_operator<other<assign>, self, T_arg> >(lambda_operator<other<assign>, self, T_arg>(this->value_, a)); }
};


template <class T_action, class T_type>
void visit_each(const T_action& _A_action,
                const lambda<T_type>& _A_target)
{
  visit_each(_A_action, _A_target.value_);
}


template <class T_type>
lambda<T_type> constant(const T_type& v)
{ return lambda<T_type>(v); }

template <class T_type>
lambda<T_type&> var(T_type& v)
{ return lambda<T_type&>(v); }

template <class T_type>
lambda<const T_type&> var(const T_type& v)
{ return lambda<const T_type&>(v); }

} /* namespace sigc */

#endif /* _SIGC_LAMBDA_BASE_HPP_ */
