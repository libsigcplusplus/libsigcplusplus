// -*- c++ -*-
/*
 * Copyright 2002, Karl Einar Nelson
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
#include <sigc++/functors/closure.h>

namespace sigc {
namespace functor {
namespace internal {

void* closure_rep::notify(void* p)
{
  closure_rep* self=(closure_rep*)p;
  self->call_=0;
  if (self->parent_)
    (self->cleanup_)(self->parent_);
  return 0;
}

void closure_base::set_dependency(void* parent, void* (*func)(void*)) const
{ 
  if (rep_)
    rep_->set_dependency(parent, func);
}

bool closure_base::empty() const 
{ 
  if (rep_&&!rep_->call_)
    {
      delete rep_;
      rep_=0;
    }
  return (rep_==0); 
}

bool closure_base::block(bool should_block)
{
  bool old = blocked_;
  blocked_ = should_block;
  return old;
}

void closure_base::disconnect()
{
  if (rep_)
    rep_->notify(rep_);
}

closure_base& closure_base::operator=(const closure_base& cl)
{
  if (cl.rep_==rep_) return *this;
  delete rep_;
  rep_=0;
  if (cl.rep_)
  {
    rep_=cl.rep_->dup();
  }
  return *this;
}

} /* namespace internal */
} /* namespace functor */
} /* sigc */
