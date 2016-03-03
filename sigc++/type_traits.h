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
#ifndef _SIGC_TYPE_TRAIT_H_
#define _SIGC_TYPE_TRAIT_H_

#include <sigc++config.h>


namespace sigc {

template <class T_type>
struct type_trait
{
  typedef T_type& pass;
  typedef const T_type& take;
};

template <class T_type, int N>
struct type_trait<T_type[N]>
{
  typedef T_type*& pass;
  typedef const T_type*& take;
};

template <class T_type>
struct type_trait<T_type&>
{
  typedef T_type& pass;
  typedef T_type& take;
};

template <class T_type>
struct type_trait<const T_type&>
{
  typedef const T_type& pass;
  typedef const T_type& take;
};

template<>
struct type_trait<void>
{
  typedef void  pass;
  typedef void  take;
};

template<typename T>
using type_trait_pass_t = typename type_trait<T>::pass;

template<typename T>
using type_trait_take_t = typename type_trait<T>::take;

} /* namespace sigc */

#endif /* _SIGC_TYPE_TRAIT_H_ */
