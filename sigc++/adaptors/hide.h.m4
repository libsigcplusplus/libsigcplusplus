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

define([HIDE_FUNCTOR],[dnl
template <class T_functor>
struct hide_functor <$1, T_functor> : public adapts<T_functor>
{
FOR($1,CALL_SIZE,[[HIDE_OPERATOR($1,%1)]])
  hide_functor()
    {}
  hide_functor(const T_functor& _A_func)
    : adapts<T_functor>(_A_func)
    {}
};

])
define([HIDE_OPERATOR],[dnl
ifelse($2,0,,[dnl
  template <LOOP([class T_arg%1], $2)>
ifelse($1,0,[dnl
  ifelse($2,1,[void],[typename callof<LIST(T_functor,FOR(1,eval($2-1),[T_arg%1,]))>::result_type])
  operator()(LOOP(T_arg%1 _A_a%1, $2))
    { return functor_(LIST(FOR(1,eval($2-1),[_A_a%1,]))); }
], $2,1,[dnl
  void // FIXME 0 arguments does not work
  operator()(LOOP(T_arg%1 _A_a%1, $2))
    { functor_(LIST(FOR(1,eval($1-1),[_A_a%1,]),FOR(eval($1+1), $2,[_A_a%1,]))); }
],[dnl
  typename callof<LIST(T_functor,FOR(1,eval($1-1),[T_arg%1,]),FOR(eval($1+1), $2,[T_arg%1,]))>::result_type
  operator()(LOOP(T_arg%1 _A_a%1, $2))
    { return functor_(LIST(FOR(1,eval($1-1),[_A_a%1,]),FOR(eval($1+1), $2,[_A_a%1,]))); }
])])dnl
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
namespace functor {

template <int I_location, class T_functor>
class hide_functor;

FOR(0,CALL_SIZE,[[HIDE_FUNCTOR(%1)]])

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

} /* namespace functor */
} /* namespace sigc */

