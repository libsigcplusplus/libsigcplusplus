dnl
dnl SIGC_CXX_TEMPLATE_KEYWORD_OPERATOR_OVERLOAD()
dnl
dnl Test whether the compiler supports the template keyword when calling operator() template methods.
dnl
AC_DEFUN([SIGC_CXX_TEMPLATE_KEYWORD_OPERATOR_OVERLOAD],[
AC_MSG_CHECKING([if C++ compiler supports the template keyword when calling operator() template methods.])
AC_TRY_COMPILE(
[
  #include <iostream>

  class Thing
  {
    public:
    Thing()
    {}

    template <class T>
    void operator()(T a, T b)
    {
      T c = a + b;
      std::cout << c << std::endl;
    }
  };
],
[
    Thing thing_;
    thing_.template operator()<int>(1, 2);
],
[
  sigcm_cxx_template_keyword_operator_overload=yes
  AC_DEFINE([SIGC_TEMPLATE_KEYWORD_OPERATOR_OVERLOAD],[1],[does the compiler support the template keyword when calling operator() template methods.])
  AC_MSG_RESULT([$sigcm_cxx_template_keyword_operator_overload])
],[
  sigcm_cxx_template_keyword_operator_overload=no
  AC_DEFINE([SIGC_TEMPLATE_KEYWORD_OPERATOR_OVERLOAD],[0])
  AC_MSG_RESULT([$sigcm_cxx_template_keyword_operator_overload])
])
])



