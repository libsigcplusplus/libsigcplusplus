dnl Configure.in
dnl
dnl  Source for generating compiler independent libraries.
dnl

dnl INIT is required name a file which is unique to the package
dnl just to prevent someone from copying the configure to the wrong package.
AC_INIT(sigc++)

dnl This version stuff is just for the packaging section of the tool.
dnl   thus make format_package-0.0.1.tar.gz  
FP_MAJOR_VERSION=1
FP_MINOR_VERSION=9
FP_MICRO_VERSION=5
FP_VERSION=$FP_MAJOR_VERSION.$FP_MINOR_VERSION.$FP_MICRO_VERSION

dnl For automake.
VERSION=$FP_VERSION
PACKAGE=libsigc++


dnl I don't like to look at the automake cruft.
#This just complicates things. murrayc
#AC_CONFIG_AUX_DIR(scripts)

dnl C++ libraries should generally be static if the interface is subject
dnl to a lot of change.
AM_DISABLE_SHARED

dnl Initialize automake stuff
AM_INIT_AUTOMAKE($PACKAGE, $VERSION)

dnl Macros to support windows platforms
AC_CYGWIN
#AC_MINGW32
AC_EXEEXT

dnl this package needs m4
AC_CHECK_PROGS(M4, gm4 m4, m4)

dnl disable autoheader
AUTOHEADER=':'

dnl Maintainer support (autodependencies and packaging)
AM_MAINTAINER_MODE

dnl Using C compiler
AC_PROG_CC
AC_PROG_CPP

dnl Using libtool
AC_LIBTOOL_WIN32_DLL
AM_PROG_LIBTOOL

dnl Using C++ compiler
AC_PROG_CXX
AC_LANG_CPLUSPLUS

AC_MSG_CHECKING(if C++ compiler supports typeof (required))
AC_TRY_COMPILE(
[
  float func(int);
],[
  typedef typeof(func(1)) type;
  type a=1.0;
],[
  ac_typeof=yes
],[
  ac_typeof=no
  config_error=yes
])
AC_MSG_RESULT([$ac_typeof])

AC_MSG_CHECKING(if C++ compiler supports template typeof (required))
AC_TRY_COMPILE(
[
  template <class T>
  struct foo
  {
    typedef typeof( T::operator()(0) ) T2;
  };
],[
],[
   ac_template_typeof=yes
],[
   ac_template_typeof=no
   config_error=yes
])
AC_MSG_RESULT([$ac_template_typeof])

if test "X$config_error" = "Xyes" ; then
  AC_ERROR(
[One or more of the required compiler features is missing.
If you believe this is in error, please consult the config.log file
for further details.
])
fi
 


# Generate output
AC_OUTPUT([
  Makefile
  tests/Makefile
  examples/Makefile
  sigc++/Makefile
])

