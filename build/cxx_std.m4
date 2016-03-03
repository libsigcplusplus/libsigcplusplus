## SIGC_CXX_HAS_SUN_REVERSE_ITERATOR()
##
## Check for Sun libCstd style std::reverse_iterator, which demands more than just one template parameter.
## and #define SIGC_HAVE_SUN_REVERSE_ITERATOR if found.
##
AC_DEFUN([SIGC_CXX_HAS_SUN_REVERSE_ITERATOR],
[
  AC_CACHE_CHECK(
    [for non-standard Sun libCstd reverse_iterator],
    [sigc_cv_cxx_has_sun_reverse_iterator],
  [
    AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
    [[
      #include <iterator>
    ]],[[
      typedef std::reverse_iterator<char*, std::random_access_iterator_tag, char, char&, char*, int> ReverseIter;
    ]])],
      [sigc_cv_cxx_has_sun_reverse_iterator='yes'],
      [sigc_cv_cxx_has_sun_reverse_iterator='no']
    )
  ])

  AS_IF([test "x${sigc_cv_cxx_has_sun_reverse_iterator}" = 'xyes'],
  [AC_DEFINE([SIGC_HAVE_SUN_REVERSE_ITERATOR], [1], [Define if the non-standard Sun reverse_iterator must be used.])])
])
