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

  template<class T2>
  class OtherThing
  {
  public:
    void do_something()
    {
       Thing thing_;
       thing_.template operator()<T2>(1, 2);
       //This fails with or without the template keyword, on SUN Forte C++ 5.3, 5.4, and 5.5:
    }
  };
],
[
  OtherThing<int> thing;
  thing.do_something();
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

AC_DEFUN([SIGC_CXX_TEMPLATE_SPECIALIZATION_MULTIPLE],[
AC_MSG_CHECKING([if C++ compiler chooses the correct template specialization when offered different ones for different numbers unspecified arguments left.])
AC_TRY_COMPILE(
[
  #include <iostream>

  template <class T_type1, class T_type2>
  struct Thing
  {
    static const int value = 0;
  };

  template <class T_type1>
  struct Thing<T_type1, void>
  {
    static const int value = 1;
  };

  template <>
  struct Thing<void,void>
  {
    static const int value = 2;
  };
],
[
    //This fails on Apple gcc 3.3:
    std::cout << "number of void arguments: " << Thing<void,void>::value << std::endl;
],
[
  sigcm_cxx_template_specialization_multiple=yes
  AC_DEFINE([SIGC_TEMPLATE_SPECIALIZATION_MULTIPLE],[1],[does the C++ compiler choose the correct template specialization when offered different ones for different numbers unspecified arguments left.])
  AC_MSG_RESULT([$sigcm_cxx_template_specialization_multiple])
],[
  sigcm_cxx_template_specialization_multiple=no
  AC_DEFINE([SIGC_TEMPLATE_SPECIALIZATION_MULTIPLE],[0])
  AC_MSG_RESULT([$sigcm_cxx_template_specialization_multiple])
])
])
