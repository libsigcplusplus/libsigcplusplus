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

AC_INIT([libsigc++], [2.2.3],
        [http://bugzilla.gnome.org/enter_bug.cgi?product=libsigc%2B%2B],
        [libsigc++], [http://libsigc.sourceforge.net/])
AC_PREREQ([2.59])

AC_CONFIG_SRCDIR([sigc++/sigc++.h])
AC_CONFIG_AUX_DIR([scripts])
AC_CONFIG_MACRO_DIR([scripts])
AC_CONFIG_HEADERS([config.h sigc++config.h])

AM_INIT_AUTOMAKE([1.9 -Wno-portability no-define nostdinc tar-pax])
AM_MAINTAINER_MODE
AC_ARG_VAR([ACLOCAL_FLAGS], [aclocal flags, e.g. -I <macro dir>])

MM_INIT_MODULE([sigc++-2.0], m4_expand([AC_PACKAGE_VERSION]))
MM_CONFIG_DOCTOOL_DIR([scripts])

AC_PROG_CXX
AC_DISABLE_STATIC
AC_LIBTOOL_WIN32_DLL
AC_PROG_LIBTOOL

AC_ARG_VAR([M4], [M4 macro processor command])
AC_CHECK_PROGS([M4], [gm4 m4])

AS_IF([test "x$M4" = x],
      [AC_MSG_FAILURE([[The GNU M4 macro processor is required for building libsigc++.]])])

MM_ARG_ENABLE_DOCUMENTATION
MM_ARG_WITH_TAGFILE_DOC([libstdc++.tag], [mm-common-libstdc++])

AC_LANG([C++])
SIGC_CXX_GCC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
SIGC_CXX_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
SIGC_CXX_SELF_REFERENCE_IN_MEMBER_INITIALIZATION
SIGC_CXX_HAS_NAMESPACE_STD
SIGC_CXX_HAS_SUN_REVERSE_ITERATOR

AS_IF([test "x$config_error" = xyes],
      [AC_MSG_FAILURE([[One or more of the required C++ compiler features is missing.]])])

MM_ARG_ENABLE_WARNINGS([SIGC_WXXFLAGS],
                       [-Wall],
                       [-pedantic -Wall -Wextra])

AC_CONFIG_FILES([Makefile
                 sigc++-2.0.pc
                 sigc++-2.0-uninstalled.pc
                 sigc++/Makefile
                 examples/Makefile
                 tests/Makefile
                 docs/Makefile
                 docs/reference/Doxyfile
                 MSVC_Net2005/Makefile
                 MSVC_Net2005/sigc-2.0.rc
                 MSVC_Net2008/Makefile
                 MSVC_Net2008/sigc-2.0.rc])
AC_OUTPUT
