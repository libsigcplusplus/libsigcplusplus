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

define([SLOT_MEM_FUN],[dnl
/** Creates a functor of type mem_functor$1 which wraps a method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj)>
inline Slot[]eval($1+1)<LIST(T_return, T_obj&, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return Slot[]eval($1+1)<LIST(T_return, T_obj&, LOOP(T_arg%1, $1))>
    (::sigc::mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func)); }

/** Creates a functor of type const_mem_functor$1 which wraps a const method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj)>
inline Slot[]eval($1+1)<LIST(T_return, const T_obj&, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return Slot[]eval($1+1)<LIST(T_return, const T_obj&, LOOP(T_arg%1, $1))>
    (::sigc::const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func)); }

/** Creates a functor of type volatile_functor$1 which wraps a volatile method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj)>
inline Slot[]eval($1+1)<LIST(T_return, T_obj&, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return Slot[]eval($1+1)<LIST(T_return, T_obj&, LOOP(T_arg%1, $1))>
    (::sigc::volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func)); }

/** Creates a functor of type const_volatile_mem_functor$1 which wraps a const volatile method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj)>
inline Slot[]eval($1+1)<LIST(T_return, const T_obj&, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return Slot[]eval($1+1)<LIST(T_return, const T_obj&, LOOP(T_arg%1, $1))>
    (::sigc::const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func)); }

])


divert(0)

__FIREWALL__

#include <sigc++/slot.h>

#ifndef LIBSIGC_DISABLE_DEPRECATED

namespace SigC {

FOR(0,eval(CALL_SIZE-1),[[SLOT_MEM_FUN(%1,1)]])

}

#endif
