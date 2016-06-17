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

define([SLOT_N],[dnl
/** Converts an arbitrary functor to a unified type which is opaque.
 * sigc::slot itself is a functor or to be more precise a closure. It contains
 * a single, arbitrary functor (or closure) that is executed in operator()().
 *
 * The template arguments determine the function signature of operator()():
 * - @e T_return The return type of operator()().dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()(). The default @p nil means no argument.])
 *
 * To use simply assign the desired functor to the slot. If the functor
 * is not compatible with the parameter list defined with the template
 * arguments compiler errors are triggered. When called the slot
 * will invoke the functor with minimal copies.
 * block() and unblock() can be used to block the functor's invocation
 * from operator()() temporarily.
 *
 * You should use the more convenient unnumbered sigc::slot template.
 *
 * @ingroup slot
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>
class slot$1
  : public slot_base
{
public:
  typedef T_return result_type;
FOR(1, $1,[  typedef _R_(T_arg%1) arg%1_type_;
])

#ifndef DOXYGEN_SHOULD_SKIP_THIS
private:
  typedef internal::slot_rep rep_type;
public:
  typedef T_return (*call_type)(LIST(rep_type*, LOOP(arg%1_type_, $1)));
#endif

  /** Invoke the contained functor unless slot is in blocking state.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the functor.])
   * @return The return value of the functor invocation.
   */
  inline T_return operator()(LOOP(arg%1_type_ _A_a%1, $1)) const
    {
      if (!empty() && !blocked())
        return (reinterpret_cast<call_type>(slot_base::rep_->call_))(LIST(slot_base::rep_, LOOP(_A_a%1, $1)));
      return T_return();
    }

  inline slot$1() {}

  /** Constructs a slot from an arbitrary functor.
   * @param _A_func The desired functor the new slot should be assigned to.
   */
  template <class T_functor>
  slot$1(const T_functor& _A_func)
    : slot_base(new internal::typed_slot_rep<T_functor>(_A_func))
    {
      //The slot_base:: is necessary to stop the HP-UX aCC compiler from being confused. murrayc.
      slot_base::rep_->call_ = internal::slot_call$1<LIST(T_functor, T_return, LOOP(T_arg%1, $1))>::address();
    }

  /** Constructs a slot, copying an existing one.
   * @param src The existing slot to copy.
   */
  slot$1(const slot$1& src)
    : slot_base(src)
    {}

  /** Constructs a slot, moving an existing one.
   * If @p src is connected to a parent (e.g. a signal), it is copied, not moved.
   * @param src The existing slot to move or copy.
   */
  slot$1(slot$1&& src)
    : slot_base(std::move(src))
    {}

  /** Overrides this slot, making a copy from another slot.
   * @param src The slot from which to make a copy.
   * @return @p this.
   */
  slot$1& operator=(const slot$1& src)
  {
    slot_base::operator=(src);
    return *this;
  }

  /** Overrides this slot, making a move from another slot.
   * If @p src is connected to a parent (e.g. a signal), it is copied, not moved.
   * @param src The slot from which to move or copy.
   * @return @p this.
   */
  slot$1& operator=(slot$1&& src)
  {
    slot_base::operator=(std::move(src));
    return *this;
  }
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overloads for sigc::slot$1 are similar to the function
 * overloads for sigc::slot. See the description of those overloads.
 *
 * @ingroup slot
 */
template <LIST(typename T_return, LOOP(typename T_arg%1, $1))>
struct visitor<slot$1<LIST(T_return, LOOP(T_arg%1, $1))>>
{
  static void do_visit_each(const internal::limit_derived_target<trackable*, internal::slot_do_bind>& _A_action,
                            const slot$1<LIST(T_return, LOOP(T_arg%1, $1))>& _A_target)
  {
    if (_A_target.rep_ && _A_target.rep_->parent_ == nullptr)
    _A_target.rep_->set_parent(_A_action.action_.rep_, &internal::slot_rep::notify);
  }

  static void do_visit_each(const internal::limit_derived_target<trackable*, internal::slot_do_unbind>& _A_action,
                            const slot$1<LIST(T_return, LOOP(T_arg%1, $1))>& _A_target)
  {
    if (_A_target.rep_ && _A_target.rep_->parent_ == _A_action.action_.rep_)
      _A_target.rep_->set_parent(nullptr, nullptr);
  }

  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const slot$1<LIST(T_return, LOOP(T_arg%1, $1))>& _A_target)
  {
    _A_action(_A_target);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

])
define([SLOT],[dnl
ifelse($1, $2,[dnl
// Because slot is opaque, visit_each() will not visit its internal members.
// Those members are not reachable by visit_each() after the slot has been
// constructed. But when a slot contains another slot, the outer slot will become
// the parent of the inner slot, with similar results. See the description of
// slot's specialization of the visitor struct.
/** Convenience wrapper for the numbered sigc::slot# templates.
 * Slots convert arbitrary functors to unified types which are opaque.
 * sigc::slot itself is a functor or to be more precise a closure. It contains
 * a single, arbitrary functor (or closure) that is executed in operator()().
 *
 * The template arguments determine the function signature of operator()():
 * - @e T_return The return type of operator()().dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()(). The default @p nil means no argument.])
 *
 * To use, simply assign the desired functor to the slot. If the functor
 * is not compatible with the parameter list defined with the template
 * arguments, compiler errors are triggered. When called, the slot
 * will invoke the functor with minimal copies.
 * block() and unblock() can be used to temporarily block the functor's
 * invocation from operator()().
 *
 * @par Example:
 * @code
 * void foo(int) {}
 * sigc::slot<void, int> s = sigc::ptr_fun(&foo);
 * s(19);
 * @endcode
 *
 * sigc::slot<> is similar to std::function<>. If you're going to assign the
 * resulting functor to a sigc::slot or connect it to a sigc::signal, it's better
 * not to use std::function. It would become an unnecessary extra wrapper.
 *
 * @deprecated Please use the syntax similar to that used by std::function<>:
 * @code
 * sigc::slot<void(bool, int)> some_slot;
 * @endcode
 *
 * @ingroup slot
 */
template <LIST(class T_return, LOOP(class T_arg%1 = nil, $1))>
class slot],[dnl

/** Convenience wrapper for the numbered sigc::slot$1 template.
 * See the base class for useful methods.
 * This is the template specialization of the unnumbered sigc::slot
 * template for $1 argument(s), specialized for different numbers of arguments
 * This is possible because the template has default (nil) template types.
 *
 * @deprecated Please use the syntax similar to that used by std::function<>:
 * @code
 * sigc::slot<void(bool, int)> some_slot;
 * @endcode
 *
dnl *
dnl * @ingroup slot
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>
class slot <LIST(T_return, LIST(LOOP(T_arg%1, $1), LOOP(nil, CALL_SIZE - $1)))>])
  : public slot$1<LIST(T_return, LOOP(T_arg%1, $1))>
{
public:
  typedef slot$1<LIST(T_return, LOOP(T_arg%1, $1))> parent_type;

  inline slot() {}

  /** Constructs a slot from an arbitrary functor.
   * @param _A_func The desired functor the new slot should be assigned to.
   */
  template <class T_functor>
  slot(const T_functor& _A_func)
    : parent_type(_A_func) {}

  // Without static_cast parent_type(const T_functor& _A_func)
  // is called instead of the copy constructor.
  /** Constructs a slot, copying an existing one.
   * @param src The existing slot to copy.
   */
  slot(const slot& src)
    : parent_type(static_cast<const parent_type&>(src)) {}

  // Without static_cast parent_type(const T_functor& _A_func)
  // is called instead of the move constructor.
  /** Constructs a slot, moving an existing one.
   * If @p src is connected to a parent (e.g. a signal), it is copied, not moved.
   * @param src The existing slot to move or copy.
   */
  slot(slot&& src)
    : parent_type(std::move(static_cast<parent_type&>(src))) {}

  /** Overrides this slot, making a copy from another slot.
   * @param src The slot from which to make a copy.
   * @return @p this.
   */
  slot& operator=(const slot& src)
  {
    parent_type::operator=(src);
    return *this;
  }

  /** Overrides this slot, making a move from another slot.
   * If @p src is connected to a parent (e.g. a signal), it is copied, not moved.
   * @param src The slot from which to move or copy.
   * @return @p this.
   */
  slot& operator=(slot&& src)
  {
    parent_type::operator=(std::move(src));
    return *this;
  }
};

ifelse($1, $2,[dnl
#ifndef DOXYGEN_SHOULD_SKIP_THIS
//template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 *
 * There are three function overloads for sigc::slot.
 *
 * The first two overloads are very specialized. They handle the (probably unusual)
 * case when the functor, stored in a slot, contains a slot. They are invoked from
 * the constructor, destructor or destroy() method of typed_slot_rep.
 * The first overload, called from the constructor of the outer slot, sets
 * the outer slot as the parent of the inner slot. The second overload, called from
 * the destructor or destroy() of the outer slot, unsets the parent of the inner slot.
 * When an object referenced from the inner slot is deleted, the inner slot calls
 * its slot_rep::disconnect(), which calls the outer slot's slot_rep::notify().
 * The outer slot is informed just as if one of its directly referenced objects
 * had been deleted. Result: The outer slot is disconnected from its parent,
 * if any (for instance a sigc::signal).
 * See https://bugzilla.gnome.org/show_bug.cgi?id=755003
 *
 * The third overload is identical to do_visit_each() in visitor's primary template.
 *
 * @ingroup slot
 */
template <LIST(typename T_return, LOOP(typename T_arg%1, $1))>
struct visitor<slot<LIST(T_return, LOOP(T_arg%1, $1))>>
{
  static void do_visit_each(const internal::limit_derived_target<trackable*, internal::slot_do_bind>& _A_action,
                            const slot<LIST(T_return, LOOP(T_arg%1, $1))>& _A_target)
  {
    if (_A_target.rep_ && _A_target.rep_->parent_ == nullptr)
      _A_target.rep_->set_parent(_A_action.action_.rep_, &internal::slot_rep::notify);
  }

  static void do_visit_each(const internal::limit_derived_target<trackable*, internal::slot_do_unbind>& _A_action,
                            const slot<LIST(T_return, LOOP(T_arg%1, $1))>& _A_target)
  {
    if (_A_target.rep_ && _A_target.rep_->parent_ == _A_action.action_.rep_)
      _A_target.rep_->set_parent(nullptr, nullptr);
  }

  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
                            const slot<LIST(T_return, LOOP(T_arg%1, $1))>& _A_target)
  {
    _A_action(_A_target);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS
])
])
define([SLOT_CALL],[dnl
/** Abstracts functor execution.
 * call_it() invokes a functor of type @e T_functor with a list of
 * parameters whose types are given by the template arguments.
 * address() forms a function pointer from call_it().
 *
 * The following template arguments are used:
 * - @e T_functor The functor type.
 * - @e T_return The return type of call_it().dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of call_it().])
 *
 */
template<LIST(class T_functor, class T_return, LOOP(class T_arg%1, $1))>
struct slot_call$1
{
  /** Invokes a functor of type @p T_functor.
   * @param rep slot_rep object that holds a functor of type @p T_functor.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the functor.])
   * @return The return values of the functor invocation.
   */
  static T_return call_it(LIST(slot_rep* rep, LOOP(_R_(T_arg%1) a_%1, $1)))
    {
      typedef typed_slot_rep<T_functor> typed_slot;
      typed_slot *typed_rep = static_cast<typed_slot*>(rep);dnl
ifelse($1,0,[
      return (typed_rep->functor_)();
],[
      return (typed_rep->functor_).SIGC_WORKAROUND_OPERATOR_PARENTHESES<LOOP([_R_(T_arg%1)],$1)>
               (LOOP(a_%1, $1));
])dnl
    }

  /** Forms a function pointer from call_it().
   * @return A function pointer formed from call_it().
   */
  static hook address()
    { return reinterpret_cast<hook>(&call_it); }
};

])

divert(0)dnl
_FIREWALL([FUNCTORS_SLOT])
#include <sigc++/trackable.h>
#include <sigc++/visit_each.h>
#include <sigc++/adaptors/adaptor_trait.h>
#include <sigc++/functors/slot_base.h>

//TODO: See comment in functor_trait.h.
#if defined(nil) && defined(SIGC_PRAGMA_PUSH_POP_MACRO)
  #define SIGC_NIL_HAS_BEEN_PUSHED 1
  #pragma push_macro("nil")
  #undef nil
#endif

namespace sigc {

namespace internal {

/** A typed slot_rep.
 * A typed slot_rep holds a functor that can be invoked from
 * slot::operator()(). visit_each() is used to visit the functor's
 * targets that inherit trackable recursively and register the
 * notification callback. Consequently the slot_rep object will be
 * notified when some referred object is destroyed or overwritten.
 */
template <class T_functor>
struct typed_slot_rep : public slot_rep
{
  typedef typed_slot_rep<T_functor> self;

  /* Use an adaptor type so that arguments can be passed as const references
   * through explicit template instantiation from slot_call#::call_it() */
  typedef typename adaptor_trait<T_functor>::adaptor_type adaptor_type;

  /** The functor contained by this slot_rep object. */
  adaptor_type functor_;

  /** Constructs an invalid typed slot_rep object.
   * The notification callback is registered using visit_each().
   * @param functor The functor contained by the new slot_rep object.
   */
  inline typed_slot_rep(const T_functor& functor)
    : slot_rep(nullptr, &destroy, &dup), functor_(functor)
    { sigc::visit_each_type<trackable*>(slot_do_bind(this), functor_); }

  inline typed_slot_rep(const typed_slot_rep& cl)
    : slot_rep(cl.call_, &destroy, &dup), functor_(cl.functor_)
    { sigc::visit_each_type<trackable*>(slot_do_bind(this), functor_); }

  typed_slot_rep& operator=(const typed_slot_rep& src) = delete;

  typed_slot_rep(typed_slot_rep&& src) = delete;
  typed_slot_rep& operator=(typed_slot_rep&& src) = delete;

  inline ~typed_slot_rep()
    {
      call_ = nullptr;
      destroy_ = nullptr;
      sigc::visit_each_type<trackable*>(slot_do_unbind(this), functor_);
    }

  /** Detaches the stored functor from the other referred trackables and destroys it.
   * This does not destroy the base slot_rep object.
   */
  static void* destroy(void* data)
    {
      self* self_ = static_cast<self*>(reinterpret_cast<slot_rep*>(data));
      self_->call_ = nullptr;
      self_->destroy_ = nullptr;
      sigc::visit_each_type<trackable*>(slot_do_unbind(self_), self_->functor_);
      self_->functor_.~adaptor_type();
      /* don't call disconnect() here: destroy() is either called
       * a) from the parent itself (in which case disconnect() leads to a segfault) or
       * b) from a parentless slot (in which case disconnect() does nothing)
       */
      return nullptr;
    }

  /** Makes a deep copy of the slot_rep object.
   * Deep copy means that the notification callback of the new
   * slot_rep object is registered in the referred trackables.
   * @return A deep copy of the slot_rep object.
   */
  static void* dup(void* data)
    {
      slot_rep* a_rep = reinterpret_cast<slot_rep*>(data);
      return static_cast<slot_rep*>(new self(*static_cast<self*>(a_rep)));
    }
};

FOR(0,CALL_SIZE,[[SLOT_CALL(%1)]])dnl

/** Abstracts functor execution.
 * call_it() invokes a functor of type @e T_functor with a list of
 * parameters whose types are given by the template arguments.
 * address() forms a function pointer from call_it().
 *
 * The following template arguments are used:
 * - @e T_functor The functor type.
 * - @e T_return The return type of call_it().
 * - @e T_arg Argument types used in the definition of call_it().
 *
 */
template<class T_functor, class T_return, class... T_arg>
struct slot_call
{
  /** Invokes a functor of type @p T_functor.
   * @param rep slot_rep object that holds a functor of type @p T_functor.
   * @param _A_a Arguments to be passed on to the functor.
   * @return The return values of the functor invocation.
   */
  static T_return call_it(slot_rep* rep, type_trait_take_t<T_arg>... a_)
    {
      using typed_slot = typed_slot_rep<T_functor>;
      typed_slot *typed_rep = static_cast<typed_slot*>(rep);
      return (typed_rep->functor_).SIGC_WORKAROUND_OPERATOR_PARENTHESES<type_trait_take_t<T_arg>...>
               (a_...);
    }

  /** Forms a function pointer from call_it().
   * @return A function pointer formed from call_it().
   */
  static hook address()
    { return reinterpret_cast<hook>(&call_it); }
};

/** Abstracts functor execution.
 * call_it() invokes a functor without parameters of type @e T_functor.
 * address() forms a function pointer from call_it().
 *
 * This is a specialization for functors without parameters.
 *
 * The following template arguments are used:
 * - @e T_functor The functor type.
 * - @e T_return The return type of call_it().
 *
 */
template<class T_functor, class T_return>
struct slot_call<T_functor, T_return>
{
  /** Invokes a functor of type @p T_functor.
   * @param rep slot_rep object that holds a functor of type @p T_functor.
   * @return The return values of the functor invocation.
   */
  static T_return call_it(slot_rep* rep)
    {
      using typed_slot = typed_slot_rep<T_functor>;
      typed_slot *typed_rep = static_cast<typed_slot*>(rep);
      return (typed_rep->functor_)();
    }

  /** Forms a function pointer from call_it().
   * @return A function pointer formed from call_it().
   */
  static hook address()
    { return reinterpret_cast<hook>(&call_it); }
};

} /* namespace internal */


FOR(0,CALL_SIZE,[[SLOT_N(%1,CALL_SIZE)]])
SLOT(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[SLOT(%1,CALL_SIZE)]])

/** Converts an arbitrary functor to a unified type which is opaque.
 * sigc::slot itself is a functor or, to be more precise, a closure. It contains
 * a single, arbitrary functor (or closure) that is executed in operator()().
 *
 * The template arguments determine the function signature of operator()():
 * - @e T_return The return type of operator()().
 * - @e T_arg Argument types used in the definition of operator()().
 *
 * For instance, to declare a slot that returns void and takes two parameters
 * of bool and int:
 * @code
 * sigc::slot<void(bool, int)> some_slot;
 * @endcode
 *
 * Alternatively, you may use this syntax:
 * @code
 * sigc::slot<void, bool, int> some_slot;
 * @endcode
 *
 * To use, simply assign the desired functor to the slot. If the functor
 * is not compatible with the parameter list defined with the template
 * arguments then compiler errors are triggered. When called, the slot
 * will invoke the functor with minimal copies.
 * block() and unblock() can be used to block the functor's invocation
 * from operator()() temporarily.
 *
 * @ingroup slot
 */
template <class T_return, class... T_arg>
class slot<T_return(T_arg...)>
  : public slot_base
{
public:
  using result_type = T_return;
  //TODO: using arg_type_ = type_trait_take_t<T_arg>;

#ifndef DOXYGEN_SHOULD_SKIP_THIS
private:
  using rep_type = internal::slot_rep;
public:
  using call_type = T_return (*)(rep_type*, type_trait_take_t<T_arg>...);
#endif

  /** Invoke the contained functor unless slot is in blocking state.
   * @param _A_a Arguments to be passed on to the functor.
   * @return The return value of the functor invocation.
   */
  inline T_return operator()(type_trait_take_t<T_arg>... _A_a) const
    {
      if (!empty() && !blocked())
        return (reinterpret_cast<call_type>(slot_base::rep_->call_))(slot_base::rep_, _A_a...);
      return T_return();
    }

  inline slot() {}

  /** Constructs a slot from an arbitrary functor.
   * @param _A_func The desired functor the new slot should be assigned to.
   */
  template <class T_functor>
  slot(const T_functor& _A_func)
    : slot_base(new internal::typed_slot_rep<T_functor>(_A_func))
    {
      //The slot_base:: is necessary to stop the HP-UX aCC compiler from being confused. murrayc.
      slot_base::rep_->call_ = internal::slot_call<T_functor, T_return, T_arg...>::address();
    }

  /** Constructs a slot, copying an existing one.
   * @param src The existing slot to copy.
   */
  slot(const slot& src)
    : slot_base(src)
    {}

  /** Constructs a slot, moving an existing one.
   * If @p src is connected to a parent (e.g. a signal), it is copied, not moved.
   * @param src The existing slot to move or copy.
   */
  slot(slot&& src)
    : slot_base(std::move(src))
    {}

  /** Overrides this slot, making a copy from another slot.
   * @param src The slot from which to make a copy.
   * @return @p this.
   */
  slot& operator=(const slot& src)
  {
    slot_base::operator=(src);
    return *this;
  }

  /** Overrides this slot, making a move from another slot.
   * If @p src is connected to a parent (e.g. a signal), it is copied, not moved.
   * @param src The slot from which to move or copy.
   * @return @p this.
   */
  slot& operator=(slot&& src)
  {
    slot_base::operator=(std::move(src));
    return *this;
  }
};

} /* namespace sigc */

#ifdef SIGC_NIL_HAS_BEEN_PUSHED
  #undef SIGC_NIL_HAS_BEEN_PUSHED
  #pragma pop_macro("nil")
#endif
