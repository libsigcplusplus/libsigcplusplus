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
 *
 */

#include <sigc++/functors/slot_base.h>

namespace
{
// Used by slot_rep::notify() and slot_base::operator=(). They must be
// notified, if the slot_rep is deleted when they call disconnect().
struct destroy_notify_struct
{
  destroy_notify_struct() : deleted_(false) { }

  static void* notify(void* data)
  {
    auto self_ = reinterpret_cast<destroy_notify_struct*>(data);
    self_->deleted_ = true;
    return 0;
  }

  bool deleted_;
};
} // anonymous namespace

namespace sigc
{
namespace internal
{
// only MSVC needs this to guarantee that all new/delete are executed from the DLL module
#ifdef SIGC_NEW_DELETE_IN_LIBRARY_ONLY
void* slot_rep::operator new(size_t size_)
{
  return malloc(size_);
}

void slot_rep::operator delete(void* p)
{
  free(p);
}
#endif

//TODO: When we can break API: Is it necessary to invalidate the slot here?
// If the parent misbehaves, when the slot is not invalidated, isn't that
// a problem that should be fixed in the parent?
// See discussion in https://bugzilla.gnome.org/show_bug.cgi?id=738602
void slot_rep::disconnect()
{
  if (parent_)
  {
    call_ = nullptr;          // Invalidate the slot.
                        // _Must_ be done here because parent_ might defer the actual
                        // destruction of the slot_rep and try to invoke it before that point.
    auto data_ = parent_;
    parent_ = nullptr;        // Just a precaution.
    (cleanup_)(data_);  // Notify the parent (might lead to destruction of this!).
  }
  else
    call_ = nullptr;
}

//static
void* slot_rep::notify(void* data)
{
  auto self_ = reinterpret_cast<slot_rep*>(data);

  self_->call_ = nullptr; // Invalidate the slot.
  
  // Make sure we are notified if disconnect() deletes self_, which is trackable.
  destroy_notify_struct notifier;
  self_->add_destroy_notify_callback(&notifier, destroy_notify_struct::notify);
  self_->disconnect(); // Disconnect the slot (might lead to deletion of self_!).
  // If self_ has been deleted, the destructor has called destroy().
  if (!notifier.deleted_)
  {
    self_->remove_destroy_notify_callback(&notifier);
    self_->destroy(); // Detach the stored functor from the other referred trackables and destroy it.
                      // destroy() might lead to deletion of self_. Bug #564005.
  }
  return 0;
}

} // namespace internal
  
slot_base::slot_base()
: rep_(nullptr),
  blocked_(false)
{}

slot_base::slot_base(rep_type* rep)
: rep_(rep),
  blocked_(false)
{}

slot_base::slot_base(const slot_base& src)
: rep_(nullptr),
  blocked_(src.blocked_)
{
  if (src.rep_)
  {
    //Check call_ so we can ignore invalidated slots.
    //Otherwise, destroyed bound reference parameters (whose destruction caused the slot's invalidation) may be used during dup().
    //Note: I'd prefer to check somewhere during dup(). murrayc.
    if (src.rep_->call_)
      rep_ = src.rep_->dup();
    else
    {
      *this = slot_base(); //Return the default invalid slot.
    }
  }
}

slot_base::~slot_base()
{
  if (rep_)
    delete rep_;
}

slot_base::operator bool() const
{
  return rep_ != nullptr;
}

slot_base& slot_base::operator=(const slot_base& src)
{
  if (src.rep_ == rep_) return *this;

  if (src.empty())
  {
    if (rep_)
    {
      // Make sure we are notified if disconnect() deletes rep_, which is trackable.
      // Compare slot_rep::notify().
      destroy_notify_struct notifier;
      rep_->add_destroy_notify_callback(&notifier, destroy_notify_struct::notify);
      rep_->disconnect(); // Disconnect the slot (might lead to deletion of rep_!).

      // If rep_ has been deleted, don't try to delete it again.
      // If it has been deleted, this slot_base has probably also been deleted, so
      // don't clear the rep_ pointer. It's the responsibility of the code that
      // deletes rep_ to either clear the rep_ pointer or delete this slot_base.
      if (!notifier.deleted_)
      {
        rep_->remove_destroy_notify_callback(&notifier);
        delete rep_; // Detach the stored functor from the other referred trackables and destroy it.
        rep_ = nullptr;
      }
    }
    return *this;
  }

  auto new_rep_ = src.rep_->dup();

  if (rep_) // Silently exchange the slot_rep.
  {
    new_rep_->set_parent(rep_->parent_, rep_->cleanup_);
    delete rep_; // Calls destroy(), but does not call disconnect().
  }

  rep_ = new_rep_;

  return *this;
}

void slot_base::set_parent(void* parent, void* (*cleanup)(void*)) const
{
  if (rep_)
    rep_->set_parent(parent, cleanup);
}

void slot_base::add_destroy_notify_callback(void* data, func_destroy_notify func) const
{
  if (rep_)
    rep_->add_destroy_notify_callback(data, func);
}

void slot_base::remove_destroy_notify_callback(void* data) const
{
  if (rep_)
    rep_->remove_destroy_notify_callback(data);
}

bool slot_base::block(bool should_block)
{
  bool old = blocked_;
  blocked_ = should_block;
  return old;
}

bool slot_base::unblock()
{
  return block(false);
}

void slot_base::disconnect()
{
  if (rep_)
    rep_->disconnect();
}


/*bool slot_base::empty() const // having this function not inline is killing performance !!!
{
  if (rep_ && !rep_->call_)
    {
      delete rep_;        // This is not strictly necessary here. I'm convinced that it is
      rep_ = nullptr;           // safe to wait for the destructor to delete the slot_rep. Martin.
    }
  return (rep_ == nullptr);
}*/

} //namespace sigc
