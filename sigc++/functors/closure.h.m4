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

define([CLOSURE],[dnl
ifelse($1, $2,
[template <LIST(class T_return, LOOP(class T_arg%1 = nil, $1))>],
[template <LIST(class T_return, LOOP(class T_arg%1, $1))>])
class closure ifelse($1, $2,,[<LIST(T_return, LOOP(T_arg%1,$1))>])
  : public internal::closure_base
{
  typedef internal::closure_rep rep_type;
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

    inline closure() 
      {}

    template <class T_functor>
    closure(const T_functor& _A_func)
      : closure_base(new internal::typed_closure_rep<T_functor>(_A_func))
      { rep_->call_ = internal::closure_call$1<LIST(T_functor, T_return, LOOP(T_arg%1, $1))>::address(); }
};

])

define([CLOSURE_CALL],[dnl
template<LIST(class T_functor, class T_return, LOOP(class T_arg%1, $1))>
struct closure_call$1
{
  static T_return call_it(LIST(closure_rep* rep, LOOP(typename type_trait<T_arg%1>::take a_%1, $1)))
    {
      typedef typed_closure_rep<T_functor> typed_closure;
      typed_closure *typed_rep = static_cast<typed_closure*>(rep);
      return (typed_rep->functor_)(LOOP(a_%1, $1));
    }
  static hook address() 
    { return reinterpret_cast<hook>(&call_it); }
};

])

divert(0)dnl
/*
  Type closure<R, A1, A2...>

  Usage:
    Converts an arbitrary functor to a unified type which is opaque.
    To use simply assign the closure to the desirer functor. When called
    it will launch the functor with minimal copies. Because it is opaque
    visit_each will not visit any members contained within.

  Example:
    void foo(int) {}
    closure<void, long> cl = ptr_fun(&foo);

 */
__FIREWALL__
#include <sigc++/trackable.h>
#include <sigc++/visit_each.h>
dnl #include <sigc++/functor/functor_trait.h>

namespace sigc {
struct nil;

namespace functor {
namespace internal {

typedef void* (*hook)(void*);

struct closure_base;

/** Internal representation of a closure.
 * Derivations of this class can be considered as a link
 * between a closure and the functor that the closure should
 * execute in operator(). This link is needed because in
 * libsigc++2 the closure doesn't necessarily have exactly the
 * same function signature as the functor allowing for implicit
 * conversions.
 * The base class closure_rep serves the purpose to
 * - form a common pointer type (closure_rep*),
 * - offer the possibility to create duplicates (dup()),
 * - offer a notification callback (notify()),
 * - implement some of closure_base's interface that depends
 *   on the notification callback, i.e.
 *   -- the possibility to set a single parent with a callback
 *      (set_parent()) that is executed from notify(),
 *   -- an generic function pointer, call_, that is simply
 *      set to zero in notify() to invalidate the closure.
 * closure_rep inherits trackable so that connection objects can
 * refer the closure and are notified when the closure is destroyed.
 */
struct closure_rep : public trackable
{
  /* Instead of closure_rep we could inherit closure_base from trackable.
     However, this slows down dereferencing of closure list iterators. Martin. */

  hook call_; // this can't be virtual, number of arguments must be flexible.
  hook cleanup_; 
  void* parent_;

  closure_rep()
    : call_(0), parent_(0) {}
  closure_rep(const closure_rep& cl)
    : call_(cl.call_), parent_(0) {}

  virtual closure_rep* dup() const = 0;
  virtual ~closure_rep()
    {}

  // closures have one parent exclusively.
  void set_parent(void* parent, hook cleanup)
    {
      parent_ = parent;
      cleanup_ = cleanup;
    }

  static void* notify(void* p);
};

/** Used to add a dependency to a trackable so that
 * closure_rep::notify gets executed when the trackable
 * is destroyed or overwritten.
 */
struct closure_do_bind
{
  closure_rep* rep_;
  inline closure_do_bind(closure_rep* rep) : rep_(rep) {}
  inline void operator()(const trackable* t) const
  { t->add_dependency(rep_, &closure_rep::notify); }
};

/** Used to remove a dependency from a trackable when
 * the closure dies before the trackable does.
 */
struct closure_do_unbind
{
  closure_rep* rep_;
  inline closure_do_unbind(closure_rep* rep) : rep_(rep) {}
  inline void operator()(const trackable* t) const
  { t->remove_dependency(rep_); }
};

/** A typed closure_rep.
 * A typed closure_rep holds a functor which can be called from
 * operator() of the closure templates.
 */
template <class T_functor>
struct typed_closure_rep : public closure_rep
{
  public:
    inline typed_closure_rep(const T_functor& functor)
      : functor_(functor)
      { visit_each_type<trackable*>(closure_do_bind(this), functor_); }
    inline typed_closure_rep(const typed_closure_rep& cl)
      : closure_rep(cl), functor_(cl.functor_)
      { visit_each_type<trackable*>(closure_do_bind(this), functor_); }
    virtual ~typed_closure_rep()
      { visit_each_type<trackable*>(closure_do_unbind(this), functor_); }
    virtual closure_rep* dup() const
      { return new typed_closure_rep<T_functor>(*this); }
    T_functor functor_;
};

/** Base type for closures.
 * closure_base integrates most of the interface of the derived
 * closure templates (therefore reducing code size). closures
 * can be connected to signals, be disconnected at some later point
 * (disconnect()) and temporarily be blocked (block(), unblock()).
 * closure_base has a closure_rep* member, rep_, that is filled in
 * from the constructors of its derivations. set_parent() is
 * used to add a notification callback that is executed when the
 * closure gets invalid. The validity of a closure can be tested
 * with empty().
 * add_dependency() is used by connection objects to add a notification
 * callback that is executed on destruction.
 */
class closure_base /*: public functor_base*/
{
  typedef internal::closure_rep rep_type;

  public:
    closure_base()
      : rep_(0), blocked_(false) {}

    closure_base(rep_type* rep)
      : rep_(rep), blocked_(false) {}

    closure_base(const closure_base& cl_)
      : rep_(0), blocked_(cl_.blocked_) { if (cl_.rep_) rep_ = cl_.rep_->dup(); }

    ~closure_base()
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

    void disconnect()                   // Disconnecting a closure always means destroying it.
      { if (rep_) rep_->notify(rep_); } // => notify() marks it as invalid and notifies the parent.

    closure_base& operator = (const closure_base& cl);

//  protected:
    mutable rep_type *rep_;
    bool blocked_;
};

/** closure_call#<>::call_it() executes the functor that is held
 * by the typed_closure_rep. This template is "responsible" for
 * our type safety: If the compiler cannot convert the parameter
 * list of the closure to the parameter list of the functor an
 * error will occur here.
 */
FOR(0,CALL_SIZE,[[CLOSURE_CALL(%1)]])
} /* namespace internal */

/** Converts an arbitrary functor to a unified type which is opaque.
 * To use simply assign the closure to the desirer functor. When called
 * it will launch the functor with minimal copies. Because it is opaque
 * visit_each will not visit any members contained within.
 *
 * Example:
 *   void foo(int) {}
 *   closure<void, long> cl = ptr_fun(&foo);
 *
 */
CLOSURE(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[CLOSURE(%1,CALL_SIZE)]])

} /* namespace functor */
} /* namespace sigc */
