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
 
define([SLOT],[dnl
ifelse($1, $2,[dnl
/** Converts an arbitrary functor to a unified type which is opaque.
 * slot itself is a functor or to be more precise a closure. It contains
 * a single, arbitrary functor (or closure) that is executed in operator()().
 *
 * The template arguments determine the function signature of operator()():
 * - @e T_return The return type of operator()().dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()(). The default @p nil means no argument.])
 *
 * To use simply assign the slot to the desired functor. If the functor
 * is not compatible with the parameter list defined with the template
 * arguments compiler errors are triggered. When called the slot
 * will invoke the functor with minimal copies.
 * block() and unblock() can be used to block the functor's invocation
 * from operator()() temporarily.
 *
 * @par Example:
 *   @code
 *   void foo(int) {}
 *   sigc::slot<void, long> s = sigc::ptr_fun(&foo);
 *   s(19);
 *   @endcode
 *
 * @ingroup slot functors
 */
/* TODO: Where put the following bit of information? I can't make any
 *       sense of the "because", by the way!
 *
 * Because slot is opaque visit_each() will not visit any members
 * contained within.
 */
template <LIST(class T_return, LOOP(class T_arg%1 = nil, $1))>],[dnl
/** Converts an arbitrary functor to a unified type which is opaque.
 * This is the template specialization of the slot<> template
 * for $1 arguments.
 *
 * @ingroup slot functors
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>])
class slot ifelse($1, $2,,[<LIST(T_return, LOOP(T_arg%1,$1))>])
  : public slot_base
{
public:
  typedef T_return result_type;
FOR(1, $1,[  typedef _R_(T_arg%1) arg%1_type_;
])

#ifndef DOXYGEN_SHOULD_SKIP_THIS
private:
  typedef internal::slot_rep rep_type;
  typedef T_return (*call_type)(LIST(rep_type*, LOOP(arg%1_type_, $1)));
#endif

public:
  /** Invoke the contained functor unless slot is in blocking state.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the functor.])
   * @return The return value of the functor invocation.
   */
  inline T_return operator()(LOOP(arg%1_type_ _A_a%1, $1)) const
    {
      if (!empty() && !blocked())
        return (reinterpret_cast<call_type>(rep_->call_))(LIST(rep_, LOOP(_A_a%1, $1)));
      return T_return();
    }

  /** Constructs an empty slot. */
  inline slot() 
    {}

  /** Constructs a slot from an arbitrary functor.
   * @param _A_func The desirer functor the new slot should be assigned to.
   */
  template <class T_functor>
  slot(const T_functor& _A_func)
    : slot_base(new internal::typed_slot_rep<T_functor>(_A_func))
    { rep_->call_ = internal::slot_call$1<LIST(T_functor, T_return, LOOP(T_arg%1, $1))>::address(); }
};

])

define([SLOT_CALL],[dnl
/** Abstracts functor execution.
 * call_it() invokes a functor of type @p T_functor with a list of
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
  static T_return call_it(LIST(slot_rep* rep, LOOP(typename type_trait<T_arg%1>::take a_%1, $1)))
    {
      typedef typed_slot_rep<T_functor> typed_slot;
      typed_slot *typed_rep = static_cast<typed_slot*>(rep);
      return (typed_rep->functor_)(LOOP(a_%1, $1));
    }

  /** Forms a function pointer from call_it().
   * @return A function pointer formed from call_it().
   */
  static hook address() 
    { return reinterpret_cast<hook>(&call_it); }
};

])

divert(0)dnl
/*
  Type slot<R, A1, A2...>

  Usage:
    Converts an arbitrary functor to a unified type which is opaque.
    To use simply assign the slot to the desirer functor. When called
    it will invoke the functor with minimal copies. Because it is opaque
    visit_each() will not visit any members contained within.

  Example:
    void foo(int) {}
    slot<void, long> cl = ptr_fun(&foo);

 */
