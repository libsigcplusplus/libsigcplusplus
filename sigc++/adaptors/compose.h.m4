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

define([COMPOSE1_OPERATOR],[dnl
  template <LOOP(class T_arg%1, $1)>
  typename callof<T_setter,
    typename callof<LIST(T_getter, LOOP(T_arg%1, $1))>::result_type
        >::result_type
  operator()(LOOP(T_arg%1 _A_a%1, $1))
    { return functor_(get_(LOOP(_A_a%1, $1))); }
])

define([COMPOSE2_OPERATOR],[dnl
  template <LOOP(class T_arg%1, $1)>
  typename callof<T_setter,
    typename callof<LIST(T_getter1, LOOP(T_arg%1, $1))>::result_type,
    typename callof<LIST(T_getter2, LOOP(T_arg%1, $1))>::result_type
        >::result_type
  operator()(LOOP(T_arg%1 _A_a%1, $1))
    { return functor_(get1_(LOOP(_A_a%1, $1)), get2_(LOOP(_A_a%1,$1))); }
])

divert(0)
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc {
namespace functor {

template <class T_setter, class T_getter, class T_return = typename adapts<T_setter>::result_type>
struct compose1_functor : public adapts<T_setter>
{
  typedef T_return result_type;
  typedef typename adapts<T_setter>::adaptor_type adaptor_type;

  result_type // TODO: conflicts with our previous explanation that result_type is the return type of the functor's operator() overload with no arguments!
  operator()();

FOR(1,CALL_SIZE,[[COMPOSE1_OPERATOR(%1)]])

  compose1_functor() {}
  compose1_functor(const T_setter& _A_setter, const T_getter& _A_getter)
    : adapts<T_setter>(_A_setter), get_(_A_getter)
    {}
  ~compose1_functor() {}

//  protected: 
    T_getter get_; 
};

template <class T_setter, class T_getter, class T_return>
typename compose1_functor<T_setter, T_getter, T_return>::result_type
compose1_functor<T_setter, T_getter, T_return>::operator()()
  { return functor_(get_()); }

// void specialization
template <class T_setter, class T_getter>
struct compose1_functor<T_setter, T_getter, void> : public adapts<T_setter>
{
  typedef void result_type;
  typedef typename adapts<T_setter>::adaptor_type adaptor_type;

  void
  operator()();

FOR(1,CALL_SIZE,[[COMPOSE1_OPERATOR(%1)]])

  compose1_functor() {}
  compose1_functor(const T_setter& _A_setter, const T_getter& _A_getter)
    : adapts<T_setter>(_A_setter), get_(_A_getter)
    {}
  ~compose1_functor() {}

//  protected: 
    T_getter get_; 
};

template <class T_setter, class T_getter>
void
compose1_functor<T_setter, T_getter, void>::operator()()
  { functor_(get_()); }


template <class T_setter, class T_getter1, class T_getter2, class T_return = typename adapts<T_setter>::result_type>
struct compose2_functor : public adapts<T_setter>
{
  typedef T_return result_type;
  typedef typename adapts<T_setter>::adaptor_type adaptor_type;

  result_type // TODO: conflicts with our previous explanation that result_type is the return type of the functor's operator() overload with no arguments!
  operator()();

FOR(1,CALL_SIZE,[[COMPOSE2_OPERATOR(%1)]])

  compose2_functor() {}
  compose2_functor(const T_setter& _A_setter,
                   const T_getter1& _A_getter1,
                   const T_getter2& _A_getter2)
    : adapts<T_setter>(_A_setter), get1_(_A_getter1), get2_(_A_getter2)
    {}
  ~compose2_functor() {}

//   protected: 
     T_getter1 get1_; 
     T_getter2 get2_; 
};

template <class T_setter, class T_getter1, class T_getter2, class T_return>
typename compose2_functor<T_setter, T_getter1, T_getter2, T_return>::result_type
compose2_functor<T_setter, T_getter1, T_getter2, T_return>::operator()()
  { return functor_(get1_(), get2_()); }

// void specialization
template <class T_setter, class T_getter1, class T_getter2>
struct compose2_functor<T_setter, T_getter1, T_getter2, void> : public adapts<T_setter>
{
  typedef void result_type;
  typedef typename adapts<T_setter>::adaptor_type adaptor_type;

  void
  operator()();

FOR(1,CALL_SIZE,[[COMPOSE2_OPERATOR(%1)]])

  compose2_functor() {}
  compose2_functor(const T_setter& _A_setter,
                   const T_getter1& _A_getter1,
                   const T_getter2& _A_getter2)
    : adapts<T_setter>(_A_setter), get1_(_A_getter1), get2_(_A_getter2)
    {}
  ~compose2_functor() {}

//   protected: 
     T_getter1 get1_; 
     T_getter2 get2_; 
};

template <class T_setter, class T_getter1, class T_getter2>
void
compose2_functor<T_setter, T_getter1, T_getter2, void>::operator()()
  { return functor_(get1_(), get2_()); }


// declare how to access targets
template <class T_action, class T_setter, class T_getter, class T_return>
void visit_each(const T_action& _A_action,
                const compose1_functor<T_setter, T_getter, T_return>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
  visit_each(_A_action, _A_target.get_);
}

template <class T_action, class T_setter, class T_getter1, class T_getter2, class T_return>
void visit_each(const T_action& _A_action,
                const compose2_functor<T_setter, T_getter1, T_getter2, T_return>& _A_target)
{
  visit_each(_A_action, _A_target.functor_);
  visit_each(_A_action, _A_target.get1_);
  visit_each(_A_action, _A_target.get2_);
}


template <class T_setter, class T_getter>
inline compose1_functor<T_setter, T_getter>
compose(const T_setter& _A_setter, const T_getter& _A_getter)
  { return compose1_functor<T_setter, T_getter>(_A_setter, _A_getter); }

template <class T_setter, class T_getter1, class T_getter2>
inline compose2_functor<T_setter, T_getter1, T_getter2>
compose(const T_setter& _A_setter, const T_getter1& _A_getter1, const T_getter2& _A_getter2)
  { return compose2_functor<T_setter, T_getter1, T_getter2>(_A_setter, _A_getter1, _A_getter2); }

} /* namespace functor */
} /* namespace sigc */
