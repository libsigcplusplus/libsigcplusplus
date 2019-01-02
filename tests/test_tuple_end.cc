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

#include <cassert>
#include <cstdlib>
#include <string>
#include <sigc++/tuple-utils/tuple_end.h>
#include <functional>

void
test_tuple_end()
{
  {
    auto t_original = std::make_tuple(nullptr, std::string("hello"), std::string("world"));
    auto t_suffix = sigc::internal::tuple_end<3>(t_original);

    static_assert(
      std::tuple_size<decltype(t_suffix)>::value == 3, "unexpected tuple_end()ed tuple size.");

    assert(std::get<0>(t_suffix) == nullptr);
    assert(std::get<1>(t_suffix) == "hello");
    assert(std::get<2>(t_suffix) == "world");

    static_assert(std::is_same<decltype(t_suffix), decltype(t_original)>::value,
      "unexpected end()ed tuple type");
  }

  {
    auto t_original = std::make_tuple(nullptr, std::string("hello"), std::string("world"));
    auto t_suffix = sigc::internal::tuple_end<2>(t_original);

    static_assert(
      std::tuple_size<decltype(t_suffix)>::value == 2, "unexpected tuple_end()ed tuple size.");

    assert(std::get<0>(t_suffix) == "hello");
    assert(std::get<1>(t_suffix) == "world");

    using type_tuple_suffix = std::tuple<std::string, std::string>;
    static_assert(
      std::is_same<decltype(t_suffix), type_tuple_suffix>::value, "unexpected end()ed tuple type");
  }

  {
    auto t_original = std::make_tuple(nullptr, std::string("hello"), std::string("world"));
    auto t_suffix = sigc::internal::tuple_end<1>(t_original);

    static_assert(
      std::tuple_size<decltype(t_suffix)>::value == 1, "unexpected tuple_end()ed tuple size.");

    assert(std::get<0>(t_suffix) == "world");

    using type_tuple_suffix = std::tuple<std::string>;
    static_assert(
      std::is_same<decltype(t_suffix), type_tuple_suffix>::value, "unexpected end()ed tuple type");
  }
}

void
test_tuple_end_stdref()
{
  std::string c = "yadda";
  std::string d = "yaddayadda";
  auto t_larger = std::make_tuple(1, 2, std::ref(c), std::ref(d));

  auto t_suffix = sigc::internal::tuple_end<2>(t_larger);
  c = "hello";
  d = "world";
  // This works, but it's not what we are testing here:
  // assert(std::get<0>(t_larger) == "hello");

  assert(std::get<0>(t_suffix) == "hello");
  assert(std::get<1>(t_suffix) == "world");
}

constexpr void
test_tuple_end_constexpr()
{
  constexpr auto str_hello = "hello";
  constexpr auto str_world = "world";

  constexpr auto t_original = std::make_tuple(nullptr, str_hello, str_world);
  constexpr auto t_suffix = sigc::internal::tuple_end<2>(t_original);

  static_assert(
    std::tuple_size<decltype(t_suffix)>::value == 2, "unexpected tuple_end()ed tuple size.");

  assert(std::get<0>(t_suffix) == str_hello);
  assert(std::get<1>(t_suffix) == str_world);
}

int
main()
{
  test_tuple_end();
  test_tuple_end_stdref();

  test_tuple_end_constexpr();

  return EXIT_SUCCESS;
}
