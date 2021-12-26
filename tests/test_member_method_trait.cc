/* Copyright 2016 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <cstdlib>
#include <sigc++/member_method_trait.h>
#include <type_traits>

namespace
{

class Something
{
public:
  void some_func(int) {}

  void some_const_func(int) const {}

  void some_volatile_func(int) volatile {}

  void some_const_volatile_func(int) const volatile {}

  int some_int_func() { return 1; }

  bool some_bool_func() { return true; }
};

} // end anonymous namespace

void
test_member_method_is_const()
{
  static_assert(!sigc::internal::member_method_is_const<decltype(&Something::some_func)>::value,
    "member_method_is_const failed to identify a non-const member method.");

  static_assert(
    !sigc::internal::member_method_is_const<decltype(&Something::some_volatile_func)>::value,
    "member_method_is_const failed to identify a non-const member method.");

  static_assert(
    sigc::internal::member_method_is_const<decltype(&Something::some_const_func)>::value,
    "member_method_is_const failed to identify a const member method.");

  static_assert(
    sigc::internal::member_method_is_const<decltype(&Something::some_const_volatile_func)>::value,
    "member_method_is_const failed to identify a const member method.");
}

void
test_member_method_is_volatile()
{
  static_assert(!sigc::internal::member_method_is_volatile<decltype(&Something::some_func)>::value,
    "member_method_is_const failed to identify a non-volatile member method.");

  static_assert(
    !sigc::internal::member_method_is_volatile<decltype(&Something::some_const_func)>::value,
    "member_method_is_const failed to identify a non-volatile member method.");

  static_assert(
    sigc::internal::member_method_is_volatile<decltype(&Something::some_volatile_func)>::value,
    "member_method_is_const failed to identify a volatile member method.");

  static_assert(sigc::internal::member_method_is_volatile<
                  decltype(&Something::some_const_volatile_func)>::value,
    "member_method_is_const failed to identify a volatile member method.");
}

void
test_member_method_class_type()
{
  static_assert(
    std::is_same<sigc::internal::member_method_class<decltype(&Something::some_func)>::type,
      Something>::value,
    "member_method_class_type failed to identify the class type.");
}

void
test_member_method_result_type()
{
  static_assert(
    std::is_same<sigc::internal::member_method_result<decltype(&Something::some_int_func)>::type,
      int>::value,
    "member_method_result_type failed to identify the result type.");

  static_assert(
    std::is_same<sigc::internal::member_method_result<decltype(&Something::some_bool_func)>::type,
      bool>::value,
    "member_method_result_type failed to identify the result type.");
}

int
main()
{
  test_member_method_is_const();
  test_member_method_is_volatile();

  test_member_method_class_type();
  test_member_method_result_type();

  return EXIT_SUCCESS;
}
