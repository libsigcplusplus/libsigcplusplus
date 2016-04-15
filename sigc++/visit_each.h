/*
 * Copyright 2002, The libsigc++ Development Team
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */
#ifndef _SIGC_VISIT_EACH_HPP_
#define _SIGC_VISIT_EACH_HPP_

#include <sigc++/type_traits.h>
#include <type_traits>

namespace sigc
{

#ifndef DOXYGEN_SHOULD_SKIP_THIS
namespace internal
{

template <class Base, class Derived>
constexpr bool is_base_of_or_same_v =
  std::is_base_of<std::decay_t<Base>, std::decay_t<Derived>>::value ||
    std::is_same<std::decay_t<Base>, std::decay_t<Derived>>::value;

/// Helper struct for visit_each_type().
template <class T_target, class T_action>
struct limit_derived_target
{
  template <class T_type>
  void operator()(T_type&& _A_type) const
  {
    using T_self = limit_derived_target<T_target, T_action>;

    //Only call action_() if T_Target derives from T_Type.
    with_type<T_type, T_self>::execute_(std::forward<T_type>(_A_type), *this);
  }

  explicit limit_derived_target(const T_action& _A_action) : action_(_A_action) {}

  T_action action_;

private:
  using target_type = T_target;

  template <class T_type, class T_limit, bool I_derived = is_base_of_or_same_v<typename T_limit::target_type, T_type>>
  struct with_type;

  // Specialization for I_derived = false
  template <class T_type, class T_limit>
  struct with_type<T_type, T_limit, false>
  {
    static void execute_(const T_type&, const T_limit&) {}
  };

  // Specialization for I_derived = true
  template <class T_type, class T_limit>
  struct with_type<T_type, T_limit, true>
  {
    static void execute_(const T_type& _A_type, const T_limit& _A_action)
    {
      _A_action.action_(_A_type);
    }
  };
};

} /* namespace internal */
#endif // DOXYGEN_SHOULD_SKIP_THIS

// struct visitor was introduced as a result of https://bugzilla.gnome.org/show_bug.cgi?id=724496
// The advantage of using specializations of a template struct instead of overloads of
// a template function is described by Herb Sutter in http://www.gotw.ca/publications/mill17.htm
// In libsigc++ the main reason for using this technique is that we can avoid using ADL
// (argument-dependent lookup), and therefore there is no risk that a visit_each() overload
// in e.g. Boost is selected by mistake.

/** sigc::visitor<T_functor>::do_visit_each() performs a functor on each of the targets of a
 * functor.
 * All unknown types just call @a _A_action on them.
 * Add specializations that specialize the @a T_functor argument for your own
 * functor types, so that subobjects get visited. This is needed to enable
 * auto-disconnection support for your functor types.
 *
 * @par Example:
 *   @code
 *   namespace some_ns
 *   {
 *     struct some_functor
 *     {
 *       void operator()() {}
 *       some_possibly_sigc_trackable_derived_type some_data_member;
 *       some_other_functor_type some_other_functor;
 *     };
 *   }
 *
 *   namespace sigc
 *   {
 *     template <>
 *     struct visitor<some_ns::some_functor>
 *     {
 *       template <class T_action>
 *       static void do_visit_each(const T_action& _A_action,
 *                                 const some_ns::some_functor& _A_target)
 *       {
 *         sigc::visit_each(_A_action, _A_target.some_data_member);
 *         sigc::visit_each(_A_action, _A_target.some_other_functor);
 *       }
 *     };
 *   }
 *   @endcode
 *
 * @ingroup sigcfunctors
 */
template <class T_functor>
struct visitor
{
  template <class T_action>
  static void do_visit_each(const T_action& _A_action, const T_functor& _A_functor)
  {
    _A_action(_A_functor);
  }
};

/** This function performs a functor on each of the targets of a functor.
 *
 * @ingroup sigcfunctors
 */
template <class T_action, class T_functor>
void
visit_each(const T_action& _A_action, const T_functor& _A_functor)
{
  sigc::visitor<T_functor>::do_visit_each(_A_action, _A_functor);
}

/** This function performs a functor on each of the targets
 * of a functor limited to a restricted type.
 *
 * It is currently used only to call slot_do_bind and slot_do_unbind
 * only on trackable-derived functors, like a compile-time version of
 *   if(dynamic_cast<trackable*)(&functor) { slot_do_unbind(functor); }
 * This also depends on do_visit_each() method overloads for
 * limit_derived_target< , slot_do_bind/slot_do_unbind> parameters
 * in the visitor<slot> template specialization.
 * TODO: Remove the need for slot_do_bind/slot_do_unbind, limit_derived_target,
 * and visit_each_type() by just using a constexpr_if
 * (previously known as static_if) if that ends up in C++17.
 *
 * @ingroup sigcfunctors
 */
template <class T_type, class T_action, class T_functor>
void
visit_each_type(const T_action& _A_action, const T_functor& _A_functor)
{
  internal::limit_derived_target<T_type, T_action> limited_action(_A_action);

  sigc::visit_each(limited_action, _A_functor);
}

} /* namespace sigc */
#endif
