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

define([FUNCTOR_PTR_FUN],[dnl
template <LIST(LOOP(class T_arg%1, $1), class T_return)> class pointer_functor$1;
template <LIST(LOOP(class T_arg%1, $1), class T_return)>
struct functor_trait<T_return (*)(LOOP(T_arg%1, $1)), false>
{
  typedef T_return result_type;
  typedef pointer_functor$1<LIST(LOOP(T_arg%1, $1), T_return)> functor_type;
};

])
define([FUNCTOR_MEM_FUN],[dnl
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)> class mem_functor$1;
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)> class const_mem_functor$1;
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
struct functor_trait<T_return (T_obj::*)(LOOP(T_arg%1, $1)), false>
{
  typedef T_return result_type;
  typedef mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> functor_type;
};
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
struct functor_trait<T_return (T_obj::*)(LOOP(T_arg%1, $1)) const, false>
{
  typedef T_return result_type;
  typedef const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> functor_type;
};

])

divert(0)dnl
/*
  Trait functor_trait<functor, bool>:
    This trait allows the user to specific what is the return type
  of any type. It has been overloaded to detect the return type and
  the functor version of function pointers and class methods as well.

  To populate the return type of user defined and third party functors
  use the macro SIGC_FUNCTOR_TRAIT(T_functor,T_return) in
  namespace sigc::functor. Multi-type functors are only partly supported.
  Try specifying the return type of the functor's operator ()() overload.

  Alternatively, you can derive your functors from functor_base and
  place "typedef T_return result_type;" in the class definition.

  If you place a "#define SIGC_FUNCTORS_HAVE_RESULT_TYPE" in your
  source file before including some sigc++ header, sigc++ will assume
  that result_type is defined in user defined or third party functors,
  unless you specify a return type explicitly with SIGC_FUNCTOR_TRAIT().

  You might get away without these conventions if your compiler supports
  typeof() and if you don't happen to use the operator ()() overload of
  sigc++'s adaptors in your program.

*/
__FIREWALL__
#include <sigc++/type_traits.h>

namespace sigc {
namespace functor {

// functor_base is a hint to the compiler.
// all functors which define "result_type" should publically inherite from
// this hint.
struct functor_base {};

template <class T_functor,bool I_derives=is_base_and_derived<functor_base,T_functor>::value>
struct functor_trait;

template <class T_functor>
struct functor_trait<T_functor,true>
{
  typedef typename T_functor::result_type result_type;
  typedef T_functor functor_type;
};

template <class T_functor>
struct functor_trait<T_functor,false>
{
  // Use callof_safe<> to guess the return type.
  // This leads to compiler errors if T_functor::operator() is overloaded!
//  typedef typename callof_safe<T_functor>::result_type result_type;
#ifndef SIGC_FUNCTORS_HAVE_RESULT_TYPE
  typedef void result_type;
#else
  typedef typename T_functor::result_type result_type;
#endif
  typedef T_functor functor_type;
};

#define SIGC_FUNCTOR_TRAIT(T_functor,T_return) \
template <>                                    \
struct functor_trait<T_functor,false>          \
{                                              \
  typedef T_return result_type;                \
  typedef T_functor functor_type;              \
};

// detect the return type and the functor version of non-functor types.
FOR(0,CALL_SIZE,[[FUNCTOR_PTR_FUN(%1)]])
FOR(0,CALL_SIZE,[[FUNCTOR_MEM_FUN(%1)]])

} /* namespace functor */
} /* namespace sigc */
