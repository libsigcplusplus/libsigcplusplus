/*
 * Copyright 2003, The libsigc++ Development Team
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
 */
#include <sigc++/signal_base.h>
#include <memory> // std::unique_ptr

namespace sigc {
namespace internal {

// Data sent from signal_impl::insert() to slot_rep::set_parent() when a slot is
// connected, and then sent from slot_rep::disconnect() to signal_impl::notify()
// when the slot is disconnected. Bug 167714.
struct self_and_iter
{
  signal_impl* self_;
  signal_impl::iterator_type iter_;

  self_and_iter(signal_impl* self, signal_impl::iterator_type iter)
    : self_(self), iter_(iter) {}
};

signal_impl::signal_impl()
: ref_count_(0), exec_count_(0), deferred_(0)
{}

// only MSVC needs this to guarantee that all new/delete are executed from the DLL module
#ifdef SIGC_NEW_DELETE_IN_LIBRARY_ONLY
void* signal_impl::operator new(size_t size_)
{
  return malloc(size_);
}

void signal_impl::operator delete(void* p)
{
  free(p);
}
#endif

void signal_impl::clear()
{
  // Don't let signal_impl::notify() erase the slots. It would invalidate the
  // iterator in the following loop.
  const bool saved_deferred = deferred_;
  signal_exec exec(this);

  // Disconnect all connected slots before they are deleted.
  // signal_impl::notify() will be called and delete the self_and_iter structs.
  for (auto& slot : slots_)
    slot.disconnect();

  deferred_ = saved_deferred;

  slots_.clear();
}

signal_impl::size_type signal_impl::size() const
{
  return slots_.size();
}

bool signal_impl::blocked() const
{
  for (const auto& slot : const_cast<const std::list<slot_base>&>(slots_))
  {
    if (!slot.blocked())
      return false;
  }
  return true;
}

void signal_impl::block(bool should_block)
{
  for (auto& slot : slots_)
  {
    slot.block(should_block);
  }
}

signal_impl::iterator_type signal_impl::connect(const slot_base& slot_)
{
  return insert(slots_.end(), slot_);
}

signal_impl::iterator_type signal_impl::erase(iterator_type i)
{
  // Don't let signal_impl::notify() erase the slot. It would be more
  // difficult to get the correct return value from signal_impl::erase().
  const bool saved_deferred = deferred_;
  signal_exec exec(this);

  // Disconnect the slot before it is deleted.
  // signal_impl::notify() will be called and delete the self_and_iter struct.
  i->disconnect();

  deferred_ = saved_deferred;

  return slots_.erase(i);
}
    
signal_impl::iterator_type signal_impl::insert(signal_impl::iterator_type i, const slot_base& slot_)
{
  auto temp = slots_.insert(i, slot_);
  auto si = new self_and_iter(this, temp);
  temp->set_parent(si, &notify);
  return temp;
}

void signal_impl::sweep()
{
  // The deletion of a slot may cause the deletion of a signal_base,
  // a decrementation of ref_count_, and the deletion of this.
  // In that case, the deletion of this is deferred to ~signal_exec().
  signal_exec exec(this);

  deferred_ = false;
  auto i = slots_.begin();
  while (i != slots_.end())
    if ((*i).empty())
      i = slots_.erase(i);
    else
      ++i;
}

//static
void* signal_impl::notify(void* d)
{
  std::unique_ptr<self_and_iter> si(static_cast<self_and_iter*>(d));

  if (si->self_->exec_count_ == 0)
  {
    // The deletion of a slot may cause the deletion of a signal_base,
    // a decrementation of si->self_->ref_count_, and the deletion of si->self_.
    // In that case, the deletion of si->self_ is deferred to ~signal_exec().
    signal_exec exec(si->self_);
    si->self_->slots_.erase(si->iter_);
  }
  else                           // This is occuring during signal emission or slot erasure.
    si->self_->deferred_ = true; // => sweep() will be called from ~signal_exec() after signal emission.
  return 0;                      // This is safer because we don't have to care about our
                                 // iterators in emit(), clear(), and erase().
}

} /* namespace internal */

signal_base::signal_base()
: impl_(nullptr)
{}

signal_base::signal_base(const signal_base& src)
: trackable(),
  impl_(src.impl())
{
  impl_->reference();
}

signal_base::~signal_base()
{
  if (impl_)
  {
    // Disconnect all slots before impl_ is deleted.
    // TODO: Move the signal_impl::clear() call to ~signal_impl() when ABI can be broken.
    if (impl_->ref_count_ == 1)
      impl_->clear();

    impl_->unreference();
  }
}

void signal_base::clear()
{
  if (impl_)
    impl_->clear();
}

signal_base::size_type signal_base::size() const
{
  return (impl_ ? impl_->size() : 0);
}

bool signal_base::blocked() const
{
  return (impl_ ? impl_->blocked() : true);
}

void signal_base::block(bool should_block)
{
  if (impl_)
    impl_->block(should_block);
}

void signal_base::unblock()
{
  if (impl_)
    impl_->block(false);
}

signal_base::iterator_type signal_base::connect(const slot_base& slot_)
{
  return impl()->connect(slot_);
}

signal_base::iterator_type signal_base::insert(iterator_type i, const slot_base& slot_)
{
  return impl()->insert(i, slot_);
}

signal_base::iterator_type signal_base::erase(iterator_type i)
{
  return impl()->erase(i);
}

signal_base& signal_base::operator = (const signal_base& src)
{
  if (src.impl_ == impl_) return *this;

  if (impl_)
  {
    // Disconnect all slots before impl_ is deleted.
    // TODO: Move the signal_impl::clear() call to ~signal_impl() when ABI can be broken.
    if (impl_->ref_count_ == 1)
      impl_->clear();

    impl_->unreference();
  }
  impl_ = src.impl();
  impl_->reference();
  return *this;
}

internal::signal_impl* signal_base::impl() const
{
  if (!impl_) {
    impl_ = new internal::signal_impl;
    impl_->reference();  // start with a reference count of 1
  }
  return impl_;
}

} /* sigc */
