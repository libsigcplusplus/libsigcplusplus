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

dnl 
dnl Macros to make operators
define([LAMBDA_OPERATOR_DO],[dnl
  template <LOOP(class T_arg%1, $3)>
  typename $1_calc_type<
      typename callof<arg1_type, LOOP(T_arg%1, $3)>::result_type,
      typename callof<arg2_type, LOOP(T_arg%1, $3)>::result_type
    >::result_type
  operator ()(LOOP(T_arg%1 _A_%1, $3)) const
  { 
    return arg1_.template operator()<LOOP(_P_(T_arg%1), $3)>
      (LOOP(_A_%1, $3)) 
      $2 arg2_.template operator()<LOOP(_P_(T_arg%1), $3)>
      (LOOP(_A_%1, $3)); 
  }
])

define([LAMBDA_OPERATOR],[dnl
namespace internal {

template <class T_test1, class T_test2>
struct $1_calc_type
{
dnl
dnl TODO: typeof() ignores "&" - compiler error in gcc-3.2?
dnl       E.g. typeof(type_trait<std::ostream&>::instance() << type_trait<int>::instance())
dnl                 == std::ostream  //(instead of std::ostream&)
dnl
  typedef typeof(type_trait<T_test1>::instance() $2 type_trait<T_test2>::instance()) result_type;
};

template <class T_test1> struct $1_calc_type<T_test1,void>
  { typedef void result_type; };
template <class T_test2> struct $1_calc_type<void,T_test2>
  { typedef void result_type; };
template <> struct $1_calc_type<void,void>
  { typedef void result_type; };

template <class T_type1, class T_type2>
struct lambda_$1 : public lambda_base
{
  typedef typename lambda<T_type1>::lambda_type arg1_type;
  typedef typename lambda<T_type2>::lambda_type arg2_type;

  // We would need an additional template argument T_return for a void specialization.
  // Then we would support operators that return void. TODO: is it wanted?
  typedef typename $1_calc_type<
              typename arg1_type::result_type,
              typename arg2_type::result_type>::result_type result_type;

  result_type
  operator ()() const;

FOR(1, $3,[[LAMBDA_OPERATOR_DO]]($1,$2,%1))

  lambda_$1(_R_(T_type1) a1, _R_(T_type2) a2 )
    : arg1_(a1), arg2_(a2) {}

  arg1_type arg1_;
  arg2_type arg2_;
};

template <class T_type1, class T_type2>
typename lambda_$1<T_type1, T_type2>::result_type
lambda_$1<T_type1, T_type2>::operator ()() const
  { return arg1_() $2 arg2_(); }

divert(2)
// operators for $1
template <class T_arg1, class T_arg2>
lambda<internal::lambda_$1<T_arg1, T_arg2> >
operator $2 (const lambda<T_arg1>& a1, const lambda<T_arg2>& a2)
{ return lambda<internal::lambda_$1<T_arg1, T_arg2> >(internal::lambda_$1<T_arg1, T_arg2>(a1.value_,a2.value_)); }
template <class T_arg1, class T_arg2>
lambda<internal::lambda_$1<T_arg1, T_arg2> >
operator $2 (const lambda<T_arg1>& a1, const T_arg2& a2)
{ return lambda<internal::lambda_$1<T_arg1, T_arg2> >(internal::lambda_$1<T_arg1, T_arg2>(a1.value_,a2)); }
template <class T_arg1, class T_arg2>
lambda<internal::lambda_$1<T_arg1, T_arg2> >
operator $2 (const T_arg1& a1, const lambda<T_arg2>& a2)
{ return lambda<internal::lambda_$1<T_arg1, T_arg2> >(internal::lambda_$1<T_arg1, T_arg2>(a1,a2.value_)); }
divert(0)dnl
} /* namespace internal */

template <class T_action, class T_arg1, class T_arg2>
void visit_each(const T_action& _A_action,
                const internal::lambda_$1<T_arg1, T_arg2>& _A_target)
{
  visit_each(_A_action, _A_target.arg1_);
  visit_each(_A_action, _A_target.arg2_);
}

])
divert(0)dnl
#ifndef _SIGC_LAMBDA_OPERATOR_HPP_
#define _SIGC_LAMBDA_OPERATOR_HPP_
#include <sigc++/adaptors/lambda/base.h>

namespace sigc {
namespace functor {

LAMBDA_OPERATOR(plus,+,CALL_SIZE)
LAMBDA_OPERATOR(minus,-,CALL_SIZE)
LAMBDA_OPERATOR(multiplies,*,CALL_SIZE)
LAMBDA_OPERATOR(divides,/,CALL_SIZE)
LAMBDA_OPERATOR(shiftleft,<<,CALL_SIZE)
LAMBDA_OPERATOR(shiftright,>>,CALL_SIZE)

undivert(2)

} /* namespace functor */
} /* namespace sigc */

#endif /* _SIGC_LAMBDA_OPERATOR_HPP_ */
