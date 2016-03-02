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
define(__t_div__,divnum)divert(-1)
dnl
dnl  M4 macros for building large files quickly
dnl
divert(0)// -*- c++ -*-
/* Do not edit! -- generated file */
divert(-1)
changequote([, ])
changecom()

dnl
dnl Macros for sigc specifically.
dnl

define([CALL_SIZE],7)

#Generate header guards:
define([_FIREWALL],[dnl
#ifndef _SIGC_$1_H_
#define _SIGC_$1_H_[]dnl
divert(1)dnl
#endif /* _SIGC_$1_H_ */
divert(0)dnl
])

dnl
dnl General macros
dnl

define([LIST],[ifelse($#,0,, $#,1,[$1],[$1],,[LIST(shift($@))],[__LIST($@)])])
define([__LIST],[ifelse($#,0,, $#,1,[$1],[$1[]ifelse([$2],,,[[, ]])__LIST(shift($@))])])

divert(__t_div__)dnl
