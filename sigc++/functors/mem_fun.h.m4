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

define([MEMBER_FUNCTOR],[dnl
template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
class mem_functor$1 /*: public functor_base*/
{
  public:
    typedef T_return (T_obj::*function_type)(LOOP(T_arg%1,$1));
    typedef T_return result_type;

    mem_functor$1() {}
    explicit mem_functor$1(function_type _A_func): func_ptr_(_A_func) {}
    T_return operator()(LIST(T_obj* _A_obj,LOOP(typename type_trait<T_arg%1>::take _A_a%1,$1))) const 
      { return (_A_obj->*func_ptr_)(LOOP(_A_a%1,$1)); }
    T_return operator()(LIST(T_obj& _A_obj,LOOP(typename type_trait<T_arg%1>::take _A_a%1,$1))) const 
      { return (_A_obj.*func_ptr_)(LOOP(_A_a%1,$1)); }
  protected: 
    function_type func_ptr_;
};

template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
class const_mem_functor$1 /*: public functor_base*/
{
  public:
    typedef T_return (T_obj::*function_type)(LOOP(T_arg%1,$1)) const;
    typedef T_return result_type;

    const_mem_functor$1() {}
    explicit const_mem_functor$1(function_type _A_func): func_ptr_(_A_func) {}
    T_return operator()(LIST(const T_obj* _A_obj,LOOP(typename type_trait<T_arg%1>::take _A_a%1,$1))) const 
      { return (_A_obj->*func_ptr_)(LOOP(_A_a%1,$1)); }
    T_return operator()(LIST(const T_obj& _A_obj,LOOP(typename type_trait<T_arg%1>::take _A_a%1,$1))) const 
      { return (_A_obj.*func_ptr_)(LOOP(_A_a%1,$1)); }

  protected: 
    function_type func_ptr_;
};

template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
class bound_mem_functor$1 
  : public mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>
{
  typedef mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)> base_type_;
  public:
    typedef typename base_type_::function_type function_type;

    explicit bound_mem_functor$1(T_obj* _A_obj,function_type _A_func)
      : base_type_(_A_func), obj_ptr_(_A_obj) {}
    T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1,$1)) const 
      { return (obj_ptr_->*func_ptr_)(LOOP(_A_a%1,$1)); }
//  protected: 
    T_obj *obj_ptr_;
};

template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
class bound_const_mem_functor$1 
  : public const_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>
{
  typedef const_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)> base_type_;
  public:
    typedef typename base_type_::function_type function_type;

    explicit bound_const_mem_functor$1(const T_obj* _A_obj,function_type _A_func)
      : base_type_(_A_func), obj_ptr_(_A_obj) {}
    T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1,$1)) const 
      { return (obj_ptr_->*func_ptr_)(LOOP(_A_a%1,$1)); }
//  protected: 
    const T_obj *obj_ptr_;
};

template <class T_action, LIST(LOOP(class T_arg%1,$1), class T_return, class T_obj)>
void visit_each(const T_action& _A_action,
                const bound_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>& _A_target)
{
  visit_each(_A_action,_A_target.obj_ptr_);
}

template <class T_action, LIST(LOOP(class T_arg%1,$1), class T_return, class T_obj)>
void visit_each(const T_action& _A_action,
                const bound_const_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>& _A_target)
{
  visit_each(_A_action,_A_target.obj_ptr_);
}

])

define([MEM_FUN],[dnl
template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
inline mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)> 
mem_fun[]ifelse($2,,$1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>(_A_func); }
template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
inline const_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)> 
mem_fun[]ifelse($2,,$1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return const_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>(_A_func); }
template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
inline bound_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)> 
mem_fun[]ifelse($2,,$1)(T_obj* _A_obj,T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return bound_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>(_A_obj,_A_func); }
template <LIST(LOOP(class T_arg%1,$1),class T_return,class T_obj)>
inline bound_const_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)> 
mem_fun[]ifelse($2,,$1)(const T_obj* _A_obj,T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return bound_const_mem_functor$1<LIST(LOOP(T_arg%1,$1),T_return,T_obj)>(_A_obj,_A_func); }
])

divert(0)

// implementation notes:  
//  - we do not use bind here, because it would introduce
//    an extra copy and complicate the header include order if bind is
//    to have automatic conversion for member pointers.
__FIREWALL__
#include <sigc++/type_traits.h>
dnl #include <sigc++/functor/functor_trait.h>

namespace sigc {
namespace functor {
FOR(0,CALL_SIZE,[[MEMBER_FUNCTOR(%1)]])

// numbered
FOR(0,CALL_SIZE,[[MEM_FUN(%1)]])

// unnumbered
FOR(0,CALL_SIZE,[[MEM_FUN(%1,1)]])

} /* namespace functor */
} /* namespace sigc */
