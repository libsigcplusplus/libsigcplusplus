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

define([DEDUCE_RESULT_TYPE],[dnl
  template <LOOP(class T_arg%1,eval(CALL_SIZE-$2))>
  struct deduce_result_type<LIST(LOOP(T_arg%1,eval(CALL_SIZE-$2)))>
    { typedef typename adaptor_type::deduce_result_type<LIST(LOOP(_P_(T_arg%1),eval(CALL_SIZE-$2)), _P_(T_bound))>::type type; };
])
define([BIND_OPERATOR],[dnl
ifelse($2,0,[dnl
], $2,1,[dnl
dnl  typename internal::callof_safe1<adaptor_type>::result_type // leads to compiler errors if T_functor has an overloaded operator()!
dnl  operator()()
dnl    { return functor_.template operator()<_P_(T_bound)>
dnl        (bound_); 
dnl    }
dnl
], $1,0,[dnl
  /** Invokes the wrapped functor passing on the arguments.
   * bound_ is passed as the last ($2[]th) argument.dnl
FOR(1, eval($2-1),[
   * @param _A_arg%1 Argument to be passed on to the functor.])
   * @return The return value of the functor invocation.
   */
  template <LOOP([class T_arg%1],eval($2-1))>
  typename deduce_result_type<LOOP(T_arg%1,eval($2-1))>::type
  operator()(LOOP(T_arg%1 _A_arg%1,eval($2-1)))
    { return functor_.LIBSIGC_TEMPLATE_PREFIX operator()<LIST(LOOP([_P_(T_arg%1)],eval($2-1)), _P_(T_bound))>
        (LIST(LOOP(_A_arg%1,eval($2-1)), bound_)); 
    }

],[dnl
  /** Invokes the wrapped functor passing on the arguments.
   * bound_ is passed as the $1[]th argument.dnl
FOR(1, eval($2-1),[
   * @param _A_arg%1 Argument to be passed on to the functor.])
   * @return The return value of the functor invocation.
   */
  template <LOOP([class T_arg%1],eval($2-1))>
  typename deduce_result_type<LOOP(T_arg%1,eval($2-1))>::type
  operator()(LOOP(T_arg%1 _A_arg%1,eval($2-1)))
    { return functor_.LIBSIGC_TEMPLATE_PREFIX operator()<LIST(LOOP([_P_(T_arg%1)],eval($1-1)), _P_(T_bound),FOR($1,eval($2-1),[_P_(T_arg%1),]))>
        (LIST(LOOP(_A_arg%1,eval($1-1)), bound_,FOR($1,eval($2-1),[_A_arg%1,]))); 
    }

])dnl
])
define([BIND_FUNCTOR],[dnl
/** Adaptor that binds an argument to the wrapped functor.
 * This template specialization fixes the ifelse($1,0,last,$1[]th)
 * argument of the wrapped functor.
 *
 * @ingroup bind
 */
template <class T_bound, class T_functor>
struct bind_functor <$1, T_bound, T_functor> : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;

  template <LOOP(class T_arg%1=void, eval(CALL_SIZE))>
  struct deduce_result_type
ifelse($1,0,[dnl
    { typedef typename adaptor_type::deduce_result_type<LIST(LOOP(_P_(T_arg%1),eval(CALL_SIZE-1)), _P_(T_bound))>::type type; };
FOR(2,eval(CALL_SIZE-1),[[DEDUCE_RESULT_TYPE($1,%1)]])dnl
],[dnl
    { typedef typename adaptor_type::deduce_result_type<LIST(LOOP(_P_(T_arg%1),eval($1-1)), _P_(T_bound),FOR($1,eval(CALL_SIZE-1),[_P_(T_arg%1),]))>::type type; };
])dnl
  typedef typename adaptor_type::result_type  result_type;

  /** Invokes the wrapped functor passing on the bound argument only.
   * @return The return value of the functor invocation.
   */
  result_type
  operator()();

FOR($1,CALL_SIZE,[[BIND_OPERATOR($1,%1)]])dnl
  /** Constructs a bind_functor object that binds an argument to the passed functor.
   * @param _A_functor Functor to invoke from operator()().
   * @param _A_bound Argument to bind to the functor.
   */
  bind_functor(_R_(T_functor) _A_func, _R_(T_bound) _A_bound)
    : adapts<T_functor>(_A_func), bound_(_A_bound)
    {}

  /// The argument bound to the functor.
  T_bound bound_;
};

template <class T_bound, class T_functor>
typename bind_functor<$1, T_bound, T_functor>::result_type
bind_functor<$1, T_bound, T_functor>::operator()()
  { return functor_.LIBSIGC_TEMPLATE_PREFIX operator()<_P_(T_bound)> (bound_); }

])

