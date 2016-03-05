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

define([LIMIT_REFERENCE],[dnl
/** A [$1]limit_reference<Foo> object stores a reference (Foo&), but makes sure that,
 * if Foo inherits from sigc::trackable, then visit_each<>() will "limit" itself to the
 * sigc::trackable reference instead of the derived reference. This avoids use of
 * a reference to the derived type when the derived destructor has run. That can be
 * a problem when using virtual inheritance.
 *
 * If Foo inherits from trackable then both the derived reference and the
 * sigc::trackable reference are stored, so we can later retrieve the sigc::trackable
 * reference without doing an implicit conversion. To retrieve the derived reference
 * (so that you invoke methods or members of it), use invoke(). To retrieve the trackable
 * reference (so that you can call visit_each() on it), you use visit().
 *
 * If Foo does not inherit from sigc::trackable then invoke() and visit() just return the
 * derived reference.
 *
 * This is used for bound (sigc::bind) slot parameters (via bound_argument), bound return values,
 * and, with mem_fun(), the reference to the handling object.
 *
 * - @e T_type The type of the reference.
 */
template <class T_type>
using [$1]limit_reference = limit_reference_base<[$3]T_type>;
])

divert(0)

_FIREWALL([LIMIT_REFERENCE])

#include <sigc++/visit_each.h>
#include <sigc++/type_traits.h>
#include <sigc++/trackable.h>

namespace sigc {

/** A limit_reference_base<Foo> object stores a reference (Foo&), but makes sure that,
 * if Foo inherits from sigc::trackable, then visit_each<>() will "limit" itself to the
 * sigc::trackable reference instead of the derived reference. This avoids use of
 * a reference to the derived type when the derived destructor has run. That can be
 * a problem when using virtual inheritance.
 *
 * If Foo inherits from trackable then both the derived reference and the
 * sigc::trackable reference are stored, so we can later retrieve the sigc::trackable
 * reference without doing an implicit conversion. To retrieve the derived reference
 * (so that you invoke methods or members of it), use invoke(). To retrieve the trackable
 * reference (so that you can call visit_each() on it), you use visit().
 *
 * If Foo does not inherit from sigc::trackable then invoke() and visit() just return the
 * derived reference.
 *
 * This is used for bound (sigc::bind) slot parameters (via bound_argument), bound return values,
 * and, with mem_fun(), the reference to the handling object.
 *
 * - @e T_type_invoke_result The type of the reference.
 */
template <class T_type_invoke_result,
          bool I_derives_trackable =
            std::is_base_of<trackable, std::decay_t<T_type_invoke_result>>::value>
class limit_reference_base
{
public:
  using reference_type = typename std::remove_volatile_t<T_type_invoke_result>;

  /** Constructor.
   * @param _A_target The reference to limit.
   */
  limit_reference_base(reference_type& _A_target)
    : visited(_A_target)
    {}

  /** Retrieve the entity to visit for visit_each().
   * Depending on the template specialization, this is either a derived reference, or sigc::trackable& if T_type_invoke_result derives from sigc::trackable.
   * @return The reference.
   */
  inline const reference_type& visit() const
    { return visited; }

  /** Retrieve the reference.
   * This is always a reference to the derived instance.
   * @return The reference.
   */
  inline T_type_invoke_result& invoke() const
    { return visited; }

private:
  /** The reference.
   */
  reference_type& visited;
};

/** limit_reference_base object for a class that derives from trackable.
 * - @e T_type The type of the reference.
 */
template <class T_type_invoke_result>
class limit_reference_base<T_type_invoke_result, true>
{
public:
  using reference_type = typename std::remove_volatile_t<T_type_invoke_result>;

  /** Constructor.
   * @param _A_target The reference to limit.
   */
  limit_reference_base(reference_type& _A_target)
    : visited(_A_target),
      invoked(_A_target)
    {}

  /** Retrieve the entity to visit for visit_each().
   * Depending on the template specialization, this is either a derived reference, or sigc::trackable& if T_type derives from sigc::trackable.
   * @return The reference.
   */
  inline const trackable& visit() const
    { return visited; }

  /** Retrieve the reference.
   * This is always a reference to the derived instance.
   * @return The reference.
   */
  inline T_type_invoke_result& invoke() const
    { return invoked; }

private:
  using trackable_type = typename std::conditional_t<
    std::is_const<reference_type>::value, const trackable, trackable>;

  /** The trackable reference.
   */
  trackable_type& visited;

  /** The reference.
   */
  reference_type& invoked;
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS
/** Implementation of visitor specialized for the [$1]limit_reference
 * class, to call visit_each() on the entity returned by the [$1]limit_reference's
 * visit() method.
 * @tparam T_type_invoke_result The type of the reference
 * @tparam T_action The type of functor to invoke.
 * @param _A_action The functor to invoke.
 * @param _A_target The visited instance.
 */
template <class T_type_invoke_result>
struct visitor<limit_reference_base<T_type_invoke_result> >
{
  template <class T_action>
  static void do_visit_each(const T_action& _A_action,
                            const limit_reference_base<T_type_invoke_result>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.visit());
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS




LIMIT_REFERENCE([],[],[])dnl


LIMIT_REFERENCE([const_],[const ],[const ])dnl


LIMIT_REFERENCE([volatile_],[],[volatile ])dnl


LIMIT_REFERENCE([const_volatile_],[const ],[const volatile ])dnl

} /* namespace sigc */

