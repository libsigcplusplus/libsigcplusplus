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

define([DEDUCE_RESULT_TYPE_ADAPTOR],[dnl
template <LIST(class T_functor, LOOP(class T_arg%1, $1))>
struct deduce_result_type<LIST(T_functor, LOOP(T_arg%1,$1), LOOP(void,eval($2-$1)), true)>
  { typedef typename T_functor::deduce_result_type<LOOP(T_arg%1,$1)>::type type; };

])
define([DEDUCE_RESULT_TYPE_TYPEOF],[dnl
template <LIST(class T_functor, LOOP(class T_arg%1, $1))>
struct deduce_result_type<LIST(T_functor, LOOP(T_arg%1,$1), LOOP(void,eval($2-$1)), false)>
{
  typedef typeof(type_trait<T_functor>::instance().
                   T_functor::operator()(LOOP([
                      type_trait<T_arg%1>::instance()], $1))) type;
};

])

divert(0)dnl
/*
*/
__FIREWALL__
#include <sigc++/functors/functor_trait.h>


namespace sigc {

/** A hint to the compiler.
 * All multi-type functors which define deduce_result_type<> should publically inherit from this hint.
 */
struct adaptor_base : public functor_base {};


/** Deduce the return type of a functor.
 * typename deduce_result_type<functor_type, [list of arg_types]>::type
 * can be used to infer a functor's return type at compile time if the
 * argument types are known.
 * If the compiler supports typeof() it is used to deduce the result type
 * the functor. Otherwise, typename functor_trait<functor_type>::result_type
 * is used. This gives the correct return type if functor_type inherits from
 * sigc::functor::functor_base and defines result_type or if functor_type
 * is actually a (member) function type. Mulit-type functors are only
 * supported when typeof() is available.
 * sigc++ adaptors define a class member deduce_result_type<> that is
 * used by the global deduce_result_type<> template to correctly deduce
 * the return types of the different template operator() overloads.
 *
 * Specifying wrong argument types or a wrong number of arguments leads
 * to compiler errors!
 *
 * sigc++ adaptors use
 * typename deduce_result_type<functor_type, [list of arg_types]>type
 * to determine the return time of their templated operator() overloads.
 */
template <class T_functor,
          LOOP(class T_arg%1=void, CALL_SIZE),
          bool I_derives_adaptor_base=is_base_and_derived<adaptor_base,T_functor>::value>
struct deduce_result_type
  { typedef typename functor_trait<T_functor>::result_type type; };

FOR(0,CALL_SIZE,[[DEDUCE_RESULT_TYPE_ADAPTOR(%1,CALL_SIZE)]])

#ifdef SIGC_CXX_TYPEOF
FOR(0,CALL_SIZE,[[DEDUCE_RESULT_TYPE_TYPEOF(%1,CALL_SIZE)]])
#endif

} /* namespace sigc */