__FIREWALL__
#include <sigc++/trackable.h>
#include <sigc++/visit_each.h>
#include <sigc++/functors/functor_trait.h>

namespace sigc {

/** nil struct type.
 * The nil struct type is used as default template argument in the
 * unnumbered signal<> and slot<> templates. Template specializations
 * for the last m of n template arguments being "nil" can use other,
 * numbered templates, like signal#<>, knowing that # = (n-m).
 */
struct nil;

namespace internal {

typedef void* (*hook)(void*);

/** Internal representation of a slot.
 * Derivations of this class can be considered as a link
 * between a slot and the functor that the slot should
 * execute in operator(). This link is needed because in
 * libsigc++2 the slot doesn't necessarily have exactly the
 * same function signature as the functor thus allowing for
 * implicit conversions.
 * The base class slot_rep serves the purpose to
 * - form a common pointer type (slot_rep*),
 * - offer the possibility to create duplicates (dup()),
 * - offer a notification callback (notify()),
 * - implement some of slot_base's interface that depends
 *   on the notification callback, i.e.
 *   -# the possibility to set a single parent with a callback
 *      (set_parent()) that is executed from notify(),
 *   -# a generic function pointer, call_, that is simply
 *      set to zero in notify() to invalidate the slot.
 * slot_rep inherits trackable so that connection objects can
 * refer to the slot and are notified when the slot is destroyed.
 */
struct slot_rep : public trackable
{
  /* NB: Instead of slot_rep we could inherit slot_base from trackable.
   * However, a simple benchmark seems to indicate that this slows
   * down dereferencing of slot list iterators. Martin. */

  /** Callback that invokes the contained functor.
   * This can't be a virtual function since number of arguments
   * must be flexible. We use function pointers to slot_call::call_it()
   * instead. call_ is set to zero to indicate that the slot is invalid.
   */
  hook call_;

  /** Callback of parent_. */
  hook cleanup_;

  /** Parent object whose callback cleanup_ is executed on notification. */
  void* parent_;

  /** Constructs an empty slot_rep object. */
  slot_rep()
    : call_(0), parent_(0) {}

  /** Constructs a slot_rep object making a shallow copy of an existing one. */
  slot_rep(const slot_rep& cl)
    : call_(cl.call_), parent_(0) {}

  /** Makes a deep copy of the slot_rep object.
   * @return A deep copy of the slot_rep object.
   */
  virtual slot_rep* dup() const = 0;

  virtual ~slot_rep()
    {}

  /** Set the parent with a callback.
   * slots have one parent exclusively.
   * @param parent The new parent.
   * @param cleanup The callback to execute from notify().
   */
  void set_parent(void* parent, hook cleanup)
    {
      parent_ = parent;
      cleanup_ = cleanup;
    }

  /** Callback that is executed when the slot becomes invalid.
   * This callback is registered in every object referred by
   * this slot_rep object that inherits trackable. It is executed
   * when the slot becomes invalid because of some referred object dying.
   * It invalidates the slot setting call_ to zero and executes the
   * parent's cleanup callback.
   * @param d The slot_rep object that is becoming invalid (@p this).
   */
  static void* notify(void* data);
};

/** Functor used to add a dependency to a trackable.
 * Consequently slot_rep::notify() gets executed when the
 * trackable is destroyed or overwritten.
 */
struct slot_do_bind
{
  /** The slot_rep object trackables should notify on destruction. */
  slot_rep* rep_;

  /** Construct a slot_do_bind functor.
   * @param rep The slot_rep object trackables should notify on destruction.
   */
  inline slot_do_bind(slot_rep* rep) : rep_(rep) {}

  /** Adds a dependency to @p t.
   * @param t The trackable object to add a callback to.
   */
  inline void operator()(const trackable* t) const
    { t->add_destroy_notify_callback(rep_, &slot_rep::notify); }
};

/** Functor used to remove a dependency from a trackable.
 * This is used when the slot dies before the trackable does.
 */
struct slot_do_unbind
{
  /** The slot_rep object trackables don't need to notify on destruction any more. */
  slot_rep* rep_;

