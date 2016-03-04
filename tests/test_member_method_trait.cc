/* Copyright 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include <cstdlib>
#include <sigc++/member_method_trait.h>

namespace
{

class Something
{
public:
  void some_func(int a);
  void some_const_func(int a) const;
  void some_volatile_func(int a) volatile;
  void some_const_volatile_func(int a) const volatile;
};

} // end anonymous namespace

int main()
{
  static_assert(!sigc::member_method_is_const<decltype(&Something::some_func)>::value,
    "member_method_is_const failed to identify a non-const member method.");

  static_assert(!sigc::member_method_is_const<decltype(&Something::some_volatile_func)>::value,
    "member_method_is_const failed to identify a non-const member method.");

  static_assert(sigc::member_method_is_const<decltype(&Something::some_const_func)>::value,
    "member_method_is_const failed to identify a const member method.");

  static_assert(sigc::member_method_is_const<decltype(&Something::some_const_volatile_func)>::value,
    "member_method_is_const failed to identify a const member method.");


  static_assert(!sigc::member_method_is_volatile<decltype(&Something::some_func)>::value,
    "member_method_is_const failed to identify a non-volatile member method.");

  static_assert(sigc::member_method_is_volatile<decltype(&Something::some_volatile_func)>::value,
    "member_method_is_const failed to identify a volatile member method.");

  static_assert(sigc::member_method_is_volatile<decltype(&Something::some_const_volatile_func)>::value,
    "member_method_is_const failed to identify a volatile member method.");



  return EXIT_SUCCESS;
}
