dnl Copyright 2013, The libsigc++ Development Team
dnl
dnl This file is part of libsigc++.
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
dnl License along with this library. If not, see <http://www.gnu.org/licenses/>.
dnl
divert(-1)

include(template.macros.m4)

define([TRACK_OBJECT_OPERATOR],[dnl
  /** Invokes the wrapped functor passing on the arguments.dnl
FOR(1, $1,[
   * @param _A_arg%1 Argument to be passed on to the functor.])
   * @return The return value of the functor invocation.
   */
  template <LOOP([typename T_arg%1], $1)>
  typename deduce_result_type<LOOP(T_arg%1, $1)>::type
  operator()(LOOP(T_arg%1 _A_arg%1, $1))
  {
    return this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<LOOP([
      _P_(T_arg%1)], $1)>
      (LOOP(_A_arg%1, $1));
  }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <LOOP([typename T_arg%1], $1)>
  typename deduce_result_type<LOOP(T_arg%1, $1)>::type
  sun_forte_workaround(LOOP(T_arg%1 _A_arg%1, $1))
  {
    return this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<LOOP([
      _P_(T_arg%1)], $1)>
      (LOOP(_A_arg%1, $1));
  }
  #endif

])dnl end TRACK_OBJECT_OPERATOR

dnl track_obj_functor[2..CALL_SIZE]. $1 is assumed to be >= 2.
define([TRACK_OBJECT_FUNCTOR],[dnl
/** track_obj_functor$1 wraps a functor and stores $1 references to trackable objects.
 * Use the convenience function track_obj() to create an instance of track_obj_functor$1.
 *
 * @tparam T_functor The type of functor to wrap.dnl
FOR(1,$1,[
 * @tparam T_obj%1 The type of a trackable object.])
 *
 * @newin{2,4}
 *
 * @ingroup track_obj
 */
template <typename T_functor, LOOP(typename T_obj%1, $1)>
class track_obj_functor$1 : public track_obj_functor1<T_functor, T_obj1>
{
public:
  /** Constructs a track_obj_functor$1 object that wraps the passed functor and
   * stores references to the passed trackable objects.
   * @param _A_func Functor.dnl
FOR(1,$1,[
   * @param _A_obj%1 Trackable object.])
   */
  track_obj_functor$1(const T_functor& _A_func, LOOP(const T_obj%1& _A_obj%1, $1))
  : track_obj_functor1<T_functor, T_obj1>(_A_func, _A_obj1)FOR(2,$1,[[, ]obj%1_(_A_obj%1)]) {}

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//protected:
  // public, so that visit_each() can access it.dnl
FOR(2,$1,[
  const_limit_reference<T_obj%1> obj%1_;])
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

}; // end class track_obj_functor$1

])dnl end TRACK_OBJECT_FUNCTOR

define([TRACK_OBJECT_VISIT_EACH],[dnl
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::track_obj_functor$1 performs a functor
 * on the functor and on the trackable object instances stored in the
 * sigc::track_obj_functor$1 object.
 *
 * @newin{2,4}
 *
 * @ingroup track_obj
 */
template <typename T_functor, LOOP(typename T_obj%1, $1)>
struct visitor<track_obj_functor$1<T_functor, LOOP(T_obj%1, $1)> >
{
  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const track_obj_functor$1<T_functor, LOOP(T_obj%1, $1)>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);dnl
FOR(1,$1,[
    sigc::visit_each(_A_action, _A_target.obj%1_);])
  }
};

])dnl end TRACK_OBJECT_VISIT_EACH

