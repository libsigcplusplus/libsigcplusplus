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

trackable_dep_list::~trackable_dep_list()
{ 
  clearing_ = true;
  
  for (dep_list::iterator i = deps_.begin(); i != deps_.end(); ++i)
    (*i).func_((*i).obj_);
}

void trackable_dep_list::add_dependency(void* target, void* (*func)(void*) )
{
  if (!clearing_)  // TODO: Is it okay to silently ignore attempts to add dependencies when the list is being cleared?
                   //       I'd consider this a serious application bug, since the app is likely to segfault.
                   //       But then, how should we handle it? Throw an exception? Martin.
    deps_.push_back(trackable_dependency(target,func));
}

void trackable_dep_list::clear()
{
  clearing_ = true;
  
  for (dep_list::iterator i=deps_.begin(); i!=deps_.end(); ++i)
    (*i).func_((*i).obj_);
    
  clearing_ = false;
}

void trackable_dep_list::remove_dependency(void* target)
{
  if (clearing_) return; // No circular notices
  
  for (dep_list::iterator i = deps_.begin(); i != deps_.end(); ++i)
    if ((*i).obj_ == target) 
      { 
        deps_.erase(i); return;
      }
}

} /* namespace internal */
} /* namespace sigc */
