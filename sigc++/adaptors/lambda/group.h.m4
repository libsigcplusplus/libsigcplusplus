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
dnl  How to call the darn thing!
define([LAMBDA_GROUP_DO],[dnl
define([_L_],[LOOP(_A_%1, $2)])dnl
define([_T_],[LOOP(T_arg%1, $2)])dnl
dnl Please someone get a gun!
  template <LIST(class T_func, LOOP(class T_arg%1, $2))>
  typename callof<
      typename callof<T_func, LOOP(T_arg%1, $2)>::result_type,dnl
LOOP([[
      typename callof<value%1_type, _T_>::result_type]], $1)
    >::result_type
  operator() (LIST(T_func func, LOOP(T_arg%1 _A_%1, $2))) const
    {  return (func(LOOP(_A_%1, $2)))(LOOP(value%1_(_L_),$1)); }
])

dnl
dnl This really doesn't have much to do with lambda other than
dnl holding lambdas with in itself.
define([LAMBDA_GROUP],[dnl
template <LOOP(class T_type%1, $1)>
struct lambda_group$1 : public lambda_base
{
FOR(1, $1,[  typedef typename lambda<T_type%1>::lambda_type value[]%1[]_type;
])

  // T_func must be a lambda
FOR(1,CALL_SIZE,[[LAMBDA_GROUP_DO($1,%1)]])

  lambda_group[]$1[](LOOP(const T_type%1& _A_%1, $1))
    : LOOP(value%1_(_A_%1), $1) {}
FOR(1, $1,[  value%1_type value%1_;
])
};
])

dnl
dnl Operator () for lambda_call
dnl
define([LAMBDA_CALL_DO],[dnl
  template <LOOP(class T_arg%1, $1)>
  typename callof<LIST(T_group, value_type, LOOP(T_arg%1, $1))>::result_type
  operator() (LOOP(T_arg%1 _A_%1, $1)) const
   { return group_(LIST(value_, LOOP(_A_%1, $1))); }
])

divert(0)dnl
__FIREWALL__
#include <sigc++/adaptors/lambda/base.h>

namespace sigc {

FOR(1,3,[[LAMBDA_GROUP(%1)]])

template <class T_value, class T_group>
struct lambda_call : public lambda_base
{
  typedef typename lambda<T_value>::lambda_type value_type;

FOR(1,3,[[LAMBDA_CALL_DO(%1)]])

  lambda_call(const T_value& _A_value, const T_group& _A_group)
    : value_(_A_value), group_(_A_group)
    {}
  mutable value_type value_;
  T_group group_;
};

template <class T_func, class T_arg1>
lambda<lambda_call<T_func, lambda_group1<T_arg1> > >
operator % (const T_func& _A_func, const lambda_group1<T_arg1>& _A_group)
{ 
  typedef lambda_call<T_func, lambda_group1<T_arg1> > T_lambda;
  return lambda<T_lambda>(T_lambda(_A_func, _A_group));
}

template <class T_func, class T_arg1, class T_arg2>
lambda<lambda_call<T_func, lambda_group2<T_arg1, T_arg2> > >
operator % (const T_func& _A_func, const lambda_group2<T_arg1, T_arg2>& _A_group)
{ 
  typedef lambda_call<T_func, lambda_group2<T_arg1, T_arg2> > T_lambda;
  return lambda<T_lambda>(T_lambda(_A_func, _A_group) ); 
}

template <class T_type1>
inline lambda_group1<T_type1> grp(T_type1 _A_1)
{ return lambda_group1<T_type1>(_A_1); }
template <class T_type1, class T_type2>
inline lambda_group2<T_type1, T_type2> grp(T_type1 _A_1, T_type2 _A_2)
{ return lambda_group2<T_type1, T_type2>(_A_1, _A_2); }

} /* namespace sigc */
