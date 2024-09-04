/*
 * Copyright 2024, The libsigc++ Development Team
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

#ifndef SIGC_SIGNAL_CONNECT_H
#define SIGC_SIGNAL_CONNECT_H

#include <sigc++/signal.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>

namespace sigc
{

/** Connect a function to a signal
 * @param signal The signal to connect to.
 * @param fun The function that should be wrapped.
 * @return A connection.
 *
 * @newin{3,8}
 * @ingroup signal
 */
template<typename T_return, typename... T_arg>
inline connection
signal_connect(signal<T_return(T_arg...)>& signal, T_return (*fun)(T_arg...))
{
  return signal.connect(ptr_fun<T_return, T_arg...>(fun));
}

/** Connect a non-const method to a signal
 * @param signal The signal to connect to.
 * @param obj Reference to object instance the functor should operate on.
 * @param fun Pointer to method that should be wrapped.
 * @return A connection.
 *
 * @newin{3,8}
 * @ingroup signal
 */
template<typename T_return, typename T_obj, typename... T_arg>
inline connection
signal_connect(signal<T_return(T_arg...)>& signal, T_obj& obj, T_return (T_obj::*fun)(T_arg...))
{
  return signal.connect(mem_fun<T_return, T_obj, T_obj, T_arg...>(obj, fun));
}

/** Connect a const method to a signal
 * @param signal The signal to connect to.
 * @param obj Reference to object instance the functor should operate on.
 * @param fun Pointer to method that should be wrapped.
 * @return A connection.
 *
 * @newin{3,8}
 * @ingroup signal
 */
template<typename T_return, typename T_obj, typename... T_arg>
inline connection
signal_connect(signal<T_return(T_arg...)>& signal, const T_obj& obj, T_return (T_obj::*fun)(T_arg...) const)
{
  return signal.connect(mem_fun<T_return, const T_obj, const T_obj, T_arg...>(obj, fun));
}

} /* namespace sigc */

#endif /* SIGC_SIGNAL_CONNECT_H */
