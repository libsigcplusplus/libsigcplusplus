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
 *   #include <sigc++/slot.h>
 *   void foo(int) {}
 *   SigC::Slot1<void, long> s = SigC::slot(&foo);
 *   s(19);
 *   @endcode
 *
 * @deprecated Use the unnumbered template sigc::slot instead.
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>
class Slot$1
  : public ::sigc::slot<LIST(T_return, LOOP(T_arg%1, $1))>
{
public:
  typedef ::sigc::slot<LIST(T_return, LOOP(T_arg%1, $1))> parent_type;

  /// Constructs an empty slot.
  Slot$1() {}

  /** Constructs a slot from an arbitrary functor.
   * @param _A_func The desired functor the new slot should be assigned to.
   */
  template <class T_functor>
  Slot$1(const T_functor& _A_func)
    : ::sigc::slot<LIST(T_return, LOOP(T_arg%1,$1))>(_A_func) {}

  /** Constructs a slot, copying an existing one.
   * @param src The existing slot to copy.
   */
  Slot$1(const parent_type& src)
    : parent_type(src) {}

  /** Overrides this slot making a copy from another slot.
   * @param src The slot from which to make a copy.
   * @return @p this.
   */
  Slot$1& operator=(const parent_type& src)
    { parent_type::operator=(src); return *this; }
};

])
define([SLOT_PTR_FUN],[dnl
/** Creates a functor of type SigC::Slot$1 that wraps an existing non-member function.
 *
 * @param _A_func Pointer to function that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @deprecated Use sigc::ptr_fun() instead.
 * @ingroup compat
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>
inline Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
slot[]ifelse($2,, $1)(T_return (*_A_func)(LOOP(T_arg%1,$1)))
{ return Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>(_A_func); }

])


divert(0)

__FIREWALL__

#include <sigc++/functors/slot.h>

#ifndef LIBSIGC_DISABLE_DEPRECATED

namespace SigC {

// SlotN
FOR(0,CALL_SIZE,[[SLOT_N(%1)]])

#ifndef DOXYGEN_SHOULD_SKIP_THIS
/* gcc 3.2 reports a strange conflict between SigC::slot() and sigc::slot<>
 * when "using namespace SigC" and later using a slot(obj,func) overload
 * without the prefix "SigC::". Probably a compiler bug. I will investigate.
 *
 * This ugly hack avoids the error:
 */
// #define slot(...) make_slot(__VA_ARGS__) /* only works for gcc */
#endif


// slot()
FOR(0,CALL_SIZE,[[SLOT_PTR_FUN(%1,1)]])

}

#endif
