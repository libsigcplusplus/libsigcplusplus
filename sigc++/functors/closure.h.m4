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

    T_return operator()(LOOP(arg%1_type_ _A_a%1, $1)) const
      {
        if (!empty() && !blocked())
          return (reinterpret_cast<call_type>(rep_->call_))(LIST(rep_, LOOP(_A_a%1, $1)));
        return T_return();
      }

    closure() 
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
  usage:
    Converts an arbitrary functor to a unified type which is opaque.
  To use simply assign the closure to the desirer functor.  When called
  it will launch the functor with minimal copies.  Because it is opaque
  visit_each will not visit any members contained within.
                
  Ie.
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

// Internal representation of a closure.    
struct closure_rep
{
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
  void set_dependency(void* parent, hook cleanup)
    {
      parent_ = parent;
      cleanup_ = cleanup;
    }

  static void* notify(void* p);
};

// base type for closures to reduce code size
class closure_base /*: public functor_base*/
{
  typedef internal::closure_rep rep_type;

  public:
    closure_base()
      : rep_(0), blocked_(false) {}

    closure_base(rep_type* rep)
      : rep_(rep), blocked_(false) {}

    closure_base(const closure_base& cl_)
      : rep_(0), blocked_(cl_.blocked_)
      {
        if (cl_.rep_)
          rep_ = cl_.rep_->dup();
      }

    ~closure_base()
      { delete rep_; }

    // hook for signals
    void set_dependency(void* parent, void* (*func)(void*)) const;

    bool empty() const;

    bool blocked() const
      { return blocked_; }

    bool block(bool should_block = true);

    bool unblock()
      { return block(false); }

    void disconnect();

    closure_base& operator = (const closure_base& cl);

  protected:
    mutable rep_type *rep_;
    bool blocked_;
};

// This places the back dependency for trackable to disconnect closures
struct closure_do_bind
{
  closure_rep* rep_;
  closure_do_bind(closure_rep* rep) : rep_(rep) {}
  void operator()(const trackable* t) const
  { t->add_dependency(rep_, &closure_rep::notify); }
};
struct closure_do_unbind
{
  closure_rep* rep_;
  closure_do_unbind(closure_rep* rep) : rep_(rep) {}
  void operator()(const trackable* t) const
  { t->remove_dependency(rep_); }
};

// A typed closure is one which can be called.
template <class T_functor>
struct typed_closure_rep : public closure_rep
{
  public:
    typed_closure_rep(const T_functor& functor)
      : functor_(functor)
      { visit_each_type<trackable*>(closure_do_bind(this), functor_); }
    typed_closure_rep(const typed_closure_rep& cl)
      : closure_rep(cl), functor_(cl.functor_)
      { visit_each_type<trackable*>(closure_do_bind(this), functor_); }
    virtual ~typed_closure_rep()
      { visit_each_type<trackable*>(closure_do_unbind(this), functor_); }
    virtual closure_rep* dup() const
      { return new typed_closure_rep<T_functor>(*this); }
    T_functor functor_;
};


FOR(0,CALL_SIZE,[[CLOSURE_CALL(%1)]])
} /* namespace internal */

CLOSURE(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[CLOSURE(%1,CALL_SIZE)]])

} /* namespace functor */
} /* namespace sigc */
