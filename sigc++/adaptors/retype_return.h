#ifndef _SIGC_ADAPTORS_RETYPE_RETURN_H_
#define _SIGC_ADAPTORS_RETYPE_RETURN_H_
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc {

/** Adaptor that performs a C-style cast on the return value of a functor.
 * Use the convenience function sigc::retype_return() to create an instance of retype_return_functor.
 *
 * The following template arguments are used:
 * - @e T_return Target type of the C-style cast.
 * - @e T_functor Type of the functor to wrap.
 *
 * @ingroup retype
 */
template <class T_return, class T_functor>
struct retype_return_functor : public adapts<T_functor>
{
#ifndef DOXYGEN_SHOULD_SKIP_THIS
  template <class... T_arg>
  struct deduce_result_type
    { typedef T_return type; };
#endif
  typedef T_return result_type;

  T_return operator()();


  template <class... T_arg>
  inline T_return operator()(T_arg... _A_a)
    { return T_return(this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<T_arg...>
        (_A_a...));
    }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <class... T_arg>
  inline T_return sun_forte_workaround(T_arg... _A_a)
    { return T_return(this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<T_arg...>
        (_A_a...));
    }
  #endif


  retype_return_functor() {}

  /** Constructs a retype_return_functor object that perform a C-style cast on the return value of the passed functor.
   * @param _A_functor Functor to invoke from operator()().
   */
  explicit retype_return_functor(type_trait_take_t<T_functor> _A_functor)
    : adapts<T_functor>(_A_functor)
    {}
};

template <class T_return, class T_functor>
T_return retype_return_functor<T_return, T_functor>::operator()()
  { return T_return(this->functor_()); }


/** Adaptor that performs a C-style cast on the return value of a functor.
 * This template specialization is for a void return. It drops the return value of the functor it invokes.
 * Use the convenience function sigc::hide_return() to create an instance of sigc::retype_return_functor<void>.
 *
 * @ingroup retype
 */
/* The void specialization is needed because of explicit cast to T_return.
 */
template <class T_functor>
struct retype_return_functor<void, T_functor> : public adapts<T_functor>
{
#ifndef DOXYGEN_SHOULD_SKIP_THIS
  template <class... T_arg>
  struct deduce_result_type
    { typedef void type; };
#endif
  typedef void result_type;

  void operator()();


  template <class... T_arg>
  inline void operator()(T_arg... _A_a)
    { this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<T_arg...>
        (_A_a...);
    }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <class... T_arg>
  inline void sun_forte_workaround(T_arg... _A_a)
    { this->functor_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<T_arg...>
        (_A_a...);
    }
  #endif


  retype_return_functor() {}
  retype_return_functor(type_trait_take_t<T_functor> _A_functor)
    : adapts<T_functor>(_A_functor)
    {}
};

template <class T_functor>
void retype_return_functor<void, T_functor>::operator()()
  { this->functor_(); }

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::retype_return_functor performs a functor on the
 * functor stored in the sigc::retype_return_functor object.
 *
 * @ingroup retype
 */
template <class T_return, class T_functor>
struct visitor<retype_return_functor<T_return, T_functor> >
{
  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const retype_return_functor<T_return, T_functor>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

/** Creates an adaptor of type sigc::retype_return_functor which performs a C-style cast on the return value of the passed functor.
 * The template argument @e T_return specifies the target type of the cast.
 *
 * @param _A_functor Functor that should be wrapped.
 * @return Adaptor that executes @e _A_functor performing a C-style cast on the return value.
 *
 * @ingroup retype
 */
template <class T_return, class T_functor>
inline retype_return_functor<T_return, T_functor>
retype_return(const T_functor& _A_functor)
  { return retype_return_functor<T_return, T_functor>(_A_functor); }

/** Creates an adaptor of type sigc::retype_return_functor which drops the return value of the passed functor.
 *
 * @param _A_functor Functor that should be wrapped.
 * @return Adaptor that executes @e _A_functor dropping its return value.
 *
 * @ingroup hide
 */
template <class T_functor>
inline retype_return_functor<void, T_functor>
hide_return(const T_functor& _A_functor)
  { return retype_return_functor<void, T_functor>(_A_functor); }

} /* namespace sigc */
#endif /* _SIGC_ADAPTORS_RETYPE_RETURN_H_ */