define([TRACK_OBJECT],[dnl
/** Creates an adaptor of type sigc::track_obj_functor$1 which wraps a functor.
 * @param _A_func Functor that shall be wrapped.dnl
FOR(1,$1,[
 * @param _A_obj%1 Trackable object.])
 * @return Adaptor that executes _A_func() on invocation.
 *
 * @newin{2,4}
 *
 * @ingroup track_obj
 */
template <typename T_functor, LOOP(typename T_obj%1, $1)>
inline track_obj_functor$1<T_functor, LOOP(T_obj%1, $1)>
track_obj(const T_functor& _A_func, LOOP(const T_obj%1& _A_obj%1, $1))
{
  return track_obj_functor$1<T_functor, LOOP(T_obj%1, $1)>
    (_A_func, LOOP(_A_obj%1, $1));
}

])dnl end TRACK_OBJECT

divert(0)dnl
_FIREWALL([ADAPTORS_TRACK_OBJ])
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/limit_reference.h>

namespace sigc {

/** @defgroup track_obj track_obj()
 * sigc::track_obj() tracks trackable objects, referenced from a functor.
 * It can be useful when you assign a C++11 lambda expression or a std::function<>
 * to a slot, or connect it to a signal, and the lambda expression or std::function<>
 * contains references to sigc::trackable derived objects.
 *
 * The functor returned by sigc::track_obj() is formally an adaptor, but it does
 * not alter the signature, return type or behaviour of the supplied functor.
 * Up to CALL_SIZE objects can be tracked. operator()() can have up to CALL_SIZE arguments.
 *
 * @par Example:
 * @code
 * struct bar : public sigc::trackable {};
 * sigc::signal<void> some_signal;
 * void foo(bar&);
 * {
 *   bar some_bar;
 *   some_signal.connect([[&some_bar]](){ foo(some_bar); });
 *     // NOT disconnected automatically when some_bar goes out of scope
 *   some_signal.connect(sigc::track_obj([[&some_bar]](){ foo(some_bar); }, some_bar);
 *     // disconnected automatically when some_bar goes out of scope
 * }
 * @endcode
 *
 * @newin{2,4}
 *
 * @ingroup adaptors
 */

/** track_obj_functor1 wraps a functor and stores a reference to a trackable object.
 * Use the convenience function track_obj() to create an instance of track_obj_functor1.
 *
 * @tparam T_functor The type of functor to wrap.
 * @tparam T_obj1 The type of a trackable object.
 *
 * @newin{2,4}
 *
 * @ingroup track_obj
 */
template <typename T_functor, typename T_obj1>
class track_obj_functor1 : public adapts<T_functor>
{
public:
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;

#ifndef DOXYGEN_SHOULD_SKIP_THIS
  template <LOOP(typename T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
    { typedef typename adaptor_type::template deduce_result_type<LOOP(_P_(T_arg%1), CALL_SIZE)>::type type; };
#endif
  typedef typename adaptor_type::result_type result_type;

  /** Constructs a track_obj_functor1 object that wraps the passed functor and
   * stores a reference to the passed trackable object.
   * @param _A_func Functor.
   * @param _A_obj1 Trackable object.
   */
  track_obj_functor1(const T_functor& _A_func, const T_obj1& _A_obj1)
  : adapts<T_functor>(_A_func), obj1_(_A_obj1) {}

  /** Invokes the wrapped functor.
   * @return The return value of the functor invocation.
   */
  result_type operator()()
  { return this->functor_(); }

FOR(1,CALL_SIZE,[[TRACK_OBJECT_OPERATOR(%1)]])dnl

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//protected:
  // public, so that visit_each() can access it.
  const_limit_reference<T_obj1> obj1_;
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

}; // end class track_obj_functor1

FOR(2,CALL_SIZE,[[TRACK_OBJECT_FUNCTOR(%1)]])dnl

#ifndef DOXYGEN_SHOULD_SKIP_THIS
FOR(1,CALL_SIZE,[[TRACK_OBJECT_VISIT_EACH(%1)]])dnl
#endif // DOXYGEN_SHOULD_SKIP_THIS

FOR(1,CALL_SIZE,[[TRACK_OBJECT(%1)]])dnl

} /* namespace sigc */
