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

define([HIDE_N],[dnl
template <LIST(LOOP(class T_hidden%1, $2), class T_return, LOOP(class T_arg%1, $1))>
inline SigC::Slot[]eval($1+$2)<LIST(T_return, LOOP(T_arg%1, $1), LOOP(T_hidden%1, $2))>
hide(const SigC::Slot$1<LIST(T_return, LOOP(T_arg%1, $1))>& _A_slot)
{ return FOR(0,eval($2-2),[[::sigc::hide<0>(
    ]])dnl
::sigc::hide_functor<0, SigC::Slot$1<LIST(T_return, LOOP(T_arg%1, $1))> >
      (_A_slot)FOR(0,eval($2-2),[[)]]); }

])


divert(0)dnl

__FIREWALL__

#include <sigc++/slot.h>
#include <sigc++/adaptors/hide.h>


#ifndef LIBSIGC_DISABLE_DEPRECATED

namespace SigC {

FOR(0,eval(CALL_SIZE-1),[[HIDE_N(%1,1)]])
FOR(0,eval(CALL_SIZE-2),[[HIDE_N(%1,2)]])

} /* namespace SigC */

#endif /* LIBSIGC_DISABLE_DEPRECATED */
