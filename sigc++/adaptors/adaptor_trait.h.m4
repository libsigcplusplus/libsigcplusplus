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

dnl
dnl The idea here is simple.  To prevent the need to 
dnl specializing every adaptor for every type of functor
dnl and worse non-functors like function pointers, we
dnl will make an adaptor trait which can take ordinary
dnl functors and make them adaptor functors for which 
dnl we will of course be able to avoid excess copies. 
dnl (in theory)
dnl
dnl this all depends on partial specialization to allow
dnl us to do
dnl   functor_.template operator() <types> (args);
dnl

dnl I don't understand much of the above. However, I can
dnl see that adaptors are implemented like they are because
dnl there is no way to extract the return type and the argument
dnl types from a functor type. Therefore, operator() is templated.
dnl It's instatiated in slot_call#<>::operator() where the
dnl argument types are known. The return type is finally determined
dnl via the callof<> template - a tricky way to detect the return
dnl type of a functor when the argument types are known. Martin.

])
define([ADAPTOR_DO],[dnl
ifelse($1,0,[dnl
dnl  typename internal::callof_safe0<T_functor>::result_type // doesn't compile if T_functor has an overloaded operator()!
dnl  typename functor_trait<T_functor>::result_type
dnl  operator()() const
dnl    { return functor_(); }
],[dnl
  template <LOOP([class T_arg%1], $1)>
  typename deduce_result_type<LOOP(T_arg%1, $1)>::type
  operator()(LOOP(T_arg%1 _A_arg%1, $1)) const
    { return functor_(LOOP(_A_arg%1, $1)); }

])dnl
])

divert(0)dnl
/*
  Hint adaptor_base:
    Functors which have all methods based on templates 
  should derive from this type so that the type arguments are
  passed to the operator() thus saving copy costs.  This
  is also derived from the functor_base hint so it should
  have a result_type defined.
    Ie.  
      struct my_functor : public adaptor_base
        {
          typedef void result_type;
          template <class Arg1>
          void operator(Arg1 a1);
          template <class Arg1, class Arg2>
          void operator(Arg1 a1, Arg2 a2);
        };

  Hint adapts<functor>:
    A simple way to wrap a functor when proxying its
  call.  It has the added benefit of automatically wrapping
  non-functors such as function pointers and methods as 
  functors automatically.  It derives from the adaptor_base
  hint and contains a single member functor which is always
  an adaptor_base.  It has a typedef adaptor_type for which
  you should refer to as the contained functor type as
  the functor type may be changed.

  Adaptor adaptor_functor<functor>:
    This is the do nothing functor.  It just changes
  the operators to take template parameters so we
  can pass type hints.  It derives from adaptor_base

  Trait adaptor_trait<functor, bool>:
    This trait allows the user to specific what is the
  adaptor version of any type.  It automatically wraps
  function pointers and class methods as well.  

*/
__FIREWALL__
#include <sigc++/visit_each.h>
#include <sigc++/functors/functor_trait.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/adaptors/deduce_result_type.h>

namespace sigc { 
namespace functor {

template <class T_functor> struct adapts;

template <class T_functor>
struct adaptor_functor : public adaptor_base
{
  template <LOOP(class T_arg%1=void, CALL_SIZE)>
  struct deduce_result_type
    { typedef typename sigc::functor::deduce_result_type<LIST(T_functor, LOOP(T_arg%1,CALL_SIZE))>::type type; };
  typedef typename functor_trait<T_functor>::result_type result_type;

  operator T_functor& () const { return functor_; }

  result_type
  operator()() const;

FOR(0,CALL_SIZE,[[ADAPTOR_DO(%1)]])dnl
  adaptor_functor()
    {}
  adaptor_functor(const T_functor& _A_functor)
    : functor_(_A_functor)
    {}
  template <class T_type>
  adaptor_functor(T_type& _A_type)
    : functor_(_A_type)
    {}
  template <class T_type>
  adaptor_functor(const T_type& _A_type)
    : functor_(_A_type)
    {}

  mutable T_functor functor_;
};

template <class T_functor>
typename adaptor_functor<T_functor>::result_type
adaptor_functor<T_functor>::operator()() const
  { return functor_(); }


template <class T_action, class T_functor>
void visit_each(const T_action& _A_action,
                const adaptor_functor<T_functor>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
}


/******************************************************/

// adaptor to permit classes to use the adaptor to build the type
// quickly.
template <class T_functor, bool I_isadaptor = is_base_and_derived<adaptor_base, T_functor>::value> struct adaptor_trait;

// if it already is an adaptor functor, great just use it.
template <class T_functor> 
struct adaptor_trait<T_functor, true>
{
  typedef typename T_functor::result_type result_type;
  typedef T_functor functor_type;
  typedef T_functor adaptor_type;
};

// if not, well make it one.
template <class T_functor>
struct adaptor_trait<T_functor, false>
{
  typedef typename functor_trait<T_functor>::result_type result_type;
  typedef typename functor_trait<T_functor>::functor_type functor_type;
  typedef adaptor_functor<functor_type> adaptor_type;
};

/******************************************************/


template <class T_functor>
struct adapts : public adaptor_base
{
  typedef typename adaptor_trait<T_functor>::result_type  result_type;
  typedef typename adaptor_trait<T_functor>::adaptor_type adaptor_type;

  adapts(const T_functor& _A_functor)
    : functor_(_A_functor)
    {}

  mutable adaptor_type functor_;
};

} /* namespace functor */
} /* namespace sigc */
