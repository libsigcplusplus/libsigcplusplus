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


divert(0)dnl
_FIREWALL([ADAPTORS_BIND_RETURN])
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/adaptors/bound_argument.h>

namespace sigc {

/** Adaptor that fixes the return value of the wrapped functor.
 * Use the convenience function sigc::bind_return() to create an instance of sigc::bind_return_functor.
 *
 * The following template arguments are used:
 * - @e T_return Type of the fixed return value.
 * - @e T_functor Type of the functor to wrap.
 *
 * @ingroup bind
 */
template <class T_return, class T_functor>
struct bind_return_functor : public adapts<T_functor>
{
#ifndef DOXYGEN_SHOULD_SKIP_THIS
  template <class... T_arg>
  struct deduce_result_type
    { typedef typename unwrap_reference<T_return>::type type; };
#endif
  typedef typename unwrap_reference<T_return>::type result_type;

  /** Invokes the wrapped functor dropping its return value.
   * @return The fixed return value.
   */
  typename unwrap_reference<T_return>::type operator()();


  /** Invokes the wrapped functor passing on the arguments.
   * @param _A_a... Arguments to be passed on to the functor.
   * @return The fixed return value.
   */
  template <class... T_arg>
  inline typename unwrap_reference<T_return>::type operator()(T_arg... _A_a)
    { this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<type_trait_pass_t<T_arg>...>
        (_A_a...); return ret_value_.invoke();
    }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <class... T_arg>
  inline typename unwrap_reference<T_return>::type sun_forte_workaround(T_arg... _A_a)
    { this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<type_trait_pass_t<T_arg>...>
        (_A_a...); return ret_value_.invoke();
    }
  #endif


  /** Constructs a bind_return_functor object that fixes the return value to @p _A_ret_value.
   * @param _A_functor Functor to invoke from operator()().
   * @param _A_ret_value Value to return from operator()().
   */
  bind_return_functor(_R_(T_functor) _A_functor, _R_(T_return) _A_ret_value)
    : adapts<T_functor>(_A_functor), ret_value_(_A_ret_value)
    {}

  /// The fixed return value.
  bound_argument<T_return> ret_value_; // public, so that visit_each() can access it
};

template <class T_return, class T_functor>
typename unwrap_reference<T_return>::type bind_return_functor<T_return, T_functor>::operator()()
  { this->functor_(); return ret_value_.invoke(); }

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::bind_return_functor performs a functor on the
 * functor and on the object instance stored in the sigc::bind_return_functor object.
 *
 * @ingroup bind
 */
template <class T_return, class T_functor>
struct visitor<bind_return_functor<T_return, T_functor> >
{
  template <class T_action>
  static void do_visit_each(const T_action& _A_action,
                            const bind_return_functor<T_return, T_functor>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.ret_value_);
    sigc::visit_each(_A_action, _A_target.functor_);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

/** Creates an adaptor of type sigc::bind_return_functor which fixes the return value of the passed functor to the passed argument.
 *
 * @param _A_functor Functor that should be wrapped.
 * @param _A_ret_value Argument to fix the return value of @e _A_functor to.
 * @return Adaptor that executes @e _A_functor on invokation and returns @e _A_ret_value.
 *
 * @ingroup bind
 */
template <class T_return, class T_functor>
inline bind_return_functor<T_return, T_functor>
bind_return(const T_functor& _A_functor, T_return _A_ret_value)
{ return bind_return_functor<T_return, T_functor>(_A_functor, _A_ret_value); }

} /* namespace sigc */
