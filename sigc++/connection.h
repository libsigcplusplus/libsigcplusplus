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
#ifndef _SIGC_CONNECTION_HPP_
#define _SIGC_CONNECTION_HPP_
#include <sigc++/signal.h>

namespace sigc {

/** Convinience class for safe disconnection.
 * Iterators must not be used beyond the lifetime of the list
 * they work on. A connection object can be created from a
 * slot list iterator and may safely be used to disconnect
 * the refered slot at any time (disconnect()). If the slot
 * has already been destroyed, disconnect() does nothing. empty() or
 * operator bool() can be used to test whether the connection is
 * still active. The connection can be blocked (block(), unblock()).
 * This is possibly because the connection object gets notified
 * when the refered slot dies (notify()).
 */
struct connection
{
  connection() : slot_(0) {}
  
  connection(const connection& c) : slot_(c.slot_)
    { if (slot_) slot_->add_dependency(this, &notify); }

  template <typename T_slot>
  connection(const internal::slot_iterator<T_slot>& it) : slot_(&(*it))
    { if (slot_) slot_->add_dependency(this, &notify); }

  connection& operator = (const connection& c)
    { set_slot(c.slot_); }

  template <typename T_slot>
  connection& operator = (const internal::slot_iterator<T_slot>& it)
    { set_slot(&(*it)); }

  ~connection()
    { if (slot_) slot_->remove_dependency(this); }

  bool empty() const
    { return (!slot_ || slot_->empty()); }

  inline bool blocked() const
    { return (slot_ ? slot_->blocked() : 0); }

  bool block(bool should_block = true)
    { if (slot_) return slot_->block(should_block); }

  bool unblock()
    { if (slot_) return slot_->unblock(); }

  void disconnect()
    { if (slot_) slot_->disconnect(); }

  operator bool()
    { return !empty(); }

  static void* notify(void* d);

  private:
    void set_slot(functor::internal::slot_base* cl);

    functor::internal::slot_base* slot_;
};

} /* namespace sigc */

#endif /* _SIGC_TRACKABLE_HPP_ */
