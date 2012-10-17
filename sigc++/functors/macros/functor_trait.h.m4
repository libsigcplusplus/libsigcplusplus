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

define([FUNCTOR_PTR_FUN],[dnl
template <LIST(LOOP(class T_arg%1, $1), class T_return)> class pointer_functor$1;
template <LIST(LOOP(class T_arg%1, $1), class T_return)>
struct functor_trait<T_return (*)(LOOP(T_arg%1, $1)), false>
{
  typedef T_return result_type;
  typedef pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)> functor_type;
};

])
define([FUNCTOR_MEM_FUN],[dnl
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)> class mem_functor$1;
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)> class const_mem_functor$1;
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
struct functor_trait<T_return (T_obj::*)(LOOP(T_arg%1, $1)), false>
{
  typedef T_return result_type;
  typedef mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> functor_type;
};
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
struct functor_trait<T_return (T_obj::*)(LOOP(T_arg%1, $1)) const, false>
{
  typedef T_return result_type;
  typedef const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> functor_type;
};

])

divert(0)dnl
__FIREWALL__
#include <sigc++/type_traits.h>


namespace sigc {

/** nil struct type.
 * The nil struct type is used as default template argument in the
 * unnumbered sigc::signal and sigc::slot templates.
 *
 * @ingroup signal
 * @ingroup slot
 */
struct nil;


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
 *   <tt>typedef T_return result_type;</tt> in the class definition.
 * - Use the macro SIGC_FUNCTOR_TRAIT(T_functor,T_return) in namespace sigc.
 *   Multi-type functors are only partly supported.
 * - Use the macro #SIGC_FUNCTORS_HAVE_RESULT_TYPE, if you want libsigc++ to assume
 *   that result_type is defined in all user-defined or third party functors,
 *   except those for which you specify a return type explicitly with SIGC_FUNCTOR_TRAIT().
 * - Use the macro #SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE, if your
 *   compiler makes it possible. Functors with overloaded operator()() are not
 *   supported.
 *
 * The last alterative makes it possible to construct a slot from a C++11 lambda
 * expression with any return type. Example:
 * @code
 * namespace sigc {
 *   SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE
 * }
 * sigc::slot<bool, int> slot1 = [[]](int n)-> bool
 *                               {
 *                                 return n == 42;
 *                               };
 * @endcode
 */

/** A hint to the compiler.
 * All functors which define @p result_type should publically inherit from this hint.
 *
 * @ingroup sigcfunctors
 */
struct functor_base {};

/** Trait that specifies the return type of any type.
 * Template specializations for functors derived from sigc::functor_base,
 * for function pointers and for class methods are provided.
 *
 * @tparam T_functor Functor type.
 * @tparam I_derives_functor_base Whether @p T_functor inherits from sigc::functor_base.
 *
 * @ingroup sigcfunctors
 */
template <class T_functor, bool I_derives_functor_base=is_base_and_derived<functor_base,T_functor>::value>
struct functor_trait
{
  typedef void result_type;
  typedef T_functor functor_type;
};

template <class T_functor>
struct functor_trait<T_functor,true>
{
  typedef typename T_functor::result_type result_type;
  typedef T_functor functor_type;
};

/** Helper macro, if you want to mix user-defined and third party functors with libsigc++.
 *
 * If you want to mix functors not derived from sigc::functor_base with libsigc++, and
 * these functors define @p result_type, use this macro inside namespace sigc like so:
 * @code
 * namespace sigc { SIGC_FUNCTORS_HAVE_RESULT_TYPE }
 * @endcode
 *
 * You can't use both SIGC_FUNCTORS_HAVE_RESULT_TYPE and
 * SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE in the same compilation unit.
 *
 * @ingroup sigcfunctors
 */
#define SIGC_FUNCTORS_HAVE_RESULT_TYPE                 \
template <class T_functor>                             \
struct functor_trait<T_functor,false>                  \
{                                                      \
  typedef typename T_functor::result_type result_type; \
  typedef T_functor functor_type;                      \
};

/** Helper macro, if you want to mix user-defined and third party functors with libsigc++.
 *
 * If you want to mix functors not derived from sigc::functor_base with libsigc++, and
 * these functors don't define @p result_type, use this macro inside namespace sigc
 * to expose the return type of the functors like so:
 * @code
 * namespace sigc {
 *   SIGC_FUNCTOR_TRAIT(first_functor_type, return_type_of_first_functor_type)
 *   SIGC_FUNCTOR_TRAIT(second_functor_type, return_type_of_second_functor_type)
 *   ...
 * }
 * @endcode
 *
 * @ingroup sigcfunctors
 */
#define SIGC_FUNCTOR_TRAIT(T_functor,T_return) \
template <>                                    \
struct functor_trait<T_functor,false>          \
{                                              \
  typedef T_return result_type;                \
  typedef T_functor functor_type;              \
};

/** Helper macro, if you want to mix user-defined and third party functors with libsigc++.
 *
 * If you want to mix functors not derived from sigc::functor_base with libsigc++,
 * and your compiler can deduce the result type of the functor with the C++11
 * keyword <tt>decltype</tt>, use this macro inside namespace sigc like so:
 * @code
 * namespace sigc {
 *   SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE
 * }
 * @endcode
 *
 * @newin{2,2,11}
 *
 * You can't use both SIGC_FUNCTORS_HAVE_RESULT_TYPE and
 * SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE in the same compilation unit.
 *
 * @ingroup sigcfunctors
 */
#define SIGC_FUNCTORS_DEDUCE_RESULT_TYPE_WITH_DECLTYPE \
template <typename T_functor>          \
struct functor_trait<T_functor, false> \
{                                      \
  typedef typename functor_trait<decltype(&T_functor::operator()), false>::result_type result_type; \
  typedef T_functor functor_type;      \
};

// detect the return type and the functor version of non-functor types.
FOR(0,CALL_SIZE,[[FUNCTOR_PTR_FUN(%1)]])
FOR(0,CALL_SIZE,[[FUNCTOR_MEM_FUN(%1)]])

} /* namespace sigc */
