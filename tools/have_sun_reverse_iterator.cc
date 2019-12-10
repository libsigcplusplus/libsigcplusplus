// Configuration-time test program, used in Meson build.
// Corresponds to the M4 macro SIGC_CXX_HAS_SUN_REVERSE_ITERATOR.

#include <iterator>

int main()
{
  typedef std::reverse_iterator<char*, std::random_access_iterator_tag, char, char&, char*, int> ReverseIter;
  return 0;
}
