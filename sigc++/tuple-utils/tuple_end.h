/* Copyright (C) 2016 Murray Cumming
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#ifndef SIGC_TUPLE_UTILS_TUPLE_END_H
#define SIGC_TUPLE_UTILS_TUPLE_END_H

#include <sigc++/tuple-utils/tuple_cdr.h>

namespace sigc::internal
{

namespace detail
{

template<typename T, std::size_t remove_from_start>
struct tuple_type_end_impl
{
  using type = typename tuple_type_end_impl<typename tuple_type_cdr<std::decay_t<T>>::type,
    remove_from_start - 1>::type;
};

template<typename T>
struct tuple_type_end_impl<T, 0>
{
  using type = T;
};

} // detail namespace

/**
 * Get the type of a tuple with the last @a len types of the original.
 */
template<typename T, std::size_t len>
struct tuple_type_end : detail::tuple_type_end_impl<T, std::tuple_size<T>::value - len>
{
};

/**
 * Get the tuple with the last @a len items of the original.
 */
template<std::size_t len, typename T>
constexpr decltype(auto) // typename tuple_type_end<T, len>::type
tuple_end(T&& t)
{
  // We use std::decay_t<> because tuple_size is not defined for references.
  constexpr auto size = std::tuple_size<std::decay_t<T>>::value;
  static_assert(len <= size, "The tuple size must be greater than or equal to the length.");

  if constexpr (len == 0)
  {
    // Prevent 'unreferenced formal parameter' warning from MSVC by 'using' t
    static_cast<void>(t);
    // Recursive calls to tuple_cdr() would result in this eventually,
    // but this avoids the extra work:
    return std::tuple<>();
  }
  else if constexpr (size - len == 0)
  {
    return std::forward<T>(t);
  }
  else if constexpr (size - len == 1)
  {
    return tuple_cdr(std::forward<T>(t));
  }
  else
  {
    return tuple_end<len>(tuple_cdr(std::forward<T>(t)));
  }
}

} // namespace sigc::internal;

#endif // SIGC_TUPLE_UTILS_TUPLE_END_H
