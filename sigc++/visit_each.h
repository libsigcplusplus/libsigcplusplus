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

namespace sigc {

#ifndef DOXYGEN_SHOULD_SKIP_THIS
namespace internal {

//This should really be an inner class of limit_derived_target, without the T_limit template type,
//But the SUN CC 5.7 (not earlier versions) compiler finds it ambiguous when we specify a particular specialization of it.
//and does not seem to allow us to tell it explicitly that it's an inner class.
template <bool I_derived, class T_type, class T_limit>
struct with_type;

//Specialization for I_derived = false
template <class T_type, class T_limit> struct
with_type<false, T_type, T_limit>
{
  static void execute_(const T_type&, const T_limit&) {}
};

//Specialization for I_derived = true
template <class T_type, class T_limit>
struct with_type<true, T_type, T_limit>
{
  static void execute_(const T_type& _A_type, const T_limit& _A_action)
  { _A_action.action_(_A_type); }
};


/// Helper struct for visit_each_type().
template <class T_target, class T_action>
struct limit_derived_target
{
  typedef limit_derived_target<T_target, T_action> T_self;

  template <class T_type>
  void operator()(const T_type& _A_type) const
  {
    with_type<std::is_base_of<T_target, T_type>::value || std::is_same<T_target, T_type>::value, T_type, T_self>::execute_(_A_type, *this);
  }

  limit_derived_target(const T_action& _A_action)
  : action_(_A_action)
  {}

  T_action action_;
};

// Specialization for T_target pointer types, to provide a slightly different execute_() implementation.

template <bool I_derived, class T_type, class T_limit>
struct with_type_pointer;

//Specialization for I_derived = false
template <class T_type, class T_limit>
struct with_type_pointer<false, T_type, T_limit>
{
 static void execute_(const T_type&, const T_limit&) {}
};

//Specialization for I_derived = true
template <class T_type, class T_limit>
struct with_type_pointer<true, T_type, T_limit>
{
  static void execute_(const T_type& _A_type, const T_limit& _A_action)
  { _A_action.action_(&_A_type); }
};

template <class T_target, class T_action>
struct limit_derived_target<T_target*, T_action>
{
  typedef limit_derived_target<T_target*, T_action> T_self;

  template <class T_type>
  void operator()(const T_type& _A_type) const
  {
    with_type_pointer<std::is_base_of<T_target, T_type>::value || std::is_same<T_target, T_type>::value, T_type, T_self>::execute_(_A_type, *this);
  }

  limit_derived_target(const T_action& _A_action)
  : action_(_A_action)
  {}

  T_action action_;
};

} /* namespace internal */
#endif // DOXYGEN_SHOULD_SKIP_THIS

// struct visitor was introduced as a result of https://bugzilla.gnome.org/show_bug.cgi?id=724496
// The advantage of using specializations of a template struct instead of overloads of
// a template function is described by Herb Sutter in http://www.gotw.ca/publications/mill17.htm
// In libsigc++ the main reason for using this technique is that we can avoid using ADL
// (argument-dependent lookup), and therefore there is no risk that a visit_each() overload
// in e.g. Boost is selected by mistake.

/** sigc::visitor<T_functor>::do_visit_each() performs a functor on each of the targets of a functor.
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
void visit_each(const T_action& _A_action, const T_functor& _A_functor)
{ sigc::visitor<T_functor>::do_visit_each(_A_action, _A_functor); }

/** This function performs a functor on each of the targets
 * of a functor limited to a restricted type.
 *
 * @ingroup sigcfunctors
 */
template <class T_type, class T_action, class T_functor>
void visit_each_type(const T_action& _A_action, const T_functor& _A_functor)
{
  typedef internal::limit_derived_target<T_type, T_action> type_limited_action;

  type_limited_action limited_action(_A_action);

  //specifying the types of the template specialization prevents disconnection of bound trackable references (such as with std::ref()),
  //probably because the visit_each<> specializations take various different template types,
  //in various sequences, and we are probably specifying only a subset of them with this.
  //
  //But this is required by the AIX (and maybe IRIX MipsPro  and Tru64) compilers.
  //I guess that std::ref() therefore does not work on those platforms. murrayc
  // sigc::visit_each<type_limited_action, T_functor>(limited_action, _A_functor);

  //g++ (even slightly old ones) is our primary platform, so we could use the non-crashing version.
  //However, the explicit version also fixes a crash in a slightly more common case: http://bugzilla.gnome.org/show_bug.cgi?id=169225
  //Users (and distributors) of libsigc++ on AIX (and maybe IRIX MipsPro and Tru64) do
  //need to use the version above instead, to allow compilation.

  //Added 2014-03-20: The preceding comment probably does not apply any more,
  //now when the visit_each<>() overloads have been replaced by visitor<> specializations.
  //It's probably safe to add explicit template parameters on calls to visit_each(),
  //visit_each_type() and visitor::do_visit_each(), if necessary.

  sigc::visit_each(limited_action, _A_functor);
}

} /* namespace sigc */
#endif
