# Copyright 2016, The libsigc++ Development Team
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

cmake_minimum_required (VERSION 3.4)

set (SIGCXX_MAJOR_VERSION 2)
set (SIGCXX_MINOR_VERSION 99)
set (SIGCXX_MICRO_VERSION 1)

set (LIBSIGCPP_PROJECT_VERSION 3.0)
set (LIBSIGCPP_VERSION ${SIGCXX_MAJOR_VERSION}.${SIGCXX_MINOR_VERSION}.${SIGCXX_MICRO_VERSION})
set (LIBSIGCPP_SOVERSION 0)

option (SIGCXX_DISABLE_DEPRECATED "Disable deprecated" OFF)

project (libsigc++ ${LIBSIGC++_PROJECT_VERSION})

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")

set (PROJECT_SOURCE_DIR "${libsigc++_SOURCE_DIR}/sigc++")

include_directories (${libsigc++_SOURCE_DIR})
include_directories (${libsigc++_BINARY_DIR})

configure_file (sigc++config.h.cmake sigc++config.h)

enable_testing()

add_subdirectory (sigc++)
add_subdirectory (examples)
add_subdirectory (tests)

