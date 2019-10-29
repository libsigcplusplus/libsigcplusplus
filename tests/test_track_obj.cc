/* Copyright (C) 2013 - 2016, The libsigc++ Development Team
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

// The purpose of this test case is threefold.
// - Test sigc::track_obj().
// - Show that a slot with a C++11 lambda expression can be automatically
//   disconnected when an object derived from sigc::trackable is deleted,
//   provided sigc::track_obj() is used.
//   It shows that C++11 lambda expressions can replace the libsigc++ lambda
//   expressions, which have been removed.
//   See https://bugzilla.gnome.org/show_bug.cgi?id=672555
// - Test the code example in the documentation in sigc++/adaptors/track_obj.h.
//
// If test_track_obj writes nothing and the return code is 0, the test has passed.

#include "testutilities.h"
#include <iostream>
#include <sigc++/adaptors/track_obj.h>
#include <sigc++/signal.h>

namespace
{
std::ostringstream result_stream;

struct book : public sigc::trackable
{
  explicit book(const std::string& name) : name_(name) {}
  operator std::string&() { return name_; }
  operator const std::string&() const { return name_; }
  std::string name_;
};

struct bar_group4 : public sigc::trackable
{
};

class Functor1
{
public:
  explicit Functor1(const bar_group4& bar) : bar_(bar) {}

  std::string operator()(int i) { return (i < 0) ? "negative" : ((i > 0) ? "positive" : "zero"); }

protected:
  // Don't make it private. clang++ does not like unused private data.
  const bar_group4& bar_;
};

class Functor2
{
public:
  Functor2(const bar_group4& bar, const book& aBook) : bar_(bar), aBook_(aBook) {}

  std::string operator()(int i, const std::string& str) const
  {
    std::string result = (i < 0) ? "negative, " : ((i > 0) ? "positive, " : "zero, ");
    result += str;
    result += aBook_;
    return result;
  }

protected:
  // Don't make it private. clang++ does not like unused private data.
  const bar_group4& bar_;

private:
  const book& aBook_;
};

// C++11 lamba expressions:

inline std::ostringstream&
operator<<(std::ostringstream& s, const book& b)
{
  s << b.name_;
  return s;
}

void
egon(std::string& str)
{
  result_stream << "egon(string '" << str << "')";
  str = "egon was here";
}

void
foo_group4(bar_group4&)
{
  result_stream << "foo_group4(bar_group4&)";
}

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  sigc::slot<std::string(int)> sl1;
  {
    bar_group4 bar4;
    sl1 = sigc::track_obj(Functor1(bar4), bar4);
    result_stream << sl1(-2);
    util->check_result(result_stream, "negative");

  } // auto-disconnect sl1

  result_stream << sl1(-2);
  util->check_result(result_stream, "");

  // Allocate on the heap. valgrind can then find erroneous memory accesses.
  // (There should be none, of course.)
  auto psl2 = new sigc::slot<std::string(int, std::string)>;
  auto pbar4 = new bar_group4;
  auto pbook4 = new book("A Book");
  *psl2 = sigc::track_obj(Functor2(*pbar4, *pbook4), *pbar4, *pbook4);
  result_stream << (*psl2)(0, "Book title: ");
  util->check_result(result_stream, "zero, Book title: A Book");

  delete pbook4; // auto-disconnect *psl2
  pbook4 = nullptr;
  result_stream << (*psl2)(0, "Book title: ");
  util->check_result(result_stream, "");
  delete psl2;
  psl2 = nullptr;
  delete pbar4;
  pbar4 = nullptr;

  // C++11 lambda expressions:

  // auto-disconnect
  // If you want to auto-disconnect a slot with a C++11 lambda expression
  // that contains references to sigc::trackable-derived objects, you must use
  // sigc::track_obj().
  sigc::slot<void(std::ostringstream&)> sl10;
  {
    book guest_book("karl");
    // sl1 = [&guest_book](std::ostringstream& stream){ stream << guest_book << "\n"; }; // no
    // auto-disconnect
    sl10 = sigc::track_obj(
      [&guest_book](std::ostringstream& stream) { stream << guest_book; }, guest_book);
    sl10(result_stream);
    util->check_result(result_stream, "karl");

  } // auto-disconnect sl10

  sl10(result_stream);
  util->check_result(result_stream, "");

  // auto-disconnect
  sigc::slot<void()> sl20;
  {
    book guest_book("karl");
    // sl2 = [&guest_book] () { egon(guest_book); }; // no auto-disconnect
    // sl2 = std::bind(&egon, std::ref(guest_book)); // does not compile (gcc 4.6.3)
    sl20 = sigc::track_obj([&guest_book]() { egon(guest_book); }, guest_book);
    sl20();
    util->check_result(result_stream, "egon(string 'karl')");

    result_stream << static_cast<const std::string&>(guest_book);
    util->check_result(result_stream, "egon was here");

  } // auto-disconnect sl20

  sl20();
  util->check_result(result_stream, "");

  // Code example in the documentation sigc++/adaptors/track_obj.h.
  // --------------------------------------------------------------
  {
    // struct bar : public sigc::trackable {} some_bar;
    sigc::signal<void()> some_signal;
    {
      bar_group4 some_bar;
      // some_signal.connect([&some_bar](){ foo_group4(some_bar); }); // no auto-disconnect
      // some_signal.connect(sigc::bind(&foo_group4, std::ref(some_bar))); // auto-disconnects,
      //   but we prefer C++11 lambda
      some_signal.connect(sigc::track_obj([&some_bar]() { foo_group4(some_bar); }, some_bar));
      some_signal.emit();
      util->check_result(result_stream, "foo_group4(bar_group4&)");

    } // auto-disconnect the lambda expression

    some_signal.emit();
    util->check_result(result_stream, "");
  }

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
