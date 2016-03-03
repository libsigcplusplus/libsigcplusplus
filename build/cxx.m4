dnl
dnl SIGC_CXX_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD()
dnl
dnl
AC_DEFUN([SIGC_CXX_GCC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[
AC_MSG_CHECKING([if C++ compiler supports the use of a particular specialization when calling operator() template methods.])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
[[
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
]],
[[
  OtherThing<int> thing;
  thing.do_something();
]])],
[
  sigcm_cxx_gcc_template_specialization_operator_overload=yes
  AC_DEFINE([SIGC_GCC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[1],[does the C++ compiler support the use of a particular specialization when calling operator() template methods.])
],[
  sigcm_cxx_gcc_template_specialization_operator_overload=no
])
AC_MSG_RESULT([$sigcm_cxx_gcc_template_specialization_operator_overload])
])

AC_DEFUN([SIGC_CXX_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[
AC_MSG_CHECKING([if C++ compiler supports the use of a particular specialization when calling operator() template methods omitting the template keyword.])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
[[
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
]],
[[
  OtherThing<int> thing;
  thing.do_something();
]])],
[
  sigcm_cxx_msvc_template_specialization_operator_overload=yes
  AC_DEFINE([SIGC_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD],[1],[does the C++ compiler support the use of a particular specialization when calling operator() template methods omitting the template keyword.])
],[
  sigcm_cxx_msvc_template_specialization_operator_overload=no
])
AC_MSG_RESULT([$sigcm_cxx_msvc_template_specialization_operator_overload])
])

dnl
dnl SIGC_CXX_PRAGMA_PUSH_POP_MACRO
dnl
dnl TODO: When we can break ABI, delete this. It's used when nil is
dnl temporarily undefined. See comment in functor_trait.h.
dnl
AC_DEFUN([SIGC_CXX_PRAGMA_PUSH_POP_MACRO],[
AC_MSG_CHECKING([if C++ preprocessor supports pragma push_macro() and pop_macro().])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
[[
  #define BEGIN {
  #define END   }
  #pragma push_macro("BEGIN")
  #pragma push_macro("END")
  #undef BEGIN
  #undef END

  // BEGIN and END are not prepreprocessor macros
  struct Test1
  {
    int BEGIN;
    double END;
  };

  #pragma pop_macro("BEGIN")
  #pragma pop_macro("END")

  // BEGIN and END are prepreprocessor macros
  struct Test2
  BEGIN
    int i;
    double d;
  END;

  void func1(Test1& x);
  void func2(Test2& x);
]],
[[
  Test1 test1;
  Test2 test2;
  func1(test1);
  func2(test2);
]])],
[
  sigcm_cxx_pragma_push_pop_macro=yes
  AC_DEFINE([SIGC_PRAGMA_PUSH_POP_MACRO],[1],[does the C++ preprocessor support pragma push_macro() and pop_macro().])
],[
  sigcm_cxx_pragma_push_pop_macro=no
])
AC_MSG_RESULT([$sigcm_cxx_pragma_push_pop_macro])
])
