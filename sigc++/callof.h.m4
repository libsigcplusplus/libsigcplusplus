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

//TODO: What's this? murrayc.
// I can explain what it's used for (see below),
// but I have no idea why it is implemented like this. Martin.

include(template.macros.m4)

define([CALLOF],[dnl
ifelse($1, $2,[template <LIST(class T_functor, LOOP(class T_arg%1 = nil,$1))>],
[template <LIST(class T_functor, LOOP(class T_arg%1, $1))>])
struct callof ifelse($1, $2,,[<LIST(T_functor, LOOP(T_arg%1,$1),LOOP(nil,eval($2-$1)))>])
{
  typedef typeof(type_trait<T_functor>::instance().
                   T_functor::operator()(LOOP([
                      type_trait<T_arg%1>::instance()], $1))) result_type;
};
])
define([HAS_OPERATOR],[dnl
        template <LIST(LOOP(class T_arg%1, $1), class T_return)> static T_return has_operator(T_return (T_functor::*)(LOOP(T_arg%1, $1)));
        template <LIST(LOOP(class T_arg%1, $1), class T_return)> static T_return has_operator(T_return (T_functor::*)(LOOP(T_arg%1, $1)) const);
])
define([CALLOF_SAFE],[dnl
template <class T_functor>
struct callof_safe$1
{
  struct test_
    {
//        static void has_operator(...); // doesn't work for overloaded operators!
        template <class T_none> static void has_operator(T_none); // doesn't work for overloaded operators, either!
HAS_OPERATOR($1)
    };
  typedef typeof(test_::has_operator(&T_functor::operator())) result_type;
};
])

divert(0)dnl
__FIREWALL__
#include <sigc++/type_traits.h>

namespace sigc {

/** nil struct type.
 * The nil struct type is used as default template argument in the
 * unnumbered signal<> and slot<> templates. Template specializations
 * for the last m of n template arguments being "nil" can use other,
 * numbered templates, like signal#<>, knowing that # = (n-m).
 */
struct nil;


/** Macro to infer the return type of a functor.
 * The callof<> template can be used to infer a functor's return type at
 * compile time if the argument types are known. callof<> also infers the
 * correct return type if T_functor's operator() is overloaded. However,
 * specifying wrong argument types or a wrong number of arguments leads
 * to compiler errors!
 *
 * sigc++ adaptors use
 * "typename callof<T_functor, [list of argument types]>::result_type"
 * to determine the return time of their templated operator() overloads,
 * like e.g. in:
 *
 *   template <class T_functor>
 *   struct adaptor_functor : public adaptor_base
 *   {
 *     ...
 *     template <class T_arg1>
 *     typename callof<T_functor, T_arg1>::result_type
 *     operator()(T_arg1 _A_arg1) const { return functor_(_A_arg1); }
 *     ...
 *   };
 *
 */
CALLOF(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[CALLOF(%1,CALL_SIZE)]])


/** Macro to infer the return type of a functor.
 * The callof_ignore_arg<> template can be used to infer the return type
 * of the functor's operator() with no arguments. It is useful to determine
 * the result type of template member functions that invoke the functor's
 * operator() with no arguments: as opposed to callof<> with zero arguments
 * it only get instantiated when the function itself is instatiated. Thus
 * it's safe to use when the existance of the functor's operator() overload
 * with no arguments is not known.
 *
 * sigc::functor::hide uses
 * "typename callof_ignore_arg<T_functor, T_arg1>::result_type"
 * to determine the return time of its templated operator() overload
 * that invokes the functor's operator() overload with no arguments,
 * like e.g. in:
 *
 *   template <class T_functor>
 *   struct hide_functor <1, T_functor> : public adapts<T_functor>
 *   {
 *     ...
 *     template <class T_arg1>
 *     typename callof_ignore_arg<T_functor, T_arg1>::result_type
 *     operator()(T_arg1 _A_arg1) const { return functor_(); }
 *     ...
 *   };
 *
 */
template <class T_functor, class T_arg1>
struct callof_ignore_arg
{
  typedef typeof(type_trait<T_functor>::instance().
                   T_functor::operator()()) result_type;
};


/** Macro to infer the return type of a functor.
 * The callof_safe<> template can be used to infer a functor's return
 * type at compile time. If T_functor's operator() is overloaded,
 * callof_safe<T_functor> leads to compile time errors! As opposed to
 * the callof<> template, neither the number of arguments, nor the
 * argument types of T_functor need to be known.
 *
 * sigc++ adaptors would use
 * "typename callof_safe<T_functor>::result_type" to determine the
 * return type of their operator() overloads that cannot be templated,
 * like e.g. in:
 *
 *   template <class T_functor>
 *   struct adaptor_functor : public adaptor_base
 *   {
 *     ...
 *     typename callof_safe<T_functor>::result_type
 *     operator()() const { return functor_(); }
 *     ...
 *   };
 *
 * However, if T_functor has an overloaded operator() this leads to
 * compiler errors. Therefore, we use functor_trait<> instead.
 */
template <class T_functor>
struct callof_safe
{
  struct test_
    {
//        static void has_operator(...); // doesn't work for overloaded operators!
        template <class T_none> static void has_operator(T_none); // doesn't work for overloaded operators, either!
FOR(0,CALL_SIZE,[[HAS_OPERATOR(%1)]])
    };
  typedef typeof(test_::has_operator(&T_functor::operator())) result_type;
};

// numbered callof_safe
FOR(0,eval(CALL_SIZE),[[CALLOF_SAFE(%1)]])

} /* namespace sigc */