  /** Construct a slot_do_unbind functor.
   * @param rep The slot_rep object trackables don't need to notify on destruction any more.
   */
  inline slot_do_unbind(slot_rep* rep) : rep_(rep) {}

  /** Removes a dependency from @p t.
   * @param t The trackable object to remove the callback from.
   */
  inline void operator()(const trackable* t) const
    { t->remove_destroy_notify_callback(rep_); }
};

/** A typed slot_rep.
 * A typed slot_rep holds a functor that can be invoked from
 * slot::operator()(). visit_each() is used to visit the functor's
 * targets that inherit trackable recursively and register the
 * notification callback. Consequently the slot_rep object will be
 * notified when some referred object is destroyed or overridden.
 */
template <class T_functor>
struct typed_slot_rep : public slot_rep
{
  /** The functor contained by this slot_rep object. */
  T_functor functor_;

  /** Constructs a typed slot_rep object.
   * The notification callback is registered using visit_each().
   * @param functor The functor contained by the new slot_rep object.
   */
  inline typed_slot_rep(const T_functor& functor)
    : functor_(functor)
    { visit_each_type<trackable*>(slot_do_bind(this), functor_); }

  /** Constructs a typed slot_rep object.
   * The notification callback is registered using visit_each().
   * @param functor The functor contained by the new slot_rep object.
   */
  inline typed_slot_rep(const typed_slot_rep& cl)
    : slot_rep(cl), functor_(cl.functor_)
    { visit_each_type<trackable*>(slot_do_bind(this), functor_); }

  /** Destroys the typed slot_rep object.
   * The notification callback is unregistered using visit_each().
   */
  virtual ~typed_slot_rep()
    { visit_each_type<trackable*>(slot_do_unbind(this), functor_); }

  /** Makes a deep copy of the slot_rep object.
   * Deep copy means that the notification callback of the new
   * slot_rep object is registered in the referred trackables.
   * @return A deep copy of the slot_rep object.
   */
  virtual slot_rep* dup() const
    { return new typed_slot_rep<T_functor>(*this); }
};

} /* namespace internal */

/** @defgroup functors functors
 * Functors are copyable types that define operator()().
 *
 * Types that define operator()() overloads with different return types
 * are referred to as multi-type functors. Multi-type functors are only
 * partly supported in libsigc++.
 *
 * Closures are functors that store all information needed to invoke
 * a callback from operator()().
 *
 * Adaptors are functors that alter the signature of a functor's
 * operator()().
 *
 * libsigc++ defines numerous functors, closures and adaptors.
 * Since libsigc++ is a callback libaray, most functors are also
 * closures. Therefore the documentation doesn't distinguish between
 * functors and closures. The basic functor types libsigc++ defines
 * are listed below. Adaptors are documented here ... TODO ...
 */

/** @defgroup slot slot
 * Slots are type-safe representations of callback methods and functions.
 * A Slot can be constructed from any function, regardless of whether it is
 * a global function, a member method, static, or virtual.
 *
 * Use the sigc::mem_fun() and sigc::ptr_fun() template functions to get a sigc::slot, like so:
 * @code
 * sigc::slot<void, int> slot = sigc::mem_fun(someobj, &SomeClass::somemethod);
 * @endcode
 * or
 * @code
 * sigc::slot<void, int> slot = sigc::ptr_fun(&somefunction);
 * @endcode
 * or
 * @code
 * m_Button.signal_clicked().connect( sigc::mem_fun(*this, &MyWindow::on_button_clicked) );
 * @endcode
 * The compiler will complain if SomeClass::somemethod has the wrong signature.
 *
 * You can also pass slots as method parameters where you might normally pass a function pointer.
 */

/** Base type for slots.
 * slot_base integrates most of the interface of the derived
 * slot templates (therefore reducing code size). slots
 * can be connected to signals, be disconnected at some later point
 * (disconnect()) and temporarily be blocked (block(), unblock()).
 * The validity of a slot can be tested with empty().
 *
 * The internal representation is a slot_rep derived type and built
 * from slot_base's derivations. set_parent() is used to register
 * a notification callback that is executed when the slot gets invalid. 
 * add_destroy_notify_callback() is used by connection objects to add
 * a notification callback that is executed on destruction.
 *
 * @ingroup slot
 */
class slot_base : public functor_base
{
  typedef internal::slot_rep rep_type;

public:
  /// Constructs an empty slot.
  slot_base()
    : rep_(0), blocked_(false) {}

