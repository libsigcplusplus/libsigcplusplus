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
ifelse($1, $2,
[template <LIST(class T_return, LOOP(class T_arg%1 = nil, $1))>],
[template <LIST(class T_return, LOOP(class T_arg%1, $1))>])
class slot ifelse($1, $2,,[<LIST(T_return, LOOP(T_arg%1,$1))>])
  : public internal::slot_base
{
  typedef internal::slot_rep rep_type;
  typedef T_return result_type;
FOR(1, $1,[  typedef _R_(T_arg%1) arg%1_type_;
])

  typedef T_return (*call_type)(LIST(rep_type*, LOOP(arg%1_type_, $1)));
  public:
    typedef T_return result_type;

    inline T_return operator()(LOOP(arg%1_type_ _A_a%1, $1)) const
      {
        if (!empty() && !blocked())
          return (reinterpret_cast<call_type>(rep_->call_))(LIST(rep_, LOOP(_A_a%1, $1)));
        return T_return();
      }

    inline slot() 
      {}

    template <class T_functor>
    slot(const T_functor& _A_func)
      : slot_base(new internal::typed_slot_rep<T_functor>(_A_func))
      { rep_->call_ = internal::slot_call$1<LIST(T_functor, T_return, LOOP(T_arg%1, $1))>::address(); }
};

])