divert(0)dnl
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc { 

/** @defgroup bind bind()
 * sigc::bind() alters an arbitrary functor by fixing arguments to certain values.
 * The mandatory first template argument specifies the number of the
 * argument where binding starts. Counting starts from @p 1. A value
 * of @p 0 means that binding should start from the last argument.
 * Up to three arguments can be bound at a time.
 * The types of the arguments can optionally be specified if not deduced.
 *
 * @par Examples:
 *   @code
 *   void foo(int, int, int);
 *   sigc::bind<1>(&foo,1)(2,3); //fixes the first argument and calls foo(1,2,3);
 *   sigc::bind<2>(&foo,1)(2,3); //fixes the second argument and calls foo(2,1,3);
 *   sigc::bind<3>(&foo,1)(2,3); //fixes the third argument and calls foo(2,3,1);
 *   sigc::bind<0>(&foo,1)(2,3); //fixes the last (third) argument and calls foo(2,3,1);
 *   sigc::bind<1>(&foo,1,2)(3); //fixes the first and second argument and calls foo(1,2,3);
 *   sigc::bind<0>(&foo,1,2)(3); //fixes the last two (second and third) arguments and calls foo(3,1,2);
 *   @endcode
 *
 * The functor sigc::bind() returns can be passed into
 * sigc::signal::connect() directly.
 *
 * @par Example:
 *   @code
 *   sigc::signal<void> some_signal;
 *   void foo(int);
 *   some_signal.connect(sigc::bind<0>(&foo,1));
 *   @endcode
 *
 * You can bind references to functors by passing the objects through
 * the sigc::ref() helper function.
 *
 * @par Example:
 *   @code
 *   int some_int;
 *   sigc::signal<void> some_signal;
 *   void foo(int&);
 *   some_signal.connect(sigc::bind<0>(&foo,sigc::ref(some_int)));
 *   @endcode
 *
 * If you bind an object of a sigc::trackable derived type to a functor
 * by reference, a slot assigned to the bind adaptor is cleared automatically
 * when the object goes out of scope.
 *
 * @par Example:
 *   @code
 *   struct bar : public sigc::trackable {} some_bar;
 *   sigc::signal<void> some_signal;
 *   void foo(bar&);
 *   some_signal.connect(sigc::bind<0>(&foo,sigc::ref(some_bar)));
 *     // disconnected automatically if some_bar goes out of scope
 *   @endcode
 *
 * For a more powerful version of this functionality see the lambda
 * library adaptor sigc::group() which can bind, hide and reorder
 * arguments arbitrarily.  Although lambda call is more flexible,
 * sigc::bind() provides a means of binding parameters when then total
 * number of parameters called is variable.
 *
 * @ingroup adaptors
 */

/** Adaptor that binds an argument to the wrapped functor.
 * Use the convenience function bind() to create an instance of bind_functor.
 *
 * The following template arguments are used:
 * - @e I_location Number of the argument to fix (counting starts from @p 1, @p 0 stands for the last argument).
 * - @e T_type Type of the bound argument.
 * - @e T_functor Type of the functor to wrap.
 *
 * @ingroup bind
 */
template <int I_location, class T_type, class T_functor>
struct bind_functor;

FOR(0,CALL_SIZE,[[BIND_FUNCTOR(%1)]])dnl

/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::bind_functor performs a functor on the
 * functor and on the object instance stored in the sigc::bind_functor object.
 *
 * @ingroup bind
 */
template <class T_action, int T_loc, class T_bound, class T_functor>
void visit_each(const T_action& _A_action,
                const bind_functor<T_loc, T_bound, T_functor>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
  visit_each(_A_action, _A_target.bound_);
}


/** Creates an adaptor of type sigc::bind_functor which binds the passed argument to the passed functor.
 * The template argument @e I_location is mandatory and specifies the
 * number of the argument to be fixed (counting starts from @p 1,
 * @p 0 stands for the last argument).
 *
 * @param _A_func Functor that should be wrapped.
 * @param _A_b1 Argument to bind to @e _A_func.
 * @return Adaptor that executes _A_func with the bound argument on invokation.
 *
 * @ingroup bind
 */
template <int I_location, class T_bound1, class T_functor>
inline bind_functor<I_location, typename unwrap_reference<T_bound1>::type, T_functor>
bind(const T_functor& _A_func, T_bound1 _A_b1)
{ 
  return bind_functor<I_location, typename unwrap_reference<T_bound1>::type, T_functor>
           (_A_func, _A_b1);
}

/** Creates an adaptor of type sigc::bind_functor which binds the passed arguments to the passed functor.
 * The template argument @e I_location is mandatory and specifies the
 * number of the argument where binding should start (counting starts
 * from @p 1, @p 0 stands for the last two arguments).
 *
 * @param _A_func Functor that should be wrapped.
 * @param _A_b1 First argument to bind to @e _A_func.
 * @param _A_b2 Second argument to bind to @e _A_func.
 * @return Adaptor that executes _A_func with the bound argument on invokation.
 *
 * @ingroup bind
 */
template <int I_location, class T_bound1, class T_bound2, class T_functor>
inline bind_functor<I_location, typename unwrap_reference<T_bound1>::type,
       bind_functor<I_location?I_location+1:0, typename unwrap_reference<T_bound2>::type, T_functor> >
bind(const T_functor& _A_functor, T_bound1 _A_b1, T_bound2 _A_b2)
{ 
  return bind_functor<I_location, typename unwrap_reference<T_bound1>::type,
         bind_functor<I_location?I_location+1:0, typename unwrap_reference<T_bound2>::type, T_functor> >
           (bind<I_location?I_location+1:0>(_A_functor, _A_b2), _A_b1);
}

/** Creates an adaptor of type sigc::bind_functor which binds the passed arguments to the passed functor.
 * The template argument @e I_location is mandatory and specifies the
 * number of the argument where binding should start (counting starts
 * from @p 1, @p 0 stands for the three arguments).
 *
 * @param _A_func Functor that should be wrapped.
 * @param _A_b1 First argument to bind to @e _A_func.
 * @param _A_b2 Second argument to bind to @e _A_func.
 * @param _A_b3 Third argument to bind to @e _A_func.
 * @return Adaptor that executes _A_func with the bound argument on invokation.
 *
 * @ingroup bind
 */
template <int I_location, class T_bound1, class T_bound2, class T_bound3, class T_functor>
inline bind_functor<I_location, typename unwrap_reference<T_bound1>::type,
       bind_functor<I_location?I_location+1:0, typename unwrap_reference<T_bound2>::type,
       bind_functor<I_location?I_location+2:0, typename unwrap_reference<T_bound3>::type, T_functor> > >
bind(const T_functor& _A_functor, T_bound1 _A_b1, T_bound2 _A_b2,T_bound3 _A_b3)
{ 
  return bind_functor<I_location, typename unwrap_reference<T_bound1>::type,
         bind_functor<I_location?I_location+1:0, typename unwrap_reference<T_bound2>::type,
         bind_functor<I_location?I_location+2:0, typename unwrap_reference<T_bound3>::type, T_functor> > >
           (bind<I_location?I_location+1:0>(_A_functor, _A_b2, _A_b3),_A_b1);
}

} /* namespace sigc */
