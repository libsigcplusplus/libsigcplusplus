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
/** Creates a functor of type bound_mem_functor$1 which encapsulates a method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj1, class T_obj2)>
inline Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(T_obj1& _A_obj, T_return (T_obj2::*_A_func)(LOOP(T_arg%1,$1)))
{ return Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
    (::sigc::bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj2)>
      (static_cast<T_obj1&>(static_cast<Object&>(_A_obj)), _A_func)); }

/** Creates a functor of type bound_const_mem_functor$1 which encapsulates a const method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj1, class T_obj2)>
inline Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(const T_obj1& _A_obj, T_return (T_obj2::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
    (::sigc::bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj2)>
      (static_cast<const T_obj1&>(static_cast<const Object&>(_A_obj)), _A_func)); }

/** Creates a functor of type bound_volatile_mem_functor$1 which encapsulates a volatile method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj1, class T_obj2)>
inline Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(T_obj1& _A_obj, T_return (T_obj2::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
    (::sigc::bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj2)>
      (static_cast<T_obj1&>(static_cast<Object&>(_A_obj)), _A_func)); }

/** Creates a functor of type bound_const_volatile_mem_functor$1 which encapsulates a const volatile method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_obj1, class T_obj2)>
inline Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(const T_obj1& _A_obj, T_return (T_obj2::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
    (::sigc::bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj2)>
      (static_cast<const T_obj1&>(static_cast<const Object&>(_A_obj)), _A_func)); }
])


divert(0)

__FIREWALL__

#include <sigc++/slot.h>
#include <sigc++/object.h>

#ifndef LIBSIGC_DISABLE_DEPRECATED

namespace SigC {

FOR(0,CALL_SIZE,[[SLOT_MEM_FUN(%1,1)]])

}

#endif
