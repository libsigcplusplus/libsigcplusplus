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
dnl Macros to make select arguments
define([LAMBDA_SELECT_DO],[dnl
  template <LOOP(class T_arg%1,$2)>
  T_arg$1 operator ()(LOOP(T_arg%1 _A_%1,$2)) const { return _A_$1; }
])
define([LAMBDA_SELECT],[dnl
struct lambda_select$1 : public lambda_base
{
FOR($1,$2,[[LAMBDA_SELECT_DO($1,%1)]])
};
])

divert(0)dnl
#ifndef _SIGC_LAMBDA_SELECT_HPP_
#define _SIGC_LAMBDA_SELECT_HPP_
#include <sigc++/adaptors/lambda/base.h>

namespace sigc {

namespace internal {
FOR(1,CALL_SIZE,[[LAMBDA_SELECT(%1,CALL_SIZE)]])
} /* namespace internal */

FOR(1,CALL_SIZE,[[extern lambda<internal::lambda_select%1> _%1;
]])

} /* namespace sigc */

#endif /* _SIGC_LAMBDA_SELECT_HPP_ */
