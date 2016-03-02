/* Copyright (C) 2016 Murray Cumming
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/
 */

#ifndef SIGC_TUPLE_UTILS_TUPLE_CDR_H
#define SIGC_TUPLE_UTILS_TUPLE_CDR_H

#include <tuple>
#include <type_traits>
#include <utility>

namespace sigc {

/**
 * Get the type of a tuple without the first item.
 */
template <typename T>
struct tuple_type_cdr; // primary template is not defined

// Partial specialization for tuples of at least one element:
template <typename H, typename... T>
struct tuple_type_cdr<std::tuple<H, T...>>
{
  using type = std::tuple<T...>;
};

namespace detail {

template <typename T, std::size_t... I>
decltype(auto)
tuple_cdr_impl(T&& t, std::index_sequence<0, I...>)
{
  using cdr = typename tuple_type_cdr<std::decay_t<T>>::type;
  return cdr(std::get<I>(std::forward<T>(t))...);
}

} // detail namespace

/**
 * Get the a tuple without the first item.
 * This is analogous to std::tuple_cat().
 */
template <typename T>
decltype(auto)
tuple_cdr(T&& t) {
  //We use std::decay_t<> because tuple_size is not defined for references.
  constexpr auto size = std::tuple_size<std::decay_t<T>>::value;

  static_assert(size != 0, "tuple size must be non-zero");
  using seq = std::make_index_sequence<size>;
  return detail::tuple_cdr_impl(std::forward<T>(t), seq{});
}

} // namespace sigc

#endif //SIGC_TUPLE_UTILS_TUPLE_CDR_H
