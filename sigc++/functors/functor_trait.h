// -*- c++ -*- 
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
#ifndef _SIGC_FUNCTOR_TRAIT_HPP_
#define _SIGC_FUNCTOR_TRAIT_HPP_

#include <sigc++/type_traits.h>
#include <sigc++/callof.h>

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
};

template <class T_functor>
struct functor_trait<T_functor,false>
{
  // Use callof_safe<> to guess the return type.
  // This leads to compiler errors if T_functor::operator() is overloaded!
//  typedef typename callof_safe<T_functor>::result_type result_type;
  typedef void result_type;
};

} /* namespace functor */
} /* namespace sigc */
#endif
