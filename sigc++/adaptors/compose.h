#ifndef _SIGC_ADAPTORS_COMPOSE_H_
#define _SIGC_ADAPTORS_COMPOSE_H_
#include <sigc++/adaptors/adapts.h>

namespace sigc
{

/** @defgroup compose compose()
 * sigc::compose() combines two or three arbitrary functors.
 * On invokation, parameters are passed on to one or two getter functor(s).
 * The return value(s) are then passed on to the setter function.
 *
 * @par Examples:
 * @code
 * float square_root(float a)  { return sqrtf(a); }
 * float sum(float a, float b) { return a+b; }
 * std::cout << sigc::compose(&square_root, &sum)(9, 16); // calls square_root(sum(3,6))
 * std::cout << sigc::compose(&sum, &square_root, &square_root)(9); // calls sum(square_root(9),
 * square_root(9))
 * @endcode
 *
 * The functor sigc::compose() returns can be passed directly into
 * sigc::signal::connect().
 *
 * @par Example:
 * @code
 * sigc::signal(float(float, float)> some_signal;
 * some_signal.connect(sigc::compose(&square_root, &sum));
 * @endcode
 *
 * @ingroup adaptors
 */

/** Adaptor that combines two functors.
 * Use the convenience function sigc::compose() to create an instance of sigc::compose1_functor.
 *
 * The following template arguments are used:
 * - @e T_setter Type of the setter functor to wrap.
 * - @e T_getter Type of the getter functor to wrap.
 *
 * @ingroup compose
 */
template <typename T_setter, typename T_getter>
struct compose1_functor : public adapts<T_setter>
{
  decltype(auto) operator()() { return this->functor_(get_()); }

  template <typename... T_arg>
  decltype(auto) operator()(T_arg&&... _A_a)
  {
    return this->functor_(get_(std::forward<T_arg>(_A_a)...));
  }

  /** Constructs a compose1_functor object that combines the passed functors.
   * @param _A_setter Functor that receives the return values of the invokation of @e _A_getter1 and
   * @e _A_getter2.
   * @param _A_getter Functor to invoke from operator()().
   */
  compose1_functor(const T_setter& _A_setter, const T_getter& _A_getter)
  : adapts<T_setter>(_A_setter), get_(_A_getter)
  {
  }

  T_getter get_; // public, so that visit_each() can access it
};

/** Adaptor that combines three functors.
 * Use the convenience function sigc::compose() to create an instance of sigc::compose2_functor.
 *
 * The following template arguments are used:
 * - @e T_setter Type of the setter functor to wrap.
 * - @e T_getter1 Type of the first getter functor to wrap.
 * - @e T_getter2 Type of the second getter functor to wrap.
 *
 * @ingroup compose
 */
template <typename T_setter, typename T_getter1, typename T_getter2>
struct compose2_functor : public adapts<T_setter>
{
  decltype(auto) operator()() { return this->functor_(get1_(), get2_()); }

  template <typename... T_arg>
  decltype(auto) operator()(T_arg... _A_a)
  {
    return this->functor_(get1_(_A_a...), get2_(_A_a...));
  }

  /** Constructs a compose2_functor object that combines the passed functors.
   * @param _A_setter Functor that receives the return values of the invokation of @e _A_getter1 and
   * @e _A_getter2.
   * @param _A_getter1 Functor to invoke from operator()().
   * @param _A_getter2 Functor to invoke from operator()().
   */
  compose2_functor(
    const T_setter& _A_setter, const T_getter1& _A_getter1, const T_getter2& _A_getter2)
  : adapts<T_setter>(_A_setter), get1_(_A_getter1), get2_(_A_getter2)
  {
  }

  T_getter1 get1_; // public, so that visit_each() can access it
  T_getter2 get2_; // public, so that visit_each() can access it
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS
// template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::compose1_functor performs a functor on the
 * functors stored in the sigc::compose1_functor object.
 *
 * @ingroup compose
 */
template <typename T_setter, typename T_getter>
struct visitor<compose1_functor<T_setter, T_getter>>
{
  template <typename T_action>
  static void do_visit_each(
    const T_action& _A_action, const compose1_functor<T_setter, T_getter>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
    sigc::visit_each(_A_action, _A_target.get_);
  }
};

// template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::compose2_functor performs a functor on the
 * functors stored in the sigc::compose2_functor object.
 *
 * @ingroup compose
 */
template <typename T_setter, typename T_getter1, typename T_getter2>
struct visitor<compose2_functor<T_setter, T_getter1, T_getter2>>
{
  template <typename T_action>
  static void do_visit_each(
    const T_action& _A_action, const compose2_functor<T_setter, T_getter1, T_getter2>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
    sigc::visit_each(_A_action, _A_target.get1_);
    sigc::visit_each(_A_action, _A_target.get2_);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

/** Creates an adaptor of type sigc::compose1_functor which combines two functors.
 *
 * @param _A_setter Functor that receives the return value of the invokation of @e _A_getter.
 * @param _A_getter Functor to invoke from operator()().
 * @return Adaptor that executes @e _A_setter with the value returned from invokation of @e
 * _A_getter.
 *
 * @ingroup compose
 */
template <typename T_setter, typename T_getter>
inline compose1_functor<T_setter, T_getter>
compose(const T_setter& _A_setter, const T_getter& _A_getter)
{
  return compose1_functor<T_setter, T_getter>(_A_setter, _A_getter);
}

/** Creates an adaptor of type sigc::compose2_functor which combines three functors.
 *
 * @param _A_setter Functor that receives the return values of the invokation of @e _A_getter1 and
 * @e _A_getter2.
 * @param _A_getter1 Functor to invoke from operator()().
 * @param _A_getter2 Functor to invoke from operator()().
 * @return Adaptor that executes @e _A_setter with the values return from invokation of @e
 * _A_getter1 and @e _A_getter2.
 *
 * @ingroup compose
 */
template <typename T_setter, typename T_getter1, typename T_getter2>
inline compose2_functor<T_setter, T_getter1, T_getter2>
compose(const T_setter& _A_setter, const T_getter1& _A_getter1, const T_getter2& _A_getter2)
{
  return compose2_functor<T_setter, T_getter1, T_getter2>(_A_setter, _A_getter1, _A_getter2);
}

} /* namespace sigc */
#endif /* _SIGC_ADAPTORS_COMPOSE_H_ */
