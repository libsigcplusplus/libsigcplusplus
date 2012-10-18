/* Copyright (C) 2012 The libsigc++ Development Team
 *
 * This file is part of libsigc++.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library. If not, see <http://www.gnu.org/licenses/>.
 */

#include <string>
#include <sstream>

// Functions used in several test cases in libsigc++.
// This is a singleton class.
class TestUtilities
{
public:
  static TestUtilities* get_instance();
  bool check_command_args(int argc, char* argv[]);
  void check_result(std::ostringstream& result_stream, const std::string& expected_result);
  bool get_verbose() const { return verbose_; }
  bool get_result() const { return result_ok_; }

  // When you are searching for memory leaks with valgrind or a similar program,
  // you avoid a harmless warning by deleting the instance when you're done with it.
  static bool get_result_and_delete_instance();

private:
  // Not copyable. These are not implemented.
  TestUtilities(const TestUtilities&);
  TestUtilities& operator=(const TestUtilities&);

  TestUtilities();

  static TestUtilities* instance_;
  bool verbose_;
  bool result_ok_;
  int test_number_;
};
