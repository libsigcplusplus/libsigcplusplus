#ifndef _SIGC_FUNCTORS_FUNCTOR_TRAIT_H_
#define _SIGC_FUNCTORS_FUNCTOR_TRAIT_H_
#include <sigc++/functors/functor_base.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/type_traits.h>
#include <type_traits>

namespace sigc
{

/** @defgroup sigcfunctors Functors
 * Functors are copyable types that define operator()().
 *
 * Types that define operator()() overloads with different return types are referred to
 * as multi-type functors. Multi-type functors are only partially supported in libsigc++.
 *
 * Closures are functors that store all information needed to invoke a callback from operator()().
 *
 * Adaptors are functors that alter the signature of a functor's operator()().
 *
 * libsigc++ defines numerous functors, closures and adaptors.
 * Since libsigc++ is a callback library, most functors are also closures.
 * The documentation doesn't distinguish between functors and closures.
 *
 * The basic functor types libsigc++ provides are created with ptr_fun() and mem_fun()
 * and can be converted into slots implicitly.
 * The set of adaptors that ships with libsigc++ is documented in the @ref adaptors module.
 *
 * If you want to mix user-defined and third party functors with libsigc++,
 * and you want them to be implicitly convertible into slots, libsigc++ must know
 * the result type of your functors. There are different ways to achieve that.
 *
 * - Derive your functors from sigc::functor_base and place
 *   <tt>using result_type = T_return;</tt> in the class definition.
 * - Use the macro SIGC_FUNCTOR_TRAIT(T_functor,T_return) in namespace sigc.
 *   Multi-type functors are only partly supported.
 * - For functors not derived from sigc::functor_base, and not specified with
 *   SIGC_FUNCTOR_TRAIT(), libsigc++ tries to deduce the result type with the
 *   C++11 decltype() specifier. That attempt usually succeeds if the functor
 *   has a single operator()(), but it fails if operator()() is overloaded.
 * - Use the macro #SIGC_FUNCTORS_HAVE_RESULT_TYPE, if you want libsigc++ to assume
 *   that result_type is defined in all user-defined or third party functors,
 *   whose result type can't be deduced in any other way.
 *
 * If all these ways to deduce the result type fail, void is assumed.
 */

/** Helper class, to determine if decltype() can deduce the result type of a functor.
 *
 * @ingroup sigcfunctors
 */
template <typename T_functor>
class can_deduce_result_type_with_decltype
{
private:
  struct biggerthanint
  {
    int memory1;
    int memory2;
    int memory3;
    int memory4;
  };

  static biggerthanint checksize(...);

  // If decltype(&X_functor::operator()) can't be evaluated, this checksize() overload
  // is ignored because of the SFINAE rule (Substitution Failure Is Not An Error).
  template <typename X_functor>
  static int checksize(X_functor* obj, decltype(&X_functor::operator()) p = nullptr);

public:
  static const bool value
#ifndef DOXYGEN_SHOULD_SKIP_THIS
    = sizeof(checksize(static_cast<T_functor*>(nullptr))) == sizeof(int)
#endif
    ;
};

/** Trait that specifies the return type of any type.
 * Template specializations for functors derived from sigc::functor_base,
 * for other functors whose result type can be deduced with decltype(),
 * for function pointers and for class methods are provided.
 *
 * @tparam T_functor Functor type.
 * @tparam I_derives_functor_base Whether @p T_functor inherits from sigc::functor_base.
 * @tparam I_can_use_decltype Whether the result type of @p T_functor can be deduced
 *                            with decltype().
 *
 * @ingroup sigcfunctors
 */
template <class T_functor,
  bool I_derives_functor_base = std::is_base_of<functor_base, T_functor>::value,
  bool I_can_use_decltype = can_deduce_result_type_with_decltype<T_functor>::value>
struct functor_trait
{
  using functor_type = T_functor;
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS
template <class T_functor, bool I_can_use_decltype>
struct functor_trait<T_functor, true, I_can_use_decltype>
{
  using functor_type = T_functor;
};

template <typename T_functor>
struct functor_trait<T_functor, false, true>
{
  using functor_type = T_functor;
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

#ifndef DOXYGEN_SHOULD_SKIP_THIS
// detect the return type and the functor version of non-functor types.

// functor ptr fun:

template <class T_return, class... T_arg>
struct functor_trait<T_return (*)(T_arg...), false, false>
{
  using functor_type = pointer_functor<T_return(T_arg...)>;
};

// functor mem fun:

template <class T_return, class T_obj, class... T_arg>
struct functor_trait<T_return (T_obj::*)(T_arg...), false, false>
{
  using functor_type = mem_functor<T_return (T_obj::*)(T_arg...), T_arg...>;
};

template <class T_return, class T_obj, class... T_arg>
struct functor_trait<T_return (T_obj::*)(T_arg...) const, false, false>
{
  using functor_type = mem_functor<T_return (T_obj::*)(T_arg...) const, T_arg...>;
};

#endif // DOXYGEN_SHOULD_SKIP_THIS

} /* namespace sigc */
#endif /* _SIGC_FUNCTORS_FUNCTOR_TRAIT_H_ */
