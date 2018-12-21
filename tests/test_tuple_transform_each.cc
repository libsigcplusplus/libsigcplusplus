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
#include <sigc++/tuple-utils/tuple_transform_each.h>
#include <utility>
#include <functional>
#include <string>

template<typename T_element_from>
class transform_to_string
{
public:
  static decltype(auto) transform(T_element_from& from) { return std::to_string(from); }
};

// In these tests, t_expected has elements all of the same type.
void
test_tuple_transform_each_same_types()
{
  {
    auto t_original = std::make_tuple(1, 2, 3);
    auto t_transformed = sigc::internal::tuple_transform_each<transform_to_string>(t_original);
    auto t_expected = std::make_tuple(std::string("1"), std::string("2"), std::string("3"));

    static_assert(std::tuple_size<decltype(t_transformed)>::value == 3,
      "unexpected tuple_transform_each()ed tuple size.");

    assert(std::get<0>(t_transformed) == "1");
    assert(std::get<1>(t_transformed) == "2");
    assert(std::get<2>(t_transformed) == "3");

    static_assert(std::is_same<decltype(t_transformed), decltype(t_expected)>::value,
      "unexpected transform_each()ed tuple type");
  }

  {
    auto t_original = std::make_tuple(1, static_cast<double>(2.1f), 3);
    auto t_transformed = sigc::internal::tuple_transform_each<transform_to_string>(t_original);
    auto t_expected = std::make_tuple(std::string("1"), std::string("2"), std::string("3"));

    static_assert(std::tuple_size<decltype(t_transformed)>::value == 3,
      "unexpected tuple_transform_each()ed tuple size.");

    assert(std::get<0>(t_transformed) == "1");
    assert(std::get<1>(t_transformed).substr(0, 3) == "2.1");
    assert(std::get<2>(t_transformed) == "3");

    static_assert(std::is_same<decltype(t_transformed), decltype(t_expected)>::value,
      "unexpected transform_each()ed tuple type");
  }
}

// The general template declaration.
// We then provide specializations for each type,
// so we can test having a different return value for each T_element_from type.
template<typename T_element_from>
class transform_to_something;

// An int will be converted to a std::string:
template<>
class transform_to_something<int>
{
public:
  static std::string transform(int& from) { return std::to_string(from); }
};

// A double will be converted to a char:
template<>
class transform_to_something<double>
{
public:
  static char transform(double& from) { return std::to_string(from)[0]; }
};

// A std::string will be converted to an int:
template<>
class transform_to_something<std::string>
{
public:
  static int transform(std::string& from) { return std::stoi(from); }
};

// In these tests, t_expected has elements of different types.
void
test_tuple_transform_each_multiple_types()
{
  auto t_original = std::make_tuple(1, static_cast<double>(2.1f), std::string("3"));
  auto t_transformed = sigc::internal::tuple_transform_each<transform_to_something>(t_original);
  auto t_expected = std::make_tuple(std::string("1"), '2', 3);

  static_assert(std::tuple_size<decltype(t_transformed)>::value == 3,
    "unexpected tuple_transform_each()ed tuple size.");

  assert(std::get<0>(t_transformed) == "1");
  assert(std::get<1>(t_transformed) == '2');
  assert(std::get<2>(t_transformed) == 3);

  static_assert(std::is_same<decltype(t_transformed), decltype(t_expected)>::value,
    "unexpected transform_each()ed tuple type");
}

template<typename T_element_from>
class transform_each_nonconst
{
public:
  static int transform(T_element_from& from)
  {
    from *= 2;
    // Or, for instance, call a non-const method on from.

    return from * 10;
  }
};

void
test_tuple_transform_each_nonconst()
{
  auto t = std::make_tuple(1, 2, 3);
  auto t_transformed = sigc::internal::tuple_transform_each<transform_each_nonconst>(t);

  // Check that t was changed (from * 2):
  assert(std::get<0>(t) == 2);
  assert(std::get<1>(t) == 4);
  assert(std::get<2>(t) == 6);

  // Check that t_transformed has the expected values ( from * 2 * 10):
  assert(std::get<0>(t_transformed) == 20);
  assert(std::get<1>(t_transformed) == 40);
  assert(std::get<2>(t_transformed) == 60);
}

void
test_tuple_transform_each_stdref()
{
  int a = 1;
  int b = 2;
  int c = 3;
  auto t_original = std::make_tuple(std::ref(a), std::ref(b), std::ref(c));
  auto t_transformed = sigc::internal::tuple_transform_each<transform_to_string>(t_original);
  auto t_expected = std::make_tuple(std::string("1"), std::string("2"), std::string("3"));

  static_assert(std::tuple_size<decltype(t_transformed)>::value == 3,
    "unexpected tuple_transform_each()ed tuple size.");

  assert(std::get<0>(t_transformed) == "1");
  assert(std::get<1>(t_transformed) == "2");
  assert(std::get<2>(t_transformed) == "3");

  static_assert(std::is_same<decltype(t_transformed), decltype(t_expected)>::value,
    "unexpected transform_each()ed tuple type");
}

