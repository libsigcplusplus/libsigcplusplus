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

define([LAMBDA_DO],[dnl
  template <LOOP(class T_arg%1, $1)>
  typename deduce_result_type<LOOP(T_arg%1,$1)>::type
  operator ()(LOOP(T_arg%1 _A_%1, $1)) const
    { return value_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<LOOP(_P_(T_arg%1), $1)>
             (LOOP(_A_%1, $1));
    }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <LOOP(class T_arg%1, $1)>
  typename deduce_result_type<LOOP(T_arg%1,$1)>::type
  sun_forte_workaround(LOOP(T_arg%1 _A_%1, $1)) const
    { return value_.SIGC_WORKAROUND_OPERATOR_PARENTHESES<LOOP(_P_(T_arg%1), $1)>
             (LOOP(_A_%1, $1));
    }
  #endif //SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD

])dnl
define([LAMBDA_DO_VALUE],[dnl
  template <LOOP(class T_arg%1, $1)>
  result_type operator ()(LOOP(T_arg%1, $1)) const
    { return value_; }

  #ifndef SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
  template <LOOP(class T_arg%1, $1)>
  result_type sun_forte_workaround(LOOP(T_arg%1, $1)) const
    { return value_; }
  #endif //SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD

])dnl

divert(0)dnl
#ifndef _SIGC_LAMBDA_BASE_HPP_
#define _SIGC_LAMBDA_BASE_HPP_
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/reference_wrapper.h>
#include <type_traits>

_DEPRECATE_IFDEF_START

namespace sigc {

#ifndef DOXYGEN_SHOULD_SKIP_THIS
// libsigc++'s lambda functions have been removed from the API.
// Some code must be kept until we can break ABI.
/** @defgroup lambdas Lambdas
 * libsigc++ ships with basic lambda functionality and the sigc::group adaptor,
 * which uses lambdas to transform a functor's parameter list.
 *
 * The lambda selectors sigc::_1, sigc::_2, ..., sigc::_7 are used to select the
 * first, second, ..., seventh argument from a list.
 *
 * @par Examples:
 * @code
 * std::cout << sigc::_1(10,20,30); // returns 10
 * std::cout << sigc::_2(10,20,30); // returns 20
 * @endcode
 *
 * Operators are defined so that, for example, lambda selectors can be used as
 * placeholders in arithmetic expressions.
 *
 * @par Examples:
 * @code
 * std::cout << (sigc::_1 + 5)(3); // returns (3 + 5)
 * std::cout << (sigc::_1 * sigc::_2)(7,10); // returns (7 * 10)
 * @endcode
 *
 * If your compiler supports C++11 lambda expressions, they are often a good
 * alternative to libsigc++'s lambda expressions. The following examples are
 * equivalent to the previous ones.
 * @code
 * [[]] (int x, int, int) -> int { return x; }(10,20,30); // returns 10
 * [[]] (int, int y, int) -> int { return y; }(10,20,30); // returns 20
 * [[]] (int x) -> int { return x + 5; }(3); // returns (3 + 5)
 * [[]] (int x, int y) -> int { return x * y; }(7,10); // returns (7 * 10)
 * @endcode
 *
 * @deprecated Use C++11 lambda expressions or %std::bind() instead.
 */

/** A hint to the compiler.
 * All lambda types publically inherit from this hint.
 *
 * @deprecated Use C++11 lambda expressions instead.
 *
 * @ingroup lambdas
 */
struct lambda_base : public adaptor_base {};

// Forward declaration of lambda.
template <class T_type> struct lambda;

namespace internal {

/** Abstracts lambda functionality.
 * Objects of this type store a value that may be of type lambda itself.
 * In this case, operator()() executes the lambda (a lambda is always a functor at the same time).
 * Otherwise, operator()() simply returns the stored value.
 *
 * @deprecated Use C++11 lambda expressions instead.
 *
 * @ingroup lambdas
 */
template <class T_type, bool I_islambda = std::is_base_of<lambda_base, T_type>::value> struct lambda_core;

/** Abstracts lambda functionality (template specialization for lambda values).
 *
 * @deprecated Use C++11 lambda expressions instead.
 *
 * @ingroup lambdas
 */
template <class T_type>
struct lambda_core<T_type, true> : public lambda_base
{
  template <LOOP(class T_arg%1=void,CALL_SIZE)>
  struct deduce_result_type
    { typedef typename T_type::template deduce_result_type<LOOP(_P_(T_arg%1),CALL_SIZE)>::type type; };
  typedef typename T_type::result_type result_type;
  typedef T_type lambda_type;

  result_type
  operator()() const;

FOR(1,CALL_SIZE,[[LAMBDA_DO(%1)]])dnl
  lambda_core() {}

  explicit lambda_core(const T_type& v)
    : value_(v) {}

  T_type value_;
};


} /* namespace internal */


// forward declarations for lambda operators other<subscript> and other<assign>
template <class T_type>
struct other;
struct subscript;
struct assign;

template <class T_action, class T_type1, class T_type2>
struct lambda_operator;

template <class T_type>
struct unwrap_lambda_type;

/** Lambda type.
 * Objects of this type store a value that may be of type lambda itself.
 * In this case, operator()() executes the lambda (a lambda is always a functor at the same time).
 * Otherwise, operator()() simply returns the stored value.
 * The assign and subscript operators are defined to return a lambda operator.
 *
 * @deprecated Use C++11 lambda expressions instead.
 *
 * @ingroup lambdas
 */
template <class T_type>
struct lambda : public internal::lambda_core<T_type>
{
  typedef lambda<T_type> self;

  lambda()
    {}

  lambda(typename type_trait<T_type>::take v)
    : internal::lambda_core<T_type>(v)
    {}

  // operators for other<subscript>
  template <class T_arg>
  lambda<lambda_operator<other<subscript>, self, typename unwrap_lambda_type<T_arg>::type> >
  operator [[]] (const T_arg& a) const
    { typedef lambda_operator<other<subscript>, self, typename unwrap_lambda_type<T_arg>::type> lambda_operator_type;
      return lambda<lambda_operator_type>(lambda_operator_type(this->value_, unwrap_lambda_value(a))); }

  // operators for other<assign>
  template <class T_arg>
  lambda<lambda_operator<other<assign>, self, typename unwrap_lambda_type<T_arg>::type> >
  operator = (const T_arg& a) const
    { typedef lambda_operator<other<assign>, self, typename unwrap_lambda_type<T_arg>::type> lambda_operator_type;
      return lambda<lambda_operator_type>(lambda_operator_type(this->value_, unwrap_lambda_value(a))); }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

} /* namespace sigc */

_DEPRECATE_IFDEF_END

#endif /* _SIGC_LAMBDA_BASE_HPP_ */
