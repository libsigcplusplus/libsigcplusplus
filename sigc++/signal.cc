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
#include <sigc++/signal.h>

namespace sigc {
namespace internal {

void* signal_base::notify(void* d)
{
  signal_base* self = (signal_base*)d;
  if (self->exec_count_ == 0)
    self->sweep();
  else 
    self->defered_ = true;
  return 0;
}

signal_base::iterator_type signal_base::insert(signal_base::iterator_type i, const functor::internal::closure_base& slot_)
{
  iterator_type temp = slots_.insert(i, slot_);
  slot_.set_dependency(this, &notify);
  return temp;
}

void signal_base::sweep()
{ 
  std::list<functor::internal::closure_base>::iterator i = slots_.begin();
  while (i != slots_.end())
    if ((*i).empty())  
      i = slots_.erase(i);
    else 
      ++i;
}

} /* namespace internal */
} /* sigc */
