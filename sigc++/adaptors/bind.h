#ifndef _SIGC_ADAPTORS_BIND_H_
#define _SIGC_ADAPTORS_BIND_H_
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/adaptors/bound_argument.h>
#include <tuple>
#include <sigc++/tuple_for_each.h>
#include <sigc++/tuple_start.h>
#include <sigc++/tuple_end.h>
#include <sigc++/tuple_transform_each.h>


//TODO: See comment in functor_trait.h.
#if defined(nil) && defined(SIGC_PRAGMA_PUSH_POP_MACRO)
  #define SIGC_NIL_HAS_BEEN_PUSHED 1
  #pragma push_macro("nil")
  #undef nil
#endif

namespace sigc {


/** @defgroup bind bind(), bind_return()
 * sigc::bind() alters an arbitrary functor by fixing arguments to certain values.
 * Up to 7 arguments can be bound at a time.
 * For single argument binding, overloads of sigc::bind() are provided that let you
 * specify the zero-based position of the argument to fix with the first template parameter.
 * (A value of @p -1 fixes the last argument so sigc::bind<-1>() gives the same result as sigc::bind().)
 * The types of the arguments can optionally be specified if not deduced.
 *
 * @par Examples:
 * @code
 * void foo(int, int, int);
 * // single argument binding ...
 * sigc::bind(&foo,1)(2,3);     //fixes the last (third) argument and calls foo(2,3,1)
 * sigc::bind<-1>(&foo,1)(2,3); //same as bind(&foo,1)(2,3) (calls foo(2,3,1))
 * sigc::bind<0>(&foo,1)(2,3);  //fixes the first argument and calls foo(1,2,3)
 * sigc::bind<1>(&foo,1)(2,3);  //fixes the second argument and calls foo(2,1,3)
 * sigc::bind<2>(&foo,1)(2,3);  //fixes the third argument and calls foo(2,3,1)
 * // multi argument binding ...
 * sigc::bind(&foo,1,2)(3);     //fixes the last two arguments and calls foo(3,1,2)
 * sigc::bind(&foo,1,2,3)();    //fixes all three arguments and calls foo(1,2,3)
 * @endcode
 *
 * The functor sigc::bind() returns can be passed into
 * sigc::signal::connect() directly.
 *
 * @par Example:
 * @code
 * sigc::signal<void> some_signal;
 * void foo(int);
 * some_signal.connect(sigc::bind(&foo,1));
 * @endcode
 *
 * sigc::bind_return() alters an arbitrary functor by
 * fixing its return value to a certain value.
 *
 * @par Example:
 * @code
 * void foo();
 * std::cout << sigc::bind_return(&foo, 5)(); // calls foo() and returns 5
 * @endcode
 *
 * You can bind references to functors by passing the objects through
 * the std::ref() helper function.
 *
 * @par Example:
 * @code
 * int some_int;
 * sigc::signal<void> some_signal;
 * void foo(int&);
 * some_signal.connect(sigc::bind(&foo, std::ref(some_int)));
 * @endcode
 *
 * If you bind an object of a sigc::trackable derived type to a functor
 * by reference, a slot assigned to the bind adaptor is cleared automatically
 * when the object goes out of scope.
 *
 * @par Example:
 * @code
 * struct bar : public sigc::trackable {} some_bar;
 * sigc::signal<void> some_signal;
 * void foo(bar&);
 * some_signal.connect(sigc::bind(&foo, std::ref(some_bar)));
 *   // disconnected automatically if some_bar goes out of scope
 * @endcode
 *
 * @ingroup adaptors
 */

namespace internal
{

template <class T_element>
struct TransformEachInvoker
{
  //We take T_element as non-const because invoke() is not const.
  static
  decltype(auto)
  transform(T_element& element) {
    return element.invoke();
  }
};

} //namespace internal

/** Adaptor that binds arguments to the wrapped functor.
 * Use the convenience function sigc::bind() to create an instance of sigc::bind_functor.
 *
 * The following template arguments are used:
 * - @e I_location Zero-based position of the argument to fix (@p -1 for the last argument).
 * - @e T_bound Types of the bound argument.
 * - @e T_functor Type of the functor to wrap.
 *
 * @ingroup bind
 */
template <int I_location, class T_functor, class... T_bound>
struct bind_functor : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;
  typedef typename adaptor_type::result_type  result_type;

