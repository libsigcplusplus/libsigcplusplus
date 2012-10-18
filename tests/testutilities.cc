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

#include "testutilities.h"

#include <iostream>
#include <cstring>

TestUtilities* TestUtilities::instance_ = 0;

TestUtilities::TestUtilities()
: verbose_(false), result_ok_(true), test_number_(0)
{
}

//static
TestUtilities* TestUtilities::get_instance()
{
  if (!instance_)
    instance_ = new TestUtilities;

  return instance_;
}

bool TestUtilities::check_command_args(int argc, char* argv[])
{
  bool go_on = true; // Whether the caller shall continue program execution.
  bool print_help = false;
  for (int argi = 1; argi < argc; ++argi)
  {
    if (std::strcmp(argv[argi], "-v") == 0 || std::strcmp(argv[argi], "--verbose") == 0)
    {
      verbose_ = true;
    }
    else
    {
      print_help = true;
      go_on = false;
      if (!(std::strcmp(argv[argi], "-h") == 0 || std::strcmp(argv[argi], "--help") == 0))
      {
        result_ok_ = false;
        std::cout << "Unknown command argument: " << argv[argi] << std::endl;
      }
    }
  }

  if (print_help)
    std::cout << "Usage: " << argv[0] << " [-h|--help] [-v|--verbose]" << std::endl;

  return go_on;
}

void TestUtilities::check_result(std::ostringstream& result_stream,
                                 const std::string& expected_result)
{
  if (verbose_)
    std::cout << result_stream.str() << std::endl;

  ++test_number_;
  if (expected_result != result_stream.str())
  {
    std::cerr << "   Test " << test_number_ << std::endl;
    std::cerr << "Expected \"" << expected_result << "\"" << std::endl;
    std::cerr << "Got      \"" << result_stream.str() << "\"" << std::endl;
    result_ok_ = false;
  }
  result_stream.str("");
}

//static
bool TestUtilities::get_result_and_delete_instance()
{
  const bool result = instance_ ? instance_->result_ok_ : true;
  delete instance_;
  instance_ = 0;
  return result;
}
