// -*- c++ -*-
/*
 * Copyright 2002, The libsigc++ Development Team
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 */

#include <sigc++/trackable.h>
#include <iostream>
using namespace std;

namespace sigc {
namespace internal {

trackable_callback_list::~trackable_callback_list()
{
  clearing_ = true;

  for (callback_list::iterator i = callbacks_.begin(); i != callbacks_.end(); ++i)
    (*i).func_((*i).data_);
}

void trackable_callback_list::add_callback(void* data, void* (*func)(void*) )
{
  if (!clearing_)  // TODO: Is it okay to silently ignore attempts to add dependencies when the list is being cleared?
                   //       I'd consider this a serious application bug, since the app is likely to segfault.
                   //       But then, how should we handle it? Throw an exception? Martin.
    callbacks_.push_back(trackable_callback(data,func));
}

void trackable_callback_list::clear()
{
  clearing_ = true;

  for (callback_list::iterator i = callbacks_.begin(); i != callbacks_.end(); ++i)
    (*i).func_((*i).data_);

  callbacks_.clear();

  clearing_ = false;
}

void trackable_callback_list::remove_callback(void* data)
{
  if (clearing_) return; // No circular notices

  for (callback_list::iterator i = callbacks_.begin(); i != callbacks_.end(); ++i)
    if ((*i).data_ == data)
    {
      callbacks_.erase(i);
      return;
    }
}

} /* namespace internal */


void trackable::notify_callbacks()
{
  if (callback_list_)
    delete callback_list_;

  callback_list_ = 0;
}

internal::trackable_callback_list* trackable::callback_list() const
{
  if (!callback_list_)
    callback_list_ = new internal::trackable_callback_list;

  return callback_list_;
}

} /* namespace sigc */
