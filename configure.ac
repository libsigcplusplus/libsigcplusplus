dnl Configure.in
dnl
dnl  Source for generating compiler independent libraries.
dnl

dnl INIT is required name a file which is unique to the package
dnl just to prevent someone from copying the configure to the wrong package.
AC_INIT(sigc++)

dnl This version stuff is just for the packaging section of the tool.
dnl   thus make format_package-0.0.1.tar.gz  
FP_MAJOR_VERSION=2
FP_MINOR_VERSION=0
FP_MICRO_VERSION=1
FP_VERSION=$FP_MAJOR_VERSION.$FP_MINOR_VERSION.$FP_MICRO_VERSION

dnl For automake.
VERSION=$FP_VERSION
PACKAGE=libsigc++

dnl Initialize automake stuff
AM_INIT_AUTOMAKE($PACKAGE, $VERSION)

dnl Specify a configuration file:
AC_CONFIG_HEADER(sigc++config.h)

dnl Macros to support windows platforms
AC_CYGWIN
#AC_MINGW32
AC_EXEEXT

dnl this package needs m4
AC_CHECK_PROGS(M4, gm4 m4, m4)

dnl perl is needed for building the reference documentation
AC_PATH_PROGS([PERL_PATH], [perl perl5], [perl])
AC_SUBST([PERL_PATH])

dnl disable autoheader
AUTOHEADER=':'

dnl Maintainer support (autodependencies and packaging)
AM_MAINTAINER_MODE

dnl Using C compiler
AC_PROG_CC
AC_PROG_CPP

dnl Used for enabling the "-no-undefined" flag while generating DLLs
dnl Borrowed from the official gtk+-2 configure.in
AC_MSG_CHECKING([for some Win32 platform])
case "$host" in
  *-*-mingw*|*-*-cygwin*)
    platform_win32=yes
    ;;
  *)
    platform_win32=no
    ;;
esac
AC_MSG_RESULT([$platform_win32])
AM_CONDITIONAL(PLATFORM_WIN32, test "$platform_win32" = "yes")

dnl Using libtool
AC_LIBTOOL_WIN32_DLL
AM_PROG_LIBTOOL

dnl Using C++ compiler
AC_PROG_CXX
AC_LANG_CPLUSPLUS

SIGC_CXX_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD()

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
  sigc++-2.0.pc

  sigc++/Makefile
  scripts/Makefile
  tests/Makefile
  examples/Makefile
  MSVC_Net2003/Makefile

  docs/Makefile
    docs/images/Makefile
    docs/reference/Makefile
    docs/reference/Doxyfile
])
