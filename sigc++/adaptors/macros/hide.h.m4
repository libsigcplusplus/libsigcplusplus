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

define([ORDINAL],[dnl
ifelse($1,0,,$1)ifelse($1,0,[last],$1,1,[st],$1,2,[nd],$1,3,[rd],[th])[]dnl
])

])])dnl
])dnl end HIDE_OPERATOR

define([HIDE_FUNCTOR],[dnl
ifelse($1,1,[#ifndef DOXYGEN_SHOULD_SKIP_THIS
],)dnl Include only the first two template specializations in the documentation. ($1 = -1..CALL_SIZE-1)
/** Adaptor that adds a dummy parameter to the wrapped functor.
 * This template specialization ignores the value of the ORDINAL(eval($1+1)) parameter in operator()().
 *
 * @ingroup hide
 */
template <class T_functor>
struct hide_functor <$1, T_functor> : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;
  typedef typename adaptor_type::result_type  result_type;

  /** Invokes the wrapped functor, ignoring the ORDINAL($1) argument.dnl
   * @param _A_a Arguments to be passed on to the functor, apart from the ORDINAL($1) argument.
   * @return The return value of the functor invocation.
   */
  template <class... T_arg>
  decltype(auto)
  operator()(T_arg... _A_a)
    {
       constexpr auto size = sizeof...(T_arg);
       constexpr auto index_ignore = ($1 == -1 ? size - 1 : $1);
       const auto t = std::make_tuple(_A_a...);

       const auto t_start = tuple_start<index_ignore>(t);
       const auto t_end = tuple_end<size - index_ignore - 1>(t);
       auto t_used = std::tuple_cat(t_start, t_end); //TODO: Let this be const?

       //This is so we can specify a particular instantiation of the functor's
       //operator().
       //TODO: Avoid this if it no longer necessary.
       using t_type = std::tuple<type_trait_pass_t<T_arg>...>;
       using t_type_start = typename tuple_type_start<t_type, index_ignore>::type;
       using t_type_end = typename tuple_type_end<t_type, size - index_ignore - 1>::type;
       using t_type_used = typename tuple_type_cat<t_type_start, t_type_end>::type;

       constexpr auto size_used = size - 1;

       //TODO: Remove these? They are just here as a sanity check.
       static_assert(std::tuple_size<t_type_used>::value == size_used, "Unexpected t_type_used size.");
       static_assert(std::tuple_size<decltype(t_used)>::value == size_used, "Unexpected t_used size.");

       const auto seq = std::make_index_sequence<size_used>();
       return call_functor_operator_parentheses<t_type_used>(t_used, seq);
    }

  /** Constructs a hide_functor object that adds a dummy parameter to the passed functor.
   * @param _A_func Functor to invoke from operator()().
   */
  explicit hide_functor(const T_functor& _A_func)
    : adapts<T_functor>(_A_func)
    {}

private:
  //TODO_variadic: Replace this with std::experimental::apply() if that becomes standard
  //C++, or add our own implementation, to avoid code duplication.
  template<class T_tuple_specific, class T_tuple, std::size_t... Is>
  decltype(auto)
  call_functor_operator_parentheses(T_tuple& tuple,
    std::index_sequence<Is...>)
  {
    return this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<typename std::tuple_element<Is, T_tuple_specific>::type...>(std::get<Is>(tuple)...);
  }
};
ifelse($1,eval(CALL_SIZE-1),[#endif // DOXYGEN_SHOULD_SKIP_THIS
],)dnl Include only the first two template specializations in the documentation. ($1 = -1..CALL_SIZE-1)

])dnl end HIDE_FUNCTOR

divert(0)dnl
_FIREWALL([ADAPTORS_HIDE])
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/tuple_cat.h>
#include <sigc++/tuple_end.h>
#include <sigc++/tuple_start.h>

