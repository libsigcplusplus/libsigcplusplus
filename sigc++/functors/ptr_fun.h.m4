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

define([POINTER_FUNCTOR],[dnl
template <LIST(LOOP(class T_arg%1, $1), class T_return)>
class pointer_functor$1 : public functor_base
{
  typedef T_return (*function_type)(LOOP(T_arg%1, $1));
  protected: 
    function_type func_ptr_;
  public:
    typedef T_return result_type;
    pointer_functor$1() {}
    explicit pointer_functor$1(function_type _A_func): func_ptr_(_A_func) {}
    T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const 
      { return func_ptr_(LOOP(_A_a%1, $1)); }
};])

define([PTR_FUN],[dnl
template <LIST(LOOP(class T_arg%1, $1), class T_return)>
inline pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)> 
ptr_fun[]ifelse($2,, $1)(T_return (*_A_func)(LOOP(T_arg%1,$1)))
{ return pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)>(_A_func); }])

divert(0)
/*
  ptr_fun(R (*)(A1...An))
  ptr_fun#(R (*)(A1...An))
  usage:
    Converts a pointer to a function to a functor.  
  If the function pointer is to an overloaded type, you must
  specify the types using template arguments starting with the
  first argument.  It is not necessary to supply the return type.

  Ie.
    void foo(int) {}
    slot<void, long> cl = ptr_fun(&foo);

  Note: # is required if there is an abiguity as to the number of 
  arguments.

  Ie.
    void foo(int) {}  // chose this one
    void foo(float) {}
    void foo(int, int) {}

    slot<void, long> cl = ptr_fun1<int>(&foo);
   
*/
__FIREWALL__
#include <sigc++/type_traits.h>
#include <sigc++/functors/functor_trait.h>

namespace sigc {
namespace functor {

FOR(0,CALL_SIZE,[[POINTER_FUNCTOR(%1)]])

// numbered ptr_fun
FOR(0,CALL_SIZE,[[PTR_FUN(%1)]])

// unnumbered ptr_fun
FOR(0,CALL_SIZE,[[PTR_FUN(%1,1)]])

} /* namespace functor */
} /* namespace sigc */
