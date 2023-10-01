## Copyright (c) 2009  Openismus GmbH  <http://www.openismus.com/>
##
## This file is part of libsigc++.
##
## libsigc++ is free software: you can redistribute it and/or modify it
## under the terms of the GNU Lesser General Public License as published
## by the Free Software Foundation, either version 2.1 of the License,
## or (at your option) any later version.
##
## libsigc++ is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this library.  If not, see <http://www.gnu.org/licenses/>.

AC_INIT([libsigc++], [3.6.0],
        [https://github.com/libsigcplusplus/libsigcplusplus/issues/],
        [libsigc++], [https://libsigcplusplus.github.io/libsigcplusplus/])
AC_PREREQ([2.59])

AC_CONFIG_SRCDIR([sigc++/sigc++.h])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build])
AC_CONFIG_HEADERS([config.h sigc++config.h])

AM_INIT_AUTOMAKE([1.9 -Wno-portability check-news no-dist-gzip dist-xz tar-ustar no-define nostdinc foreign])
# Support silent build rules.
# Disable by either passing --disable-silent-rules to configure or passing V=1 to make.
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
AM_MAINTAINER_MODE
AC_ARG_VAR([ACLOCAL_FLAGS], [aclocal flags, e.g. -I <macro dir>])

MM_PREREQ([0.9.12])
MM_INIT_MODULE([sigc++-3.0])
MM_CONFIG_DOCTOOL_DIR([docs/docs])

AC_PROG_CXX
MM_AX_CXX_COMPILE_STDCXX([17],[noext],[mandatory])

AC_DISABLE_STATIC
LT_INIT([win32-dll])

MM_ARG_ENABLE_DOCUMENTATION
MM_ARG_WITH_TAGFILE_DOC([libstdc++.tag], [mm-common-libstdc++])

AC_LANG([C++])

AS_IF([test "x$config_error" = xyes],
      [AC_MSG_FAILURE([[One or more of the required C++ compiler features is missing.]])])

# Evaluate the --enable-warnings=level option.
MM_ARG_ENABLE_WARNINGS([SIGC_WXXFLAGS],
                       [-Wall],
                       [-pedantic -Wall -Wextra -Wsuggest-override -Wshadow -Wzero-as-null-pointer-constant -Wformat-security])

# Offer the ability to omit some API from the library.
MM_ARG_DISABLE_DEPRECATED_API([SIGCXX])

AC_ARG_ENABLE(benchmark,
  AS_HELP_STRING([--enable-benchmark=yes|no])
)

AM_CONDITIONAL([SIGC_BUILD_BENCHMARK], [test "x$enable_benchmark" = xyes])

AS_IF([test "x$enable_benchmark" = xyes],[
  #Use boost::timer for our benchmark, if it's available.
  # See http://www.gnu.org/software/autoconf-archive/ax_boost_base.html
  # Boost System is needed by Boost Timer
  AX_BOOST_BASE
  AX_BOOST_SYSTEM
  AX_BOOST_TIMER
])

AC_SUBST(MSVC_STATIC_CXXFLAG, '')
AC_SUBST(DOXYGEN_HAVE_DOT, [YES])
AM_SUBST_NOTMAKE(DOXYGEN_HAVE_DOT)

AC_CONFIG_FILES([Makefile
                 ${SIGCXX_MODULE_NAME}.pc:sigc++.pc.in
                 ${SIGCXX_MODULE_NAME}-uninstalled.pc:sigc++-uninstalled.pc.in
                 cmake/Makefile
                 sigc++/Makefile
                 examples/Makefile
                 tests/Makefile
                 docs/docs/Makefile
                 docs/docs/reference/Doxyfile
                 MSVC_NMake/sigc.rc])

# Copy the generated configuration headers into the MSVC NMake directory.
AC_CONFIG_COMMANDS([MSVC_NMake/sigc++config.h],
                   [cp -f sigc++config.h MSVC_NMake/sigc++config.h])
AC_OUTPUT
