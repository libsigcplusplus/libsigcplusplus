dnl
dnl SIGC_CXX_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD()
dnl
dnl
AC_DEFUN([SIGC_CXX_GCC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[
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
  sigcm_cxx_gcc_template_specialization_operator_overload=yes
  AC_DEFINE([SIGC_GCC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[1],[does the C++ compiler support the use of a particular specialization when calling operator() template methods.])
  AC_MSG_RESULT([$sigcm_cxx_gcc_template_specialization_operator_overload])
],[
  sigcm_cxx_gcc_template_specialization_operator_overload=no
  AC_MSG_RESULT([$sigcm_cxx_gcc_template_specialization_operator_overload])
])
])
AC_DEFUN([SIGC_CXX_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[
AC_MSG_CHECKING([if C++ compiler supports the use of a particular specialization when calling operator() template methods omitting the template keyword.])
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
       thing_.operator()<T2>(1, 2);
       //This fails with or without the template keyword, on SUN Forte C++ 5.3, 5.4, and 5.5:
    }
  };
],
[
  OtherThing<int> thing;
  thing.do_something();
],
[
  sigcm_cxx_msvc_template_specialization_operator_overload=yes
  AC_DEFINE([SIGC_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[1],[does the C++ compiler support the use of a particular specialization when calling operator() template methods omitting the template keyword.])
  AC_MSG_RESULT([$sigcm_cxx_msvc_template_specialization_operator_overload])
],[
  sigcm_cxx_msvc_template_specialization_operator_overload=no
  AC_MSG_RESULT([$sigcm_cxx_msvc_template_specialization_operator_overload])
])
])
AC_DEFUN([SIGC_CXX_OPERATOR_OVERLOAD_AMBIGUITY],[
AC_MSG_CHECKING([if C++ compiler reports an ambiguity for operator overloads.])
AC_TRY_COMPILE(
[
  #include <iostream>

  struct Thing
  {};

  template<class T>
  struct OtherThing
  {};

  template <class T1, class T2>
  Thing operator+ (const OtherThing<T1>& a1, const T2& a2) { return Thing(); }

  template <class T1, class T2>
  Thing operator+ (const T1& a1, const OtherThing<T2>& a2) { return Thing(); }

  template <class T1, class T2>
  Thing operator+ (const OtherThing<T1>& a1, const OtherThing<T2>& a2) { return Thing(); }
],
[
  Thing thing;
  OtherThing<int> other_thing;

  Thing thing1 = thing + other_thing;
  Thing thing2 = other_thing + thing;
  Thing thing3 = other_thing + other_thing;
],
[
  sigcm_cxx_operator_overload_ambiguity=no
  AC_MSG_RESULT([$sigcm_cxx_operator_overload_ambiguity])
],[
  sigcm_cxx_operator_overload_ambiguity=yes
  AC_DEFINE([SIGC_OPERATOR_OVERLOAD_AMBIGUITY],[1],[does the C++ compiler report an ambiguity for operator overloads.])
  AC_MSG_RESULT([$sigcm_cxx_operator_overload_ambiguity])
])
])
