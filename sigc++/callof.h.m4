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

define([CALLOF],[dnl
ifelse($1,$2,[template <LIST(class T_functor,LOOP(class T_arg%1=nil,$1))>],
[template <LIST(class T_functor,LOOP(class T_arg%1,$1))>])
struct callof ifelse($1,$2,,[<LIST(T_functor,LOOP(T_arg%1,$1),LOOP(nil,eval($2-$1)))>])
{ 
   typedef typeof(type_trait<T_functor>::instance().
                    T_functor::operator()(LOOP([
                       type_trait<T_arg%1>::instance()],$1))) result_type;
};
])

dnl template <class T_functor>
dnl struct callof <T_functor,nil,nil,nil,nil,nil,nil,nil>
dnl {
dnl    struct test_ 
dnl      {
dnl        template <class T_none> static nil has_operator(T_none);
dnl        template <class T_return> static T_return has_operator(T_return (T_functor::*)());
dnl      };
dnl    typedef typeof(test_::has_operator(&T_functor::operator())) result_type;
dnl };

divert(0)dnl
__FIREWALL__
#include <sigc++/type_traits.h>

namespace sigc {

// nil struct type
struct nil;

// Actual callof macro
CALLOF(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[CALLOF(%1,CALL_SIZE)]])

dnl // special type to avoid problems with template instantiation.
dnl template <class T_functor>
dnl struct callof0_safe
dnl {
dnl   struct test_ 
dnl       {
dnl         static void has_operator(...);
dnl         template <class T_none> static void has_operator(T_none);
dnl         template <class T_return> static T_return has_operator(T_return (T_functor::*)());
dnl       };
dnl   typedef typeof(test_::has_operator(&T_functor::operator())) result_type;
dnl };
   
} /* namespace sigc */
