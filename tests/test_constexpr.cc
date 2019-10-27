/* Copyright 2002 - 2016, The libsigc++ Development Team
 *  Assigned to public domain.  Use as you wish without restriction.
 */

#include "testutilities.h"
#include <sigc++/sigc++.h>

namespace {

constexpr
int foo(int a, int b) {
    return a + b;
}

} // end anonymous namespace

int
main()
{
  constexpr auto slot = sigc::ptr_fun(&foo);
  constexpr auto result = slot(1, 2);
  if (result != 3) {
      return EXIT_FAILURE;
  }

  EXIT_SUCCESS;
}
