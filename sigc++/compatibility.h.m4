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

define([SIGNAL_N],[dnl
/** Signal declaration.
 * Signal$1 can be used to connect() slots that are invoked
 * during subsequent calls to emit(). Any functor or slot
 * can be passed into connect(). It is converted into a slot
 * implicitely.
 *
 * An STL-style list interface for the signal's list of slots
 * can be retrieved with slots(). This interface supports
 * iteration, insertion and removal of slots.
 *
 * The following template arguments are used:
 * - @e T_return The desired return type for the emit() function (may be overridden by the accumulator).dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of emit().])
 * - @e T_accumulator The accumulator type used for emission. The default nil means that no accumulator should be used. Signal emission returns the return value of the last slot invoked.
 *
 * This class is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::signal<> instead.
 *
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_accumulator=::sigc::nil)>
class Signal$1
  : public ::sigc::signal$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)>
{
public:
  Signal$1() {}
  Signal$1(const Signal$1& src)
    : ::sigc::signal$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)>(src) {}
};

])
define([SLOT_N],[dnl
/** Converts an arbitrary functor to a unified type which is opaque.
 * Slot$1 itself is a functor or to be more precise a closure. It contains
 * a single, arbitrary functor (or closure) that is executed in operator()().
 *
 * The template arguments determine the function signature of operator()():
 * - @e T_return The return type of operator()().dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 *
 * To use simply assign the slot to the desired functor. If the functor
 * is not compatible with the parameter list defined with the template
 * arguments compiler errors are triggered. When called the slot
 * will invoke the functor with minimal copies.
 * block() and unblock() can be used to block the functor's invocation
 * from operator()() temporarily.
 *
 * @par Example:
 *   @code
 *   #include <sigc++/compatibility.h>
 *   void foo(int) {}
 *   SigC::Slot1<void, long> s = SigC::slot(&foo);
 *   s(19);
 *   @endcode
 *
 * This class is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::signal<> instead.
 *
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>
class Slot$1
  : public ::sigc::slot<LIST(T_return, LOOP(T_arg%1, $1))>
{
public:
  /// Constructs an empty slot.
  Slot$1() {}

  /** Constructs a slot from an arbitrary functor.
   * @param _A_func The desirer functor the new slot should be assigned to.
   */
  template <class T_functor>
  Slot$1(const T_functor& _A_func)
    : ::sigc::slot<LIST(T_return, LOOP(T_arg%1,$1))>(_A_func) {}
};

])
define([PTR_FUN],[dnl
/** Creates a functor of type pointer_functor$1 which wraps an existing non-member function.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::ptr_fun() instead.
 *
 * @param _A_func Pointer to function that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return)>
inline ::sigc::pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)> 
slot[]ifelse($2,, $1)(T_return (*_A_func)(LOOP(T_arg%1,$1)))
{ return ::sigc::pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)>(_A_func); }

])
define([MEM_FUN],[dnl
/** Creates a functor of type mem_functor$1 which wraps a method.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return ::sigc::mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type const_mem_functor$1 which wraps a const method.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return ::sigc::const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type volatile_functor$1 which wraps a volatile method.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return ::sigc::volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type const_volatile_mem_functor$1 which wraps a const volatile method.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return ::sigc::const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type bound_mem_functor$1 which encapsulates a method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return ::sigc::bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

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
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return ::sigc::bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_const_mem_functor$1 which encapsulates a const method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(const T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return ::sigc::bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

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
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(const T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return ::sigc::bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_volatile_mem_functor$1 which encapsulates a volatile method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return ::sigc::bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

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
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return ::sigc::bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_const_volatile_mem_functor$1 which encapsulates a const volatile method and an object instance.
 *
 * This function is part of the compatibility module and therefore deprecated.
 * Use the unnumbered template sigc::mem_fun() instead.
 *
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup compat
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(const T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return ::sigc::bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

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
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline ::sigc::bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
slot[]ifelse($2,, $1)(const T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return ::sigc::bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }
])


divert(0)

__FIREWALL__

#include <sigc++/sigc++.h>

#ifndef LIBSIGC_DISABLE_DEPRECATED

namespace SigC {

// Object
typedef ::sigc::trackable Object;


// SignalN
FOR(0,CALL_SIZE,[[SIGNAL_N(%1)]])

// SlotN
FOR(0,CALL_SIZE,[[SLOT_N(%1)]])

#ifndef DOXYGEN_SHOULD_SKIP_THIS
/* gcc 3.2 reports a strange conflict between SigC::slot() and sigc::slot<>
 * when "using namespace SigC" and later using a slot(obj,func) overload
 * without the prefix "SigC::". Probably a compiler bug. I will investigate.
 *
 * This ugly hack avoids the error:
 */
#define slot(...) make_slot(__VA_ARGS__)
#endif


// slot()
FOR(0,CALL_SIZE,[[PTR_FUN(%1,1)]])
FOR(0,CALL_SIZE,[[MEM_FUN(%1,1)]])

}

#endif
