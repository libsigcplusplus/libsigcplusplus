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


define([RETYPE_MEM_FUNCTOR],[dnl
/** Creates an adaptor of type sigc::retype_functor which performs C-style casts on the parameters passed on to the functor.
 * This function template specialization works on sigc::$2[]mem_functor.
 *
 * @param _A_functor Functor that should be wrapped.
 * @return Adaptor that executes @e _A_functor performing C-style casts on the paramters passed on.
 *
 * @ingroup retype
 */
template <class T_return, class T_obj, class... T_arg>
inline decltype(auto)
retype(const $1[]mem_functor<T_return, T_obj, T_arg...>& _A_functor)
{ return retype_functor<LIST($1[]mem_functor<T_return, T_obj, T_arg...>, T_arg...) >
    (_A_functor); }

])

divert(0)dnl
_FIREWALL([ADAPTORS_RETYPE])
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/slot.h>

namespace sigc {

/** @defgroup retype retype(), retype_return()
 * sigc::retype() alters a sigc::pointer_functor, a sigc::mem_functor or a sigc::slot
 * in that it makes C-style casts to the functor's parameter types
 * of all parameters passed through operator()().
 *
 * Use this adaptor for inline conversion between numeric or other simple types.
 * @par Example:
 * @code
 * void foo(int);
 * sigc::retype(sigc::ptr_fun(&foo))(5.7F); // calls foo(5)
 * @endcode
 *
 * The functor that sigc::retype() returns can be passed directly into
 * sigc::signal::connect().
 *
 * @par Example:
 * @code
 * sigc::signal<void,float> some_signal;
 * void foo(int);
 * some_signal.connect(sigc::retype(sigc::ptr_fun(&foo)));
 * @endcode
 *
 * This adaptor builds an exception in that it only works on sig::pointer_functor,
 * sigc::mem_functor and sigc::slot because it needs sophisticated information about
 * the parameter types that cannot be deduced from arbitrary functor types.
 *
 * sigc::retype_return() alters the return type of an arbitrary functor.
 * Like in sigc::retype() a C-style cast is performed. Usage sigc::retype_return() is
 * not restricted to libsigc++ functor types but you need to
 * specify the new return type as a template parameter.
 *
 * @par Example:
 * @code
 * float foo();
 * std::cout << sigc::retype_return<int>(&foo)(); // converts foo's return value to an integer
 * @endcode
 *
 * @ingroup adaptors
 */

/** Adaptor that performs C-style casts on the parameters passed on to the functor.
 * Use the convenience function sigc::retype() to create an instance of retype_functor.
 *
 * The following template arguments are used:
 * - @e T_functor Type of the functor to wrap.
 * - @e T_type Types of @e T_functor's arguments.
 *
 * @ingroup retype
 */
template <class T_functor, class... T_type>
struct retype_functor
  : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;
  typedef typename adapts<T_functor>::result_type result_type;

 template <class... T_arg>
  decltype(auto)
  operator()(T_arg... _A_a)
    { return this->functor_.template operator()<type_trait_take_t<T_type>...>
        (static_cast<T_type>(_A_a)...);
    }

  /** Constructs a retype_functor object that performs C-style casts on the parameters passed on to the functor.
   * @param _A_functor Functor to invoke from operator()().
   */
  explicit retype_functor(type_trait_take_t<T_functor> _A_functor)
    : adapts<T_functor>(_A_functor)
    {}
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::retype_functor performs a functor on the
 * functor stored in the sigc::retype_functor object.
 *
 * @ingroup retype
 */
template <class T_functor, class... T_type>
struct visitor<retype_functor<T_functor, T_type...> >
{
  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const retype_functor<T_functor, T_type...>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

/** Creates an adaptor of type sigc::retype_functor which performs C-style casts on the parameters passed on to the functor.
 * This function template specialization works on sigc::slot.
 *
 * @param _A_functor Functor that should be wrapped.
 * @return Adaptor that executes @e _A_functor performing C-style casts on the paramters passed on.
 *
 * @ingroup retype
 */
template <LIST(class T_return, class... T_arg)>
inline decltype(auto)
retype(const slot<T_return, T_arg...>& _A_functor)
{ return retype_functor<slot<T_return, T_arg...>, T_arg...>
    (_A_functor); }


/** Creates an adaptor of type sigc::retype_functor which performs C-style casts on the parameters passed on to the functor.
 * This function template specialization works on sigc::pointer_functor.
 *
 * @param _A_functor Functor that should be wrapped.
 * @return Adaptor that executes @e _A_functor performing C-style casts on the paramters passed on.
 *
 * @ingroup retype
 */
template <class T_return, class... T_arg>
inline decltype(auto)
retype(const pointer_functor<T_return, T_arg...>& _A_functor)
{ return retype_functor<pointer_functor<T_return, T_arg...>, T_arg... >
    (_A_functor); }

RETYPE_MEM_FUNCTOR([])
RETYPE_MEM_FUNCTOR([const_])
RETYPE_MEM_FUNCTOR([volatile_])
RETYPE_MEM_FUNCTOR([const_volatile_])
RETYPE_MEM_FUNCTOR([bound_])
RETYPE_MEM_FUNCTOR([bound_const_])
RETYPE_MEM_FUNCTOR([bound_volatile_])
RETYPE_MEM_FUNCTOR([bound_const_volatile_])

} /* namespace sigc */

