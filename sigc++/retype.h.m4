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

define([RETYPE_SLOT_OPERATOR],[dnl
ifelse($1,0,[dnl
  T_return operator()();
],[dnl
  template <LOOP(class T_arg%1, $1)>
  inline T_return operator()(LOOP(T_arg%1 _A_a%1, $1))
    { return T_return(functor_.template operator()<LOOP(typename ::sigc::type_trait<T_type%1>::take, $1)>
        (LOOP([[(T_type%1)_A_a%1]], $1)));
    }
])dnl
])
define([RETYPE_SLOT_VOID_OPERATOR],[dnl
ifelse($1,0,[dnl
  void operator()();
],[dnl
  template <LOOP(class T_arg%1, $1)>
  inline void operator()(LOOP(T_arg%1 _A_a%1, $1))
    { T_return(functor_.template operator()<LOOP(typename ::sigc::type_trait<T_type%1>::take, $1)>
        (LOOP([[(T_type%1)_A_a%1]], $1)));
    }
])dnl
])
define([RETYPE_SLOT_FUNCTOR],[dnl
ifelse($1,$2,[dnl
template <LIST(class T_functor, class T_return, LOOP(class T_type%1 = ::sigc::nil, $1))>],[dnl
template <LIST(class T_functor, class T_return, LOOP(class T_type%1, $1))>])
struct retype_slot_functor ifelse($1,$2,,[<LIST(T_functor, T_return, LOOP(T_type%1, $1))>])
  : public ::sigc::adapts<T_functor>
{
  template <LOOP(class T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
    { typedef T_return type; };
  typedef T_return result_type;

dnl   T_return operator()();
dnl 
dnl FOR(1,$1,[[RETYPE_SLOT_OPERATOR(%1)]])dnl
RETYPE_SLOT_OPERATOR($1)
   retype_slot_functor(typename ::sigc::type_trait<T_functor>::take _A_functor)
    : ::sigc::adapts<T_functor>(_A_functor)
    {}
};
ifelse($1,0,[dnl

template <LIST(class T_functor, class T_return, LOOP(class T_type%1, $1))>
T_return retype_slot_functor<LIST(T_functor, T_return, LOOP(T_type%1, $1))>::operator()()
  { return T_return(functor_()); }
])dnl

// void specialization needed because of explicit cast to T_return
template <LIST(class T_functor, LOOP(class T_type%1, $1))>
struct retype_slot_functor<LIST(T_functor, void, LOOP(T_type%1, $1))>
  : public ::sigc::adapts<T_functor>
{
  template <LOOP(class T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
    { typedef void type; };
  typedef void result_type;

dnl   void operator()();
dnl 
dnl FOR(1,$1,[[RETYPE_SLOT_VOID_OPERATOR(%1)]])dnl
RETYPE_SLOT_VOID_OPERATOR($1)
  retype_slot_functor(typename ::sigc::type_trait<T_functor>::take _A_functor)
    : ::sigc::adapts<T_functor>(_A_functor)
    {}
};
ifelse($1,0,[dnl

template <LIST(class T_functor, LOOP(class T_type%1, $1))>
void retype_slot_functor<LIST(T_functor, void, LOOP(T_type%1, $1))>::operator()()
  { functor_(); }
])dnl


])
define([RETYPE],[dnl
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_ret, LOOP(class T_type%1, $1))>
inline Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
retype(const Slot$1<LIST(T_ret, LOOP(T_type%1, $1))>& _A_slot)
{ return Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
    (retype_slot_functor<LIST(Slot$1<LIST(T_ret, LOOP(T_type%1, $1))>, T_return, LOOP(T_type%1, $1))>
      (_A_slot)); }

])

divert(0)dnl
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/slot.h>

#ifndef LIBSIGC_DISABLE_DEPRECATED

namespace SigC {

RETYPE_SLOT_FUNCTOR(CALL_SIZE, CALL_SIZE)dnl
FOR(0,eval(CALL_SIZE-1),[[RETYPE_SLOT_FUNCTOR(%1)]])dnl
dnl
template <LIST(class T_action, class T_functor, class T_return, LOOP(class T_type%1, CALL_SIZE))>
void visit_each(const T_action& _A_action,
                const retype_slot_functor<LIST(T_functor, T_return, LOOP(T_type%1, CALL_SIZE))>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
}


FOR(0,CALL_SIZE,[[RETYPE(%1)]])dnl

} /* namespace SigC */

#endif /* LIBSIGC_DISABLE_DEPRECATED */