  /** Invokes the wrapped functor passing on the arguments.
   * bound_ is passed as the next argument.
   * @param _A_arg Arguments to be passed on to the functor.
   * @return The return value of the functor invocation.
   */
  template <class... T_arg>
  decltype(auto)
  operator()(T_arg... _A_arg)
    {
      //For instance, if I_location is 1, and _A_arg has 4 arguments,
      //we would want to call operator() with (_A_arg0, bound, _A_arg1, _A_arg2).
      
      using tuple_type_args = std::tuple<type_trait_pass_t<T_arg>...>;
      auto t_args = std::tuple<T_arg...>(_A_arg...);
      constexpr auto t_args_size = std::tuple_size<tuple_type_args>::value;
      
      auto t_start = tuple_start<I_location>(t_args);
      auto t_bound = tuple_transform_each<internal::TransformEachInvoker>(bound_);
      auto t_end = tuple_end<t_args_size - I_location>(t_args);
      auto t_with_bound = std::tuple_cat(t_start, t_bound, t_end);

      //TODO: Avoid needing to specify the type when calling operator()?
      using t_type_start = typename tuple_type_start<tuple_type_args, I_location>::type;
      using t_type_bound = std::tuple<type_trait_pass_t<typename unwrap_reference<T_bound>::type>...>;

      //using tuple_type_args_pass = std::tuple<type_trait_pass_t<T_arg>...>;
      //using t_type_end = typename tuple_type_end<tuple_type_args_pass  t_args_size - I_location>::type;
      using t_type_end = typename tuple_type_end<tuple_type_args, t_args_size - I_location>::type;
      using t_type_with_bound = typename tuple_type_cat<typename tuple_type_cat<t_type_start, t_type_bound>::type, t_type_end>::type;

      const auto seq = std::make_index_sequence<std::tuple_size<decltype(t_with_bound)>::value>();
      return call_functor_operator_parentheses<t_type_with_bound>(
        t_with_bound, seq);
    }

  /** Constructs a bind_functor object that binds an argument to the passed functor.
   * @param _A_func Functor to invoke from operator()().
   * @param _A_bound Argument to bind to the functor.
   */
  bind_functor(type_trait_take_t<T_functor> _A_func, type_trait_take_t<T_bound>... _A_bound)
    : adapts<T_functor>(_A_func), bound_(_A_bound...)
    {}

  //TODO: Should this be private?
  /// The arguments bound to the functor.
  std::tuple<bound_argument<T_bound>...> bound_;

private:
  template<class T_specific, class T, std::size_t... Is>
  decltype(auto)
  call_functor_operator_parentheses(T&& tuple,
    std::index_sequence<Is...>)
  {
    return this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<typename std::tuple_element<Is, T_specific>::type...>(std::get<Is>(std::forward<T>(tuple))...);
  }
};


/** Adaptor that binds argument(s) to the wrapped functor.
 * This template specialization fixes the last argument(s) of the wrapped functor.
 *
 * @ingroup bind
 */
template <class T_functor, class... T_type>
struct bind_functor<-1, T_functor, T_type...> : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;
  typedef typename adaptor_type::result_type  result_type;

  /** Invokes the wrapped functor passing on the arguments.
   * bound_ is passed as the next argument.
   * @param _A_arg Arguments to be passed on to the functor.
   * @return The return value of the functor invocation.
   */
  template <class... T_arg>
  decltype(auto)
  operator()(T_arg&&... _A_arg)
    {
      //For instance, if _A_arg has 4 arguments,
      //we would want to call operator() with (_A_arg0, _A_arg1, _A_arg2, bound).
      
      auto t_args = std::tuple<T_arg...>(std::forward<T_arg>(_A_arg)...);
      auto t_bound = tuple_transform_each<internal::TransformEachInvoker>(bound_);
      auto t_with_bound = std::tuple_cat(t_args, t_bound);

      //TODO: Avoid needing to specify the type when calling operator()?
      using t_type_args = std::tuple<type_trait_pass_t<T_arg>...>;
      using t_type_bound = std::tuple<type_trait_pass_t<typename unwrap_reference<T_type>::type>...>;
      using t_type_with_bound = typename tuple_type_cat<t_type_args, t_type_bound>::type;

      const auto seq = std::make_index_sequence<std::tuple_size<decltype(t_with_bound)>::value>();
      return call_functor_operator_parentheses<t_type_with_bound>(t_with_bound, seq);
    }

  /** Constructs a bind_functor object that binds an argument to the passed functor.
   * @param _A_func Functor to invoke from operator()().
   * @param _A_bound Arguments to bind to the functor.
   */
  bind_functor(type_trait_take_t<T_functor> _A_func, type_trait_take_t<T_type>... _A_bound)
    : adapts<T_functor>(_A_func), bound_(_A_bound...)
    {}

  /// The argument bound to the functor.
  std::tuple<bound_argument<T_type>...> bound_;

