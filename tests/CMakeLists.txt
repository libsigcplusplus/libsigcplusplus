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

enable_testing ()

function (add_sigcpp_test TEST_SOURCE_FILE)
	get_filename_component (test_name ${TEST_SOURCE_FILE} NAME_WE)
	add_executable (${test_name} ${TEST_SOURCE_FILE} testutilities.cc)
	target_link_libraries (${test_name} ${PROJECT_NAME}-${SIGCXX_API_VERSION})
	add_test (${test_name} ${CMAKE_CURRENT_BINARY_DIR}/${test_name})
endfunction (add_sigcpp_test)

file(GLOB test_files "test_*.cc")
foreach (test_file ${test_files})
	add_sigcpp_test (${test_file})
endforeach()
