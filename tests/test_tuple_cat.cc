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
#include <sigc++/tuple-utils/tuple_cat.h>
#include <utility>
//#include <functional>

void
test_tuple_type_cat() {
  using type_tuple_is = std::tuple<int, short>;
  using type_tuple_dc = std::tuple<double, char>;
  using type_tuple_cat =
    sigc::tuple_type_cat<type_tuple_is, type_tuple_dc>::type;
  using type_tuple_expected = std::tuple<int, short, double, char>;

  static_assert(std::tuple_size<type_tuple_cat>::value == 4,
    "unexpected tuple_cat()ed tuple size.");
  static_assert(std::is_same<type_tuple_cat, type_tuple_expected>::value,
    "unexpected tuple_cat()ed tuple type");
}

/** We don't want to test std::tuple_cat() here,
 * but this a demonstration that std::ref() works with std::tuple_cat().
void
test_tuple_cat_stdref() {
  std::string a = "yadda1";
  std::string b = "yaddayadda1";
  auto t_one =
    std::make_tuple(std::ref(a), std::ref(b));
  int c = 2;
  char d = 'a';
  auto t_two =
    std::make_tuple(std::ref(c), std::ref(d));
  auto t_both = std::tuple_cat(t_one, t_two);
  a = "hello";
  b = "world";
  c = 3;
  d = 'b';

  assert(std::get<0>(t_both) == "hello");
  assert(std::get<1>(t_both) == "world");
  assert(std::get<2>(t_both) == 3);
  assert(std::get<3>(t_both) == 'b');
}
*/

int
main() {
  test_tuple_type_cat();
  // There is no typeutils::tuple_cat() because std::tuple_cat() exists:
  // test_tuple_cat();

  //test_tuple_cat_stdref();

  return EXIT_SUCCESS;
}
