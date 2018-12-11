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
#include <sigc++/tuple-utils/tuple_cdr.h>
#include <functional>

void
test_tuple_type_cdr()
{
  using type_tuple_isd = std::tuple<int, short, double>;
  using type_tuple_sd = std::tuple<short, double>;
  using type_tuple_suffix = sigc::internal::tuple_type_cdr<type_tuple_isd>::type;

  static_assert(
    std::tuple_size<type_tuple_suffix>::value == 2, "unexpected tuple_cdr()ed tuple size.");
  static_assert(
    std::is_same<type_tuple_suffix, type_tuple_sd>::value, "unexpected tuple_cdr()ed tuple type");
}

void
test_tuple_cdr()
{
  auto t_larger = std::make_tuple(nullptr, std::string("hello"), std::string("world"));
  auto t_suffix = sigc::internal::tuple_cdr(t_larger);
  assert(std::get<0>(t_suffix) == "hello");
  assert(std::get<1>(t_suffix) == "world");

  using type_tuple_suffix = std::tuple<std::string, std::string>;

  static_assert(std::tuple_size<decltype(t_suffix)>::value == 2, "unexpected cdr()ed tuple size.");
  static_assert(
    std::is_same<decltype(t_suffix), type_tuple_suffix>::value, "unexpected cdr()ed tuple type");
}

void
test_tuple_cdr_stdref()
{
  std::string b = "yadda";
  std::string c = "yaddayadda";
  auto t_larger = std::make_tuple(1, std::ref(b), std::ref(c));

  // std::cout << "debug: " << type(std::get<1>(t_larger)) << std::endl;

  auto t_suffix = sigc::internal::tuple_cdr(t_larger);
  b = "hello";
  c = "world";
  // This works, but it's not what we are testing here:
  // assert(std::get<1>(t_larger) == "hello");

  assert(std::get<0>(t_suffix) == "hello");
  assert(std::get<1>(t_suffix) == "world");
}

constexpr void
test_tuple_cdr_constexpr()
{
  constexpr auto str_hello = "hello";
  constexpr auto str_world = "world";

  constexpr auto t_larger = std::make_tuple(nullptr, str_hello, str_world);
  constexpr auto t_suffix = sigc::internal::tuple_cdr(t_larger);
  assert(std::get<0>(t_suffix) == str_hello);
  assert(std::get<1>(t_suffix) == str_world);
}

int
main()
{
  test_tuple_type_cdr();
  test_tuple_cdr();
  test_tuple_cdr_stdref();

  test_tuple_cdr_constexpr();

  return EXIT_SUCCESS;
}
