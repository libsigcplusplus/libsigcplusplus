dnl
dnl SIGC_CXX_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD()
dnl
dnl
AC_DEFUN([SIGC_CXX_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[
AC_MSG_CHECKING([if C++ compiler supports the use of a particular specialization when calling operator() template methods.])
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

    //This fails with or without the template keyword, on SUN Forte C++ 5.3, 5.4, and 5.5:
    thing_.template operator()<int>(1, 2);
],
[
  sigcm_cxx_template_specialization_operator_overload=yes
  AC_DEFINE([SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[1],[does the C++ compiler support the use of a particular specialization when calling operator() template methods.])
  AC_MSG_RESULT([$sigcm_cxx_template_specialization_operator_overload])
],[
  sigcm_cxx_template_specialization_operator_overload=no
  AC_DEFINE([SIGC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[0])
  AC_MSG_RESULT([$sigcm_cxx_template_specialization_operator_overload])
])
])



