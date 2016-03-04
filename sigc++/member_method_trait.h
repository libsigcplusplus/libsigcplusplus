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
#ifndef _SIGC_MEMBER_METHOD_TRAITS_H_
#define _SIGC_MEMBER_METHOD_TRAITS_H_

#include <sigc++config.h>


namespace sigc {

template <class>
struct member_method_is_const;

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_const<T_result (T_obj::*)(T_arg...)>
{
  constexpr static bool value = false;
};

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_const<T_result (T_obj::*)(T_arg...) volatile>
{
  constexpr static bool value = false;
};

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_const<T_result (T_obj::*)(T_arg...) const>
{
  constexpr static bool value = true;
};

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_const<T_result (T_obj::*)(T_arg...) const volatile>
{
  constexpr static bool value = true;
};


template <class>
struct member_method_is_volatile;

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_volatile<T_result (T_obj::*)(T_arg...)>
{
  constexpr static bool value = false;
};

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_volatile<T_result (T_obj::*)(T_arg...) const>
{
  constexpr static bool value = false;
};

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_volatile<T_result (T_obj::*)(T_arg...) volatile>
{
  constexpr static bool value = true;
};

template <class T_obj, class T_result, class... T_arg>
struct member_method_is_volatile<T_result (T_obj::*)(T_arg...) const volatile>
{
  constexpr static bool value = true;
};




} /* namespace sigc */

#endif /* _SIGC_MEMBER_METHOD_TRAITS_H_ */