  /** Constructs a slot from an existing slot_rep object.
   * @param rep The slot_rep object this slot should contain.
   */
  explicit slot_base(rep_type* rep)
    : rep_(rep), blocked_(false) {}

  /** Constructs a slot, copying an existing one.
   * @param cl_ The existing slot to copy.
   */
  slot_base(const slot_base& src)
    : rep_(0), blocked_(src.blocked_)
    { if (src.rep_) rep_ = src.rep_->dup(); }

  ~slot_base()
    { if (rep_) delete rep_; }

  /** Sets the parent of this slot.
   * This function is used by signals to register a notification callback.
   * This notification callback is executed when the slot becomes invalid
   * because of some referred object dying.
   * @param parent The new parent.
   * @param cleanup The notification callback.
   */
  void set_parent(void* parent, void* (*cleanup)(void*)) const
    { if (rep_) rep_->set_parent(parent, cleanup); }

  /** Add a callback that is executed (notified) when the slot is detroyed.
   * This function is used internally by connection objects.
   * @param data Passed into func upon notification.
   * @param func Callback executed upon destruction of the object.
   */
  void add_destroy_notify_callback(void* data, void* (*func)(void*)) const
    { if (rep_) rep_->add_destroy_notify_callback(data, func); }

  /** Remove a callback previously installed with add_destroy_notify_callback().
   * The callback is not executed.
   * @param data Parameter passed into previous call to add_destroy_notify_callback().
   */
  void remove_destroy_notify_callback(void* data) const
    { if (rep_) rep_->remove_destroy_notify_callback(data); }

  /** Returns whether the slot is invalid.
   * @return @p true if the slot is invalid (empty).
   */
  inline bool empty() const
    { return (!rep_ || !rep_->call_); }

  /** Returns whether the slot is blocked.
   * @return @p true if the slot is blocked.
   */
  inline bool blocked() const
    { return blocked_; }

  /** Sets the blocking state.
   * If @p should_block is @p true then the blocking state is set.
   * Subsequent calls to slot::operator()() don't invoke the functor
   * (TODO: launch is not a good word to use here or in the rest of the docs)
   * (TODO: Be more constructive: is invoke okay as alternative?)
   * contained by this slot until unblock() or block() with
   * @p should_block == @p false is called.
   * @param should_block Indicates whether the blocking state should be set or unset.
   * @return @p true if the slot was in blocking state before.
   */
  bool block(bool should_block = true);

  /** Unsets the blocking state.
   * @return @p true if the slot was in blocking state before.
   */
  bool unblock()
    { return block(false); }

  /** Disconnects the slot.
   * Invalidates the slot and notifies the parent.
   */
  void disconnect()                   // Disconnecting a slot always means destroying it.
    { if (rep_) rep_->notify(rep_); } // => notify() marks it as invalid and notifies the parent.

  /** Overrides this slot making a copy from another slot.
   * @param src The slot from which to make a copy.
   * @return @p this.
   */
  slot_base& operator = (const slot_base& src);

//  protected: // public to avoid template friend declarations
  /** Typed slot_rep object that contains a functor. */
  mutable rep_type *rep_;

  /** Indicates whether the slot is blocked. */
  bool blocked_;
};

namespace internal {

FOR(0,CALL_SIZE,[[SLOT_CALL(%1)]])
} /* namespace internal */

SLOT(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[SLOT(%1,CALL_SIZE)]])

} /* namespace sigc */
