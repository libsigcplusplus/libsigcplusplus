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

define([DEDUCE_RESULT_TYPE],[dnl
  template <LOOP(class T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
ifelse($1,0,[dnl
    { typedef typename adaptor_type::deduce_result_type<LOOP(_P_(T_arg%1),eval($2-1))>::type type; };
],[dnl
    { typedef typename adaptor_type::deduce_result_type<LIST(LOOP(_P_(T_arg%1),eval($1-1)), FOR(eval($1+1),$2,[_P_(T_arg%1),]))>::type type; };
])dnl
])
define([HIDE_OPERATOR],[dnl
ifelse($2,0,,[dnl
ifelse($2,1,[dnl
  template <class T_arg1>
  typename deduce_result_type<T_arg1>::type
  operator()(T_arg1 _A_a1)
    { return functor_(); }

],$1,0,[dnl
  template <LOOP([class T_arg%1], $2)>
  typename deduce_result_type<LOOP(T_arg%1, $2)>::type
  operator()(LOOP(T_arg%1 _A_a%1, $2))
    { return functor_.LIBSIGC_TEMPLATE_PREFIX operator() <LIST(FOR(1,eval($2-1),[_P_(T_arg%1),]))>
        (LIST(FOR(1,eval($2-1),[_A_a%1,]))); }

],[dnl
  template <LOOP([class T_arg%1], $2)>
  typename deduce_result_type<LOOP(T_arg%1, $2)>::type
  operator()(LOOP(T_arg%1 _A_a%1, $2))
    { return functor_.LIBSIGC_TEMPLATE_PREFIX operator() <LIST(FOR(1,eval($1-1),[_P_(T_arg%1),]),FOR(eval($1+1), $2,[_P_(T_arg%1),]))>
        (LIST(FOR(1,eval($1-1),[_A_a%1,]),FOR(eval($1+1), $2,[_A_a%1,]))); }

])])dnl
])
define([HIDE_FUNCTOR],[dnl
template <class T_functor>
struct hide_functor <$1, T_functor> : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;

DEDUCE_RESULT_TYPE($1,CALL_SIZE)dnl
  typedef typename adaptor_type::result_type  result_type;

FOR($1,CALL_SIZE,[[HIDE_OPERATOR($1,%1)]])dnl
  hide_functor()
    {}
  hide_functor(const T_functor& _A_func)
    : adapts<T_functor>(_A_func)
    {}
};

])

divert(0)dnl
/*
  functor adaptor:  hide<#>(functor)
  usage:
    This converter takes a functor and hides a parameter in effect
  ignoring that value.  The argument number is specified 
  by the non-optional integer template argument.  An argument of
  0 hides the last argument automatically.
                    
    void foo (int, int);
    hide<0>(&foo)(1,2,3) -> calls foo(1,2);
    hide<1>(&foo)(1,2,3) -> calls foo(2,3);
                                
  For a more powerful version of this functionality see the 
  lamda library "call" adaptor which can bind, reorder and 
  hide arguments in one statement.
    
*/
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc { 

template <int I_location, class T_functor>
struct hide_functor;

FOR(0,CALL_SIZE,[[HIDE_FUNCTOR(%1)]])dnl

template <class T_action, int I_location, class T_functor>
void visit_each(const T_action& _A_action,
                const hide_functor<I_location, T_functor>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
}


template <int I_location, class T_functor>
inline hide_functor<I_location, T_functor>
hide(const T_functor& _A_func)
{ 
  return hide_functor<I_location, T_functor>
           (_A_func);
}

} /* namespace sigc */
