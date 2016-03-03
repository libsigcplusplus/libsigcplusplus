AC_DEFUN([SIGC_CXX_SELF_REFERENCE_IN_MEMBER_INITIALIZATION], [
AC_MSG_CHECKING([if C++ compiler allows usage of member function in initialization of static member field.])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM(
[[
  struct test
  {
    static char  test_function();

    // Doesn't work with e.g. GCC 3.2.  However, if test_function()
    // is wrapped in a nested structure, it works just fine.
    static const bool  test_value
      = (sizeof(test_function()) == sizeof(char));
  };
]],
[[]])],
[
  sigcm_cxx_self_reference_in_member_initialization=yes
  AC_DEFINE([SIGC_SELF_REFERENCE_IN_MEMBER_INITIALIZATION],[1],
            [does the C++ compiler allow usage of member function in initialization of static member field.])
],[
  sigcm_cxx_self_reference_in_member_initialization=no
])
AC_MSG_RESULT([$sigcm_cxx_self_reference_in_member_initialization])
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
