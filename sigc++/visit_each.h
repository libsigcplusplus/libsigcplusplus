// -*- c++ -*- 
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
 *
 */
#ifndef _SIGC_VISIT_EACH_HPP_
#define _SIGC_VISIT_EACH_HPP_

#include <sigc++/type_traits.h>

namespace sigc {
namespace functor {

namespace internal {

template <class T_target, class T_action>
struct limit_derived_target
{
  typedef limit_derived_target<T_target, T_action> T_self;

  template <bool I_derived, class T_type> struct with_type;
  template <class T_type> struct with_type<false,T_type>
  { static void execute_(const T_type&,const T_self&) {} };
  template <class T_type> struct with_type<true,T_type>
  { static void execute_(T_type& _A_type,const T_self& _A_action) 
     { _A_action.action_(_A_type); } 
    static void execute_(const T_type& _A_type,const T_self& _A_action) 
     { _A_action.action_(_A_type); } 
  };

  template <class T_type>
  void operator()(const T_type& _A_type) const
  { with_type<is_base_and_derived<T_target,T_type>::value,T_type>::execute_(_A_type,*this); }
  template <class T_type>
  void operator()(T_type& _A_type) const
  { with_type<is_base_and_derived<T_target,T_type>::value,T_type>::execute_(_A_type,*this); }

  limit_derived_target(const T_action& _A_action): action_(_A_action) {}

  T_action action_;
};

template <class T_target, class T_action>
struct limit_derived_target<T_target*, T_action>
{
  typedef limit_derived_target<T_target*, T_action> T_self;

  template <bool I_derived, class T_type> struct with_type;
  template <class T_type> struct with_type<false,T_type>
  { static void execute_(const T_type&, const T_self&) {} 
    static void execute_(const T_type*&, const T_self&) {} };

  template <class T_type> struct with_type<true,T_type>
  { 
    static void execute_(T_type*& _A_type, const T_self& _A_action) 
     { _A_action.action_(_A_type); } 
    static void execute_(const T_type*& _A_type, const T_self& _A_action) 
     { _A_action.action_(_A_type); } 
    static void execute_(T_type& _A_type, const T_self& _A_action) 
     { _A_action.action_(&_A_type); } 
    static void execute_(const T_type& _A_type, const T_self& _A_action) 
     { _A_action.action_(&_A_type); } 
  };

  template <class T_type>
  void operator()(const T_type& _A_type) const
  { with_type<is_base_and_derived<T_target,T_type>::value,T_type>::execute_(_A_type,*this); }
  template <class T_type>
  void operator()(T_type& _A_type) const
  { with_type<is_base_and_derived<T_target,T_type>::value,T_type>::execute_(_A_type,*this); }
  template <class T_type>
  void operator()(const T_type* _A_type) const
  { with_type<is_base_and_derived<T_target,T_type>::value,T_type>::execute_(_A_type,*this); }
  template <class T_type>
  void operator()(T_type* _A_type) const
  { with_type<is_base_and_derived<T_target,T_type>::value,T_type>::execute_(_A_type,*this); }

  limit_derived_target(const T_action& _A_action): action_(_A_action) {}

  T_action action_;
};

} /* namespace internal */


// This function allows you to perform a functor on each of the targets
// of a functor.
// All unknown types just call action on them.
// Add overloads that specialize the T_functor argument for known types,
// so that subobjects can be visited.
template <class T_action, class T_functor>
void visit_each(const T_action& _A_action, const T_functor& _A_functor)
{ _A_action(_A_functor); }

// This function allows you to perform a functor on each of the targets
// of a functor limited to a restricted type.
template <class T_type, class T_action, class T_functor>
void visit_each_type(const T_action& _A_action, const T_functor& _A_functor)
{ 
  internal::limit_derived_target<T_type,T_action> limited_action(_A_action);
  visit_each(limited_action,_A_functor);
}

} /* namespace functor */
} /* namespace sigc */
#endif