private:
  template<class T_specific, class T, std::size_t... Is>
  decltype(auto)
  call_functor_operator_parentheses(T&& tuple,
    std::index_sequence<Is...>)
  {
    return this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<typename std::tuple_element<Is, T_specific>::type...>(std::get<Is>(std::forward<T>(tuple))...);
  }
};


namespace {

//TODO: Avoid duplication with TrackObjVisitForEach in track_obj.h
template<typename T_element>
struct TupleVisitorVisitEach
{
  template<typename T_action>
  static
  void
  visit(const T_element& element, const T_action& action)
  {
    sigc::visit_each(action, element);
  }
};

} //anonymous namespace

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::bind_functor performs a functor on the
 * functor and on the object instances stored in the sigc::bind_functor object.
 *
 * @ingroup bind
 */
template <int T_loc, class T_functor, class... T_bound>
struct visitor<bind_functor<T_loc, T_functor, T_bound...> >
{
  template <class T_action>
  static void do_visit_each(const T_action& _A_action,
                            const bind_functor<T_loc, T_functor, T_bound...>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
    sigc::visit_each(_A_action, std::get<0>(_A_target.bound_));
  }
};

//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::bind_functor performs a functor on the
 * functor and on the object instances stored in the sigc::bind_functor object.
 *
 * @ingroup bind
 */
template <class T_functor, class... T_type>
struct visitor<bind_functor<-1, T_functor, T_type...> >
{
  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const bind_functor<-1, T_functor, T_type...>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);

    sigc::tuple_for_each<TupleVisitorVisitEach>(_A_target.bound_, _A_action);
  }
};

#endif // DOXYGEN_SHOULD_SKIP_THIS

/** Creates an adaptor of type sigc::bind_functor which binds the passed argument to the passed functor.
 * The optional template argument @e I_location specifies the zero-based
 * position of the argument to be fixed (@p -1 stands for the last argument).
 *
 * @param _A_func Functor that should be wrapped.
 * @param _A_b1 Argument to bind to @e _A_func.
 * @return Adaptor that executes @e _A_func with the bound argument on invokation.
 *
 * @ingroup bind
 */
template <int I_location, class T_functor, class... T_bound>
inline decltype(auto)
bind(const T_functor& _A_func, T_bound... _A_b)
{
  return bind_functor<I_location, T_functor, T_bound...>
           (_A_func, _A_b...);
}

/** Creates an adaptor of type sigc::bind_functor which fixes the last arguments of the passed functor.
 * This function overload fixes the last arguments of @e _A_func.
 *
 * @param _A_func Functor that should be wrapped.
 * @param _A_b Arguments to bind to @e _A_func.
 * @return Adaptor that executes _A_func with the bound argument on invokation.
 *
 * @ingroup bind
 */
template <class T_functor, class... T_type>
inline decltype(auto)
bind(const T_functor& _A_func, T_type... _A_b)
{ return bind_functor<-1, T_functor, T_type...>(_A_func, _A_b...);
}


} /* namespace sigc */

#ifdef SIGC_NIL_HAS_BEEN_PUSHED
  #undef SIGC_NIL_HAS_BEEN_PUSHED
  #pragma pop_macro("nil")
#endif
#endif /* _SIGC_ADAPTORS_BIND_H_ */
