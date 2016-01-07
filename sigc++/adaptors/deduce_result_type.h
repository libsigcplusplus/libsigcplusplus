// -*- c++ -*-
/* Do not edit! -- generated file */
/*
*/
#ifndef _SIGC_ADAPTORS_DEDUCE_RESULT_TYPE_H_
#define _SIGC_ADAPTORS_DEDUCE_RESULT_TYPE_H_
#include <sigc++/functors/functor_trait.h>

namespace sigc {

/** A hint to the compiler.
 * Functors which have all methods based on templates
 * should publicly inherit from this hint and define 
 * a nested template class @p deduce_result_type that
 * can be used to deduce the methods' return types.
 *
 * adaptor_base inherits from the functor_base hint so
 * derived types should also have a result_type defined.
 *
 * Adaptors don't inherit from this type directly. They use
 * use sigc::adapts as a base type instead. sigc::adaptors
 * wraps arbitrary functor types as well as function pointers
 * and class methods.
 *
 * @ingroup adaptors
 */
struct adaptor_base : public functor_base {};


/** Deduce the return type of a functor.
 * <tt>typename deduce_result_type<functor_type, list of arg_types>::type</tt>
 * deduces a functor's result type if @p functor_type inherits from
 * sigc::functor_base and defines @p result_type or if @p functor_type
 * is actually a (member) function type. Multi-type functors are not
 * supported.
 *
 * sigc++ adaptors use
 * <tt>typename deduce_result_type<functor_type, list of arg_types>::type</tt>
 * to determine the return type of their <tt>templated operator()</tt> overloads.
 *
 * Adaptors in turn define a nested template class @p deduce_result_type
 * that is used by template specializations of the global deduce_result_type
 * template to correctly deduce the return types of the adaptor's suitable
 * <tt>template operator()</tt> overload.
 *
 * @ingroup adaptors
 */
template<class T_functor, class... T_args>
struct deduce_result_type
{
  //The compiler will choose this method overload if T_functor derives from adaptor_base,
  //and if it has its own deduce_result_type member (which has its own ::type member).
  template<class U_functor, typename = typename std::is_base_of<adaptor_base, T_functor>::type>
  static
  typename U_functor::template deduce_result_type<T_args...>::type
  test();

  //Otherwise, the compiler will choose this fallback method.
  template<class U_functor>
  static
  typename functor_trait<T_functor>::result_type
  test();

  using type = decltype (test<T_functor> ());
};

template<typename T_functor, typename... T_args>
using deduce_result_t = typename deduce_result_type<T_functor, T_args...>::type;

} /* namespace sigc */
#endif /* _SIGC_ADAPTORS_DEDUCE_RESULT_TYPE_H_ */
