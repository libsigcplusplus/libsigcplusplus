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

#ifndef SIGC_TUPLE_UTILS_TUPLE_CAT_H
#define SIGC_TUPLE_UTILS_TUPLE_CAT_H

#include <tuple>
#include <type_traits>
#include <utility>

namespace sigc {

namespace internal {

namespace detail {

template <typename T1, typename T2, typename Seq1, typename Seq2>
struct tuple_type_cat_impl;

template <typename T1, typename T2, std::size_t... I1, std::size_t... I2>
struct tuple_type_cat_impl<T1, T2, std::index_sequence<I1...>,
  std::index_sequence<I2...>> {
  using type = std::tuple<typename std::tuple_element<I1, T1>::type...,
    typename std::tuple_element<I2, T2>::type...>;
};

} // detail namespace

/**
 * Get the type of a tuple without the first item.
 */
template <typename T1, typename T2>
struct tuple_type_cat
  : detail::tuple_type_cat_impl<T1, T2,
      std::make_index_sequence<std::tuple_size<T1>::value>,
      std::make_index_sequence<std::tuple_size<T2>::value>> {};

// There is no tuple_cat() here because std::tuple_cat() exists already in
// the C++ standard library.

} // namespace internal

} // namespace sigc

#endif //SIGC_TUPLE_UTILS_TUPLE_CAT_H
