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

divert(0)
_FIREWALL([FUNCTORS_PTR_FUN])
#include <sigc++/type_traits.h>
#include <sigc++/functors/functor_trait.h>

namespace sigc {

/** @defgroup ptr_fun ptr_fun()
 * ptr_fun() is used to convert a pointer to a function to a functor.
 * If the function pointer is to an overloaded type, you must specify
 * the types using template arguments starting with the first argument.
 * It is not necessary to supply the return type.
 *
 * @par Example:
 * @code
 * void foo(int) {}
 * sigc::slot<void, int> sl = sigc::ptr_fun(&foo);
 * @endcode
 *
 * @par Example:
 * @code
 * void foo(int) {}  // choose this one
 * void foo(float) {}
 * void foo(int, int) {}
 * sigc::slot<void, long> sl = sigc::ptr_fun<void, int>(&foo);
 * @endcode
 *
 * ptr_fun() can also be used to convert a pointer to a static member
 * function to a functor, like so:
 *
 * @par Example:
 * @code
 * struct foo
 * {
 *   static void bar(int) {}
 * };
 * sigc::slot<void, int> sl = sigc::ptr_fun(&foo::bar);
 * @endcode
 *
 * @ingroup sigcfunctors
 */

/** pointer_functor wraps existing non-member functions with, or without, arguments.
 * Use the convenience function ptr_fun() to create an instance of pointer_functor.
 *
 * The following template arguments are used:
 * - @e T_args... Argument types used in the definition of operator()().
 * - @e T_return The return type of operator()().
 *
 * @ingroup ptr_fun
 */
template <class T_return, class... T_args>
class pointer_functor : public functor_base
{
  using function_type = T_return (*)(T_args...);
protected: 
  function_type func_ptr_;
public:
  using result_type = T_return;

  /// Constructs an invalid functor.
  pointer_functor() {}

  /** Constructs a pointer_functor2 object that wraps an existing function.
   * @param _A_func Pointer to function that will be invoked from operator()().
   */
  explicit pointer_functor(function_type _A_func): func_ptr_(_A_func) {}

  /** Execute the wrapped function.
   * @param _A_a1 Argument to be passed on to the function.
   * @param _A_a2 Argument to be passed on to the function.
   * @return The return value of the function invocation.
   */
  T_return operator()(type_trait_take_t<T_args>... _A_a) const 
    { return func_ptr_(_A_a...); }
};

/** Creates a functor of type sigc::pointer_functor which wraps an existing non-member function.
 * @param _A_func Pointer to function that should be wrapped.
 * @return Functor that executes @e _A_func on invokation.
 *
 * @ingroup ptr_fun
 */
template <class T_return, class... T_args>
inline pointer_functor<T_return, T_args...> 
ptr_fun(T_return (*_A_func)(T_args...))
{ return pointer_functor<T_return, T_args...>(_A_func); }

} /* namespace sigc */
