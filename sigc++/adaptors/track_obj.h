#ifndef _SIGC_ADAPTORS_TRACK_OBJ_H_
#define _SIGC_ADAPTORS_TRACK_OBJ_H_

#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/limit_reference.h>
#include <sigc++/tuple-utils/tuple_for_each.h>

namespace sigc {

/** @defgroup track_obj track_obj()
 * sigc::track_obj() tracks trackable objects, referenced from a functor.
 * It can be useful when you assign a C++11 lambda expression or a std::function<>
 * to a slot, or connect it to a signal, and the lambda expression or std::function<>
 * contains references to sigc::trackable derived objects.
 *
 * The functor returned by sigc::track_obj() is formally an adaptor, but it does
 * not alter the signature, return type or behaviour of the supplied functor.
 * Up to 7 objects can be tracked. operator()() can have up to 7 arguments.
 *
 * @par Example:
 * @code
 * struct bar : public sigc::trackable {};
 * sigc::signal<void> some_signal;
 * void foo(bar&);
 * {
 *   bar some_bar;
 *   some_signal.connect([&some_bar](){ foo(some_bar); });
 *     // NOT disconnected automatically when some_bar goes out of scope
 *   some_signal.connect(sigc::track_obj([&some_bar](){ foo(some_bar); }, some_bar);
 *     // disconnected automatically when some_bar goes out of scope
 * }
 * @endcode
 *
 * @newin{2,4}
 *
 * @ingroup adaptors
 */

/** track_obj_functor wraps a functor and stores a reference to a trackable object.
 * Use the convenience function track_obj() to create an instance of track_obj_functor.
 *
 * @tparam T_functor The type of functor to wrap.
 * @tparam T_obj The types of the trackable objects.
 *
 * @newin{2,4}
 *
 * @ingroup track_obj
 */
template <typename T_functor, typename... T_obj>
class track_obj_functor : public adapts<T_functor>
{
public:
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;
  typedef typename adaptor_type::result_type result_type;

  /** Constructs a track_obj_functor object that wraps the passed functor and
   * stores a reference to the passed trackable objects.
   * @param _A_func Functor.
   * @param _A_obj Trackable objects.
   */
  track_obj_functor(const T_functor& _A_func, const T_obj&... _A_obj)
  : adapts<T_functor>(_A_func), obj_(_A_obj...) {}

  /** Invokes the wrapped functor.
   * @return The return value of the functor invocation.
   */
  decltype(auto) operator()()
  { return this->functor_(); }


  /** Invokes the wrapped functor passing on the arguments.
   * @param _A_arg... Arguments to be passed on to the functor.
   * @return The return value of the functor invocation.
   */
  template <typename... T_arg>
  decltype(auto)
  operator()(T_arg... _A_arg)
  {
    return this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<type_trait_pass_t<T_arg>...>
      (_A_arg...);
  }

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//protected:
  // public, so that visit_each() can access it.
  std::tuple<const_limit_reference<T_obj>...> obj_;
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

}; // end class track_obj_functor


#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::track_obj_functor performs a functor
 * on the functor and on the trackable object instances stored in the
 * sigc::track_obj_functor object.
 *
 * @newin{2,4}
 *
 * @ingroup track_obj
 */
template <typename T_functor, typename... T_obj>
struct visitor<track_obj_functor<T_functor, T_obj...>>
{
  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const track_obj_functor<T_functor, T_obj...>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);

    //Call sigc::visit_each(_A_action, element) on each element in the 
    //_A_target.obj_ tuple:
    sigc::internal::tuple_for_each<TrackObjVisitForEach>(_A_target.obj_, _A_action);
  }

private:
  template<typename T_element>
  struct TrackObjVisitForEach
  {
    template<typename T_action>
    static
    void
    visit(const T_element& element, const T_action& action)
    {
       sigc::visit_each(action, element);
    }
  };
};
#endif // DOXYGEN_SHOULD_SKIP_THIS


/** Creates an adaptor of type sigc::track_obj_functor which wraps a functor.
 * @param _A_func Functor that shall be wrapped.
 * @param _A_obj Trackable objects.
 * @return Adaptor that executes _A_func() on invocation.
 *
 * @newin{2,4}
 *
 * @ingroup track_obj
 */
template <typename T_functor, typename... T_obj>
inline decltype(auto)
track_obj(const T_functor& _A_func, const T_obj&... _A_obj)
{
  return track_obj_functor<T_functor, T_obj...>
    (_A_func, _A_obj...);
}


} /* namespace sigc */

#endif /* _SIGC_ADAPTORS_TRACK_OBJ_H_ */
