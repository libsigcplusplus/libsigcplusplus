dnl Copyright 2003, The libsigc++ Development Team 
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

define([RETYPE_OPERATOR],[dnl
ifelse($1,0,[dnl
  result_type operator()();
],[dnl
  template <LOOP(class T_arg%1, $1)>
  typename deduce_result_type<LOOP(T_arg%1,$1)>::type
  operator()(LOOP(T_arg%1 _A_a%1, $1))
    { return this->functor_.LIBSIGC_TEMPLATE_PREFIX operator()<LOOP(typename type_trait<T_type%1>::take, $1)>
        (LOOP([[(T_type%1)_A_a%1]], $1));
    }
])dnl
])
define([RETYPE_POINTER_FUNCTOR],[dnl
template <LIST(LOOP(class T_arg%1, $1), class T_return)>
inline retype_functor<LIST(pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)>, LOOP(T_arg%1, $1)) >
retype(const pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)>& _A_functor)
{ return retype_functor<LIST(pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)>, LOOP(T_arg%1, $1)) >
    (_A_functor); }

])
define([RETYPE_MEM_FUNCTOR],[dnl
template <LIST(class T_return, class T_obj, LOOP(class T_arg%1, $1))>
inline retype_functor<LIST($2[]mem_functor$1<LIST(T_return, T_obj, LOOP(T_arg%1, $1))>, LOOP(T_arg%1, $1)) >
retype(const $2[]mem_functor$1<LIST(T_return, T_obj, LOOP(T_arg%1, $1))>& _A_functor)
{ return retype_functor<LIST($2[]mem_functor$1<LIST(T_return, T_obj, LOOP(T_arg%1, $1))>, LOOP(T_arg%1, $1)) >
    (_A_functor); }

])

divert(0)dnl
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/slot.h>

namespace sigc {

template <LIST(class T_functor, LOOP(class T_type%1=nil, CALL_SIZE))>
struct retype_functor
  : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;

  template <LOOP(class T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
    { typedef typename adaptor_type::template deduce_result_type<LOOP(_P_(T_arg%1),CALL_SIZE)>::type type; };
  typedef typename adapts<T_functor>::result_type result_type;

FOR(0,CALL_SIZE,[[RETYPE_OPERATOR(%1)]])dnl

  retype_functor(typename type_trait<T_functor>::take _A_functor)
    : adapts<T_functor>(_A_functor)
    {}
};

template <LIST(class T_functor, LOOP(class T_type%1, CALL_SIZE))>
typename retype_functor<LIST(T_functor, LOOP(T_type%1, CALL_SIZE))>::result_type
retype_functor<LIST(T_functor, LOOP(T_type%1, CALL_SIZE))>::operator()()
  { return this->functor_(); }


template <LIST(class T_action, class T_functor, LOOP(class T_type%1, CALL_SIZE))>
void visit_each(const T_action& _A_action,
                const retype_functor<LIST(T_functor, LOOP(T_type%1, CALL_SIZE))>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
}


template <LIST(class T_return, LOOP(class T_arg%1, CALL_SIZE))>
inline retype_functor<LIST(slot<LIST(T_return, LOOP(T_arg%1, CALL_SIZE))>, LOOP(T_arg%1, CALL_SIZE)) >
retype(const slot<LIST(T_return, LOOP(T_arg%1, CALL_SIZE))>& _A_functor)
{ return retype_functor<LIST(slot<LIST(T_return, LOOP(T_arg%1, CALL_SIZE))>, LOOP(T_arg%1, CALL_SIZE)) >
    (_A_functor); }


FOR(0,CALL_SIZE,[[RETYPE_POINTER_FUNCTOR(%1)]])dnl

FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[])]])dnl
FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[const_])]])dnl
FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[volatile_])]])dnl
FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[const_volatile_])]])dnl
FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[bound_])]])dnl
FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[bound_const_])]])dnl
FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[bound_volatile_])]])dnl
FOR(0,CALL_SIZE,[[RETYPE_MEM_FUNCTOR(%1,[bound_const_volatile_])]])dnl

} /* namespace sigc */