define([SLOT_CALL],[dnl
template<LIST(class T_functor, class T_return, LOOP(class T_arg%1, $1))>
struct slot_call$1
{
  static T_return call_it(LIST(slot_rep* rep, LOOP(typename type_trait<T_arg%1>::take a_%1, $1)))
    {
      typedef typed_slot_rep<T_functor> typed_slot;
      typed_slot *typed_rep = static_cast<typed_slot*>(rep);
      return (typed_rep->functor_)(LOOP(a_%1, $1));
    }
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
    it will launch the functor with minimal copies. Because it is opaque
    visit_each will not visit any members contained within.

  Example:
    void foo(int) {}
    slot<void, long> cl = ptr_fun(&foo);

 */
__FIREWALL__
#include <sigc++/trackable.h>
#include <sigc++/visit_each.h>
#include <sigc++/functors/functor_trait.h>

namespace sigc {
struct nil;

namespace functor {
namespace internal {

typedef void* (*hook)(void*);

struct slot_base;

/** Internal representation of a slot.
 * Derivations of this class can be considered as a link
 * between a slot and the functor that the slot should
 * execute in operator(). This link is needed because in
 * libsigc++2 the slot doesn't necessarily have exactly the
 * same function signature as the functor allowing for implicit
 * conversions.
 * The base class slot_rep serves the purpose to
 * - form a common pointer type (slot_rep*),
 * - offer the possibility to create duplicates (dup()),
 * - offer a notification callback (notify()),
 * - implement some of slot_base's interface that depends
 *   on the notification callback, i.e.
 *   -- the possibility to set a single parent with a callback
 *      (set_parent()) that is executed from notify(),
 *   -- an generic function pointer, call_, that is simply
 *      set to zero in notify() to invalidate the slot.
 * slot_rep inherits trackable so that connection objects can
 * refer the slot and are notified when the slot is destroyed.
 */
struct slot_rep : public trackable
{
  /* Instead of slot_rep we could inherit slot_base from trackable.
     However, this slows down dereferencing of slot list iterators. Martin. */

  hook call_; // this can't be virtual, number of arguments must be flexible.
  hook cleanup_; 
  void* parent_;

  slot_rep()
    : call_(0), parent_(0) {}
  slot_rep(const slot_rep& cl)
    : call_(cl.call_), parent_(0) {}

  virtual slot_rep* dup() const = 0;
  virtual ~slot_rep()
    {}

  // slots have one parent exclusively.
  void set_parent(void* parent, hook cleanup)
    {
      parent_ = parent;
      cleanup_ = cleanup;
    }

  static void* notify(void* p);
};

/** Used to add a dependency to a trackable so that
 * slot_rep::notify gets executed when the trackable
 * is destroyed or overwritten.
 */
struct slot_do_bind
{
  slot_rep* rep_;
  inline slot_do_bind(slot_rep* rep) : rep_(rep) {}
  inline void operator()(const trackable* t) const
  { t->add_dependency(rep_, &slot_rep::notify); }
};

/** Used to remove a dependency from a trackable when
 * the slot dies before the trackable does.
 */
struct slot_do_unbind
{
  slot_rep* rep_;
  inline slot_do_unbind(slot_rep* rep) : rep_(rep) {}
  inline void operator()(const trackable* t) const
  { t->remove_dependency(rep_); }
};

/** A typed slot_rep.
 * A typed slot_rep holds a functor which can be called from
 * operator() of the slot templates.
 */
template <class T_functor>
struct typed_slot_rep : public slot_rep
{
  public:
    inline typed_slot_rep(const T_functor& functor)
      : functor_(functor)
      { visit_each_type<trackable*>(slot_do_bind(this), functor_); }
    inline typed_slot_rep(const typed_slot_rep& cl)
      : slot_rep(cl), functor_(cl.functor_)
      { visit_each_type<trackable*>(slot_do_bind(this), functor_); }
    virtual ~typed_slot_rep()
      { visit_each_type<trackable*>(slot_do_unbind(this), functor_); }
    virtual slot_rep* dup() const
      { return new typed_slot_rep<T_functor>(*this); }
    T_functor functor_;
};

/** Base type for slots.
 * slot_base integrates most of the interface of the derived
 * slot templates (therefore reducing code size). slots
 * can be connected to signals, be disconnected at some later point
 * (disconnect()) and temporarily be blocked (block(), unblock()).
 * slot_base has a slot_rep* member, rep_, that is filled in
 * from the constructors of its derivations. set_parent() is
 * used to add a notification callback that is executed when the
 * slot gets invalid. The validity of a slot can be tested
 * with empty().
 * add_dependency() is used by connection objects to add a notification
 * callback that is executed on destruction.
 */
class slot_base : public functor_base
{
  typedef internal::slot_rep rep_type;

  public:
    slot_base()
      : rep_(0), blocked_(false) {}

    slot_base(rep_type* rep)
      : rep_(rep), blocked_(false) {}

    slot_base(const slot_base& cl_)
      : rep_(0), blocked_(cl_.blocked_) { if (cl_.rep_) rep_ = cl_.rep_->dup(); }

    ~slot_base()
      { if (rep_) delete rep_; }

    // hook for signals
    void set_parent(void* parent, void* (*cleanup)(void*)) const
      { if (rep_) rep_->set_parent(parent, cleanup); }

    void add_dependency(void* o, void* (f)(void*)) const
      { if (rep_) rep_->add_dependency(o, f); }
    void remove_dependency(void* o) const
      { if (rep_) rep_->remove_dependency(o); }

    inline bool empty() const
      { return (!rep_ || !rep_->call_); }

    inline bool blocked() const
      { return blocked_; }

    bool block(bool should_block = true);

    bool unblock()
      { return block(false); }

    void disconnect()                   // Disconnecting a slot always means destroying it.
      { if (rep_) rep_->notify(rep_); } // => notify() marks it as invalid and notifies the parent.

    slot_base& operator = (const slot_base& cl);

//  protected:
    mutable rep_type *rep_;
    bool blocked_;
};

/** slot_call#<>::call_it() executes the functor that is held
 * by the typed_slot_rep. This template is "responsible" for
 * our type safety: If the compiler cannot convert the parameter
 * list of the slot to the parameter list of the functor an
 * error will occur here.
 */
FOR(0,CALL_SIZE,[[SLOT_CALL(%1)]])
} /* namespace internal */

/** Converts an arbitrary functor to a unified type which is opaque.
 * To use simply assign the slot to the desirer functor. When called
 * it will launch the functor with minimal copies. Because it is opaque
 * visit_each will not visit any members contained within.
 *
 * Example:
 *   void foo(int) {}
 *   slot<void, long> cl = ptr_fun(&foo);
 *
 */
SLOT(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[SLOT(%1,CALL_SIZE)]])

} /* namespace functor */
} /* namespace sigc */