namespace sigc {

/** @defgroup hide hide(), hide_return()
 * sigc::hide() alters an arbitrary functor in that it adds a parameter
 * whose value is ignored on invocation of the returned functor.
 * Thus you can discard one argument of a signal.
 *
 * You may optionally specify the zero-based position of the parameter
 * to ignore as a template argument. The default is to ignore the last
 * parameter.
 * (A value of @p -1 adds a parameter at the end so sigc::hide<-1>() gives the same result as sigc::hide().)
 *
 * The type of the parameter can optionally be specified if not deduced.
 *
 * @par Examples:
 * @code
 * void foo(int, int);
 * // single argument hiding ...
 * sigc::hide(&foo)(1,2,3);     // adds a dummy parameter at the back and calls foo(1,2)
 * sigc::hide<-1>(&foo)(1,2,3); // same as sigc::hide(&foo)(1,2,3) (calls foo(1,2))
 * sigc::hide<0>(&foo)(1,2,3);  // adds a dummy parameter at the beginning and calls foo(2,3)
 * sigc::hide<1>(&foo)(1,2,3);  // adds a dummy parameter in the middle and calls foo(1,3)
 * sigc::hide<2>(&foo)(1,2,3);  // adds a dummy parameter at the back and calls foo(1,2)
 * @endcode
 *
 * The functor sigc::hide() returns can be directly passed into
 * sigc::signal::connect().
 *
 * @par Example:
 * @code
 * sigc::signal<void,int> some_signal;
 * void foo();
 * some_signal.connect(sigc::hide(&foo));
 * @endcode
 *
 * sigc::hide() can be nested in order to discard multiple arguments.
 * @par Example:
 * @code
 * // multiple argument hiding ...
 * sigc::hide(sigc::hide(&foo))(1,2,3,4); // adds two dummy parameters at the back and calls foo(1,2)
 * @endcode

 * sigc::hide_return() alters an arbitrary functor by
 * dropping its return value, thus converting it to a void functor.
 *
 * @ingroup adaptors
 */

/** Adaptor that adds a dummy parameter to the wrapped functor.
 * Use the convenience function sigc::hide() to create an instance of sigc::hide_functor.
 *
 * The following template arguments are used:
 * - @e I_location Zero-based position of the dummy parameter (@p -1 for the last parameter).
 * - @e T_type Type of the dummy parameter.
 * - @e T_functor Type of the functor to wrap.
 *
 * @ingroup hide
 */
template <int I_location, class T_functor>
#ifndef DOXYGEN_SHOULD_SKIP_THIS
struct hide_functor;
#else
struct hide_functor {};
#endif

FOR(-1,eval(CALL_SIZE-1),[[HIDE_FUNCTOR(%1)]])dnl

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::hide_functor performs a functor on the
 * functor stored in the sigc::hide_functor object.
 *
 * @ingroup hide
 */
template <int I_location, class T_functor>
struct visitor<hide_functor<I_location, T_functor> >
{
  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const hide_functor<I_location, T_functor>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

/** Creates an adaptor of type sigc::hide_functor which adds a dummy parameter to the passed functor.
 * The optional template argument @e I_location specifies the zero-based
 * position of the dummy parameter in the returned functor (@p -1 stands for the last parameter).
 *
 * @param _A_func Functor that should be wrapped.
 * @return Adaptor that executes @e _A_func, ignoring the value of the dummy parameter.
 *
 * @ingroup hide
 */
template <int I_location, class T_functor>
inline hide_functor<I_location, T_functor>
hide(const T_functor& _A_func)
  { return hide_functor<I_location, T_functor>(_A_func); }

/** Creates an adaptor of type sigc::hide_functor which adds a dummy parameter to the passed functor.
 * This overload adds a dummy parameter at the back of the functor's parameter list.
 *
 * @param _A_func Functor that should be wrapped.
 * @return Adaptor that executes @e _A_func, ignoring the value of the last parameter.
 *
 * @ingroup hide
 */
template <class T_functor>
inline hide_functor<-1, T_functor>
hide(const T_functor& _A_func)
  { return hide_functor<-1, T_functor> (_A_func); }

} /* namespace sigc */