// This can only be used via std::ref(), for instance.
// Any attempt to copy or move it, should cause a compiler error.
class NonCopyable
{
public:
  explicit NonCopyable(int val) : m_val(val) {}

  int get_val() const { return m_val; }

  NonCopyable(const NonCopyable& src) = delete;
  NonCopyable& operator=(const NonCopyable& src) = delete;

  NonCopyable(NonCopyable&& src) = delete;
  NonCopyable& operator=(NonCopyable&& src) = delete;

private:
  int m_val;
};

template<typename T_element_from>
class transform_noncopyable_to_string
{
public:
  static decltype(auto) transform(T_element_from&& from) { return std::to_string(from.get_val()); }
};

void
test_tuple_transform_each_stdref_non_copyable()
{
  NonCopyable a(1);
  NonCopyable b(2);
  NonCopyable c(3);
  auto t_original = std::make_tuple(std::ref(a), std::ref(b), std::ref(c));
  auto t_transformed =
    sigc::internal::tuple_transform_each<transform_noncopyable_to_string>(t_original);
  auto t_expected = std::make_tuple(std::string("1"), std::string("2"), std::string("3"));

  static_assert(std::tuple_size<decltype(t_transformed)>::value == 3,
    "unexpected tuple_transform_each()ed tuple size.");

  assert(std::get<0>(t_transformed) == "1");
  assert(std::get<1>(t_transformed) == "2");
  assert(std::get<2>(t_transformed) == "3");

  static_assert(std::is_same<decltype(t_transformed), decltype(t_expected)>::value,
    "unexpected transform_each()ed tuple type");
}

static std::string correct_sequence_output;

template<typename T_element_from>
class transform_each_correct_sequence
{
public:
  static decltype(auto) transform(int from)
  {
    correct_sequence_output += std::to_string(from);
    return std::to_string(from);
  }
};

void
test_tuple_transform_each_correct_sequence()
{
  correct_sequence_output.clear();
  auto t = std::make_tuple(1, 2, 3);
  sigc::internal::tuple_transform_each<transform_each_correct_sequence>(t);
  // std::cout << "correct_sequence_output: " << correct_sequence_output << std::endl;
  assert(correct_sequence_output == "123");
}

void
test_tuple_transform_each_empty_tuple()
{
  auto t = std::tuple<>();
  sigc::internal::tuple_transform_each<transform_to_string>(t);
}

// The general template declaration.
// We then provide specializations for each type,
// so we can test having a different return value for each T_element_from type.
template<typename T_element_from>
class transform_as_constexpr_to_something;

// An int will be converted to a char:
template<>
class transform_as_constexpr_to_something<int>
{
public:
  constexpr static char transform(int from) { return 'a' + static_cast<char>(from); }
};

// A double will be converted to an int:
template<>
class transform_as_constexpr_to_something<const double>
{
public:
  constexpr static int transform(double from) { return (int)from; }
};

/* TODO: See the comment in main().
constexpr
void
test_tuple_transform_each_constexpr() {
  constexpr auto t_original = std::make_tuple(1, static_cast<double>(2.1f));
  constexpr auto t_transformed =
    sigc::internal::tuple_transform_each<transform_as_constexpr_to_something>(t_original);
  constexpr auto t_expected = std::make_tuple('b', 2);

  static_assert(std::tuple_size<decltype(t_transformed)>::value == 2,
    "unexpected tuple_transform_each()ed tuple size.");

  assert(std::get<0>(t_transformed) == 'b');
  assert(std::get<1>(t_transformed) == 2);

  static_assert(
    std::is_same<decltype(t_transformed), decltype(t_expected)>::value,
    "unexpected transform_each()ed tuple type");
}
*/

int
main()
{
  test_tuple_transform_each_same_types();
  test_tuple_transform_each_multiple_types();

  test_tuple_transform_each_nonconst();

  test_tuple_transform_each_stdref();
  test_tuple_transform_each_stdref_non_copyable();

  test_tuple_transform_each_correct_sequence();

  test_tuple_transform_each_empty_tuple();

  // g++ 5.2.1 gives this error:
  //   error: accessing uninitialized member ‘std::tuple<char>::<anonymous>’
  // though it works with clang++.
  // TODO: Try it with a newer g++.
  // test_tuple_transform_each_constexpr();

  return EXIT_SUCCESS;
}
