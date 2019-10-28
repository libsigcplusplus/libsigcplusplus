/* Copyright 2002 - 2016, The gtkmm Development Team
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

// Bug 564005 - Valgrind errors and crash on exit with Gtk::UIManager
// Bug 154498 - Unnecessary warning on console: signalproxy_connectionnode.cc

// libsigc++-only test case. (Or almost so. RefPtr is stolen from glibmm.)

// This test case is much more useful if it's run under valgrind.

#include "testutilities.h"
#include <sigc++/sigc++.h>

#define ACTIVATE_BUG 1

#ifndef _GLIBMM_REFPTR_H
#define _GLIBMM_REFPTR_H

//#include <glibmmconfig.h>

namespace Glib
{

/** RefPtr<> is a reference-counting shared smartpointer.
 *
 * Some objects in gtkmm are obtained from a shared
 * store. Consequently you cannot instantiate them yourself. Instead they
 * return a RefPtr which behaves much like an ordinary pointer in that members
 * can be reached with the usual <code>object_ptr->member</code> notation.
 * Unlike most other smart pointers, RefPtr doesn't support dereferencing
 * through <code>*object_ptr</code>.
 *
 * Reference counting means that a shared reference count is incremented each
 * time a RefPtr is copied, and decremented each time a RefPtr is destroyed,
 * for instance when it leaves its scope. When the reference count reaches
 * zero, the contained object is deleted, meaning  you don't need to remember
 * to delete the object.
 *
 * RefPtr<> can store any class that has reference() and unreference() methods.
 * In gtkmm, that is anything derived from Glib::ObjectBase, such as
 * Gdk::Pixmap.
 *
 * See the "Memory Management" section in the "Programming with gtkmm"
 * book for further information.
 */
template<typename T_CppObject>
class RefPtr
{
public:
  /** Default constructor
   *
   * Afterwards it will be null and use of -> will cause a segmentation fault.
   */
  inline RefPtr();

  /// Destructor - decrements reference count.
  inline ~RefPtr();

  /// For use only by the ::create() methods.
  explicit inline RefPtr(T_CppObject* pCppObject);

  /** Copy constructor
   *
   * This increments the shared reference count.
   */
  inline RefPtr(const RefPtr<T_CppObject>& src);

  /** Copy constructor (from different, but castable type).
   *
   * Increments the reference count.
   */
  template<typename T_CastFrom>
  inline explicit RefPtr(const RefPtr<T_CastFrom>& src);

  /** Swap the contents of two RefPtr<>.
   * This method swaps the internal pointers to T_CppObject.  This can be
   * done safely without involving a reference/unreference cycle and is
   * therefore highly efficient.
   */
  inline void swap(RefPtr<T_CppObject>& other);

  /// Copy from another RefPtr:
  inline RefPtr<T_CppObject>& operator=(const RefPtr<T_CppObject>& src);

  /** Copy from different, but castable type).
   *
   * Increments the reference count.
   */
  template<typename T_CastFrom>
  inline RefPtr<T_CppObject>& operator=(const RefPtr<T_CastFrom>& src);

  /// Tests whether the RefPtr<> point to the same underlying instance.
  inline bool operator==(const RefPtr<T_CppObject>& src) const;

  /// See operator==().
  inline bool operator!=(const RefPtr<T_CppObject>& src) const;

  /** Dereferencing.
   *
   * Use the methods of the underlying instance like so:
   * <code>refptr->memberfun()</code>.
   */
  inline T_CppObject* operator->() const;

  /** Test whether the RefPtr<> points to any underlying instance.
   *
   * Mimics usage of ordinary pointers:
   * @code
   *   if (ptr)
   *     do_something();
   * @endcode
   */
  inline explicit operator bool() const;

#ifndef GLIBMM_DISABLE_DEPRECATED
  /// @deprecated Use reset() instead because this leads to confusion with clear() methods on the
  /// underlying class. For instance, people use .clear() when they mean ->clear().
  inline void clear();
#endif // GLIBMM_DISABLE_DEPRECATED

  /** Set underlying instance to 0, decrementing reference count of existing instance appropriately.
   * @newin{2,16}
   */
  inline void reset();

  /** Dynamic cast to derived class.
   *
   * The RefPtr can't be cast with the usual notation so instead you can use
   * @code
   *   ptr_derived = RefPtr<Derived>::cast_dynamic(ptr_base);
   * @endcode
   */
  template<typename T_CastFrom>
  static inline RefPtr<T_CppObject> cast_dynamic(const RefPtr<T_CastFrom>& src);

  /** Static cast to derived class.
   *
   * Like the dynamic cast; the notation is
   * @code
   *   ptr_derived = RefPtr<Derived>::cast_static(ptr_base);
   * @endcode
   */
  template<typename T_CastFrom>
  static inline RefPtr<T_CppObject> cast_static(const RefPtr<T_CastFrom>& src);

  /** Cast to non-const.
   *
   * The RefPtr can't be cast with the usual notation so instead you can use
   * @code
   *   ptr_unconst = RefPtr<UnConstType>::cast_const(ptr_const);
   * @endcode
   */
  template<typename T_CastFrom>
  static inline RefPtr<T_CppObject> cast_const(const RefPtr<T_CastFrom>& src);

  /** Compare based on the underlying instance address.
   *
   * This is needed in code that requires an ordering on
   * RefPtr<T_CppObject> instances, e.g. std::set<RefPtr<T_CppObject> >.
   *
   * Without these, comparing two RefPtr<T_CppObject> instances
   * is still syntactically possible, but the result is semantically
   * wrong, as p1 REL_OP p2 is interpreted as (bool)p1 REL_OP (bool)p2.
   */
  inline bool operator<(const RefPtr<T_CppObject>& src) const;

  /// See operator<().
  inline bool operator<=(const RefPtr<T_CppObject>& src) const;

  /// See operator<().
  inline bool operator>(const RefPtr<T_CppObject>& src) const;

  /// See operator<().
  inline bool operator>=(const RefPtr<T_CppObject>& src) const;

private:
  T_CppObject* pCppObject_;
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS

// RefPtr<>::operator->() comes first here since it's used by other methods.
// If it would come after them it wouldn't be inlined.

template<typename T_CppObject>
inline T_CppObject* RefPtr<T_CppObject>::operator->() const
{
  return pCppObject_;
}

template<typename T_CppObject>
inline RefPtr<T_CppObject>::RefPtr() : pCppObject_(nullptr)
{
}

template<typename T_CppObject>
inline RefPtr<T_CppObject>::~RefPtr()
{
  if (pCppObject_)
    pCppObject_->unreference(); // This could cause pCppObject to be deleted.
}

template<typename T_CppObject>
inline RefPtr<T_CppObject>::RefPtr(T_CppObject* pCppObject) : pCppObject_(pCppObject)
{
}

template<typename T_CppObject>
inline RefPtr<T_CppObject>::RefPtr(const RefPtr<T_CppObject>& src) : pCppObject_(src.pCppObject_)
{
  if (pCppObject_)
    pCppObject_->reference();
}

// The templated ctor allows copy construction from any object that's
// castable.  Thus, it does downcasts:
//   base_ref = derived_ref
template<typename T_CppObject>
template<typename T_CastFrom>
inline RefPtr<T_CppObject>::RefPtr(const RefPtr<T_CastFrom>& src)
: // A different RefPtr<> will not allow us access to pCppObject_.  We need
  // to add a get_underlying() for this, but that would encourage incorrect
  // use, so we use the less well-known operator->() accessor:
  pCppObject_(src.operator->())
{
  if (pCppObject_)
    pCppObject_->reference();
}

template<typename T_CppObject>
inline void
RefPtr<T_CppObject>::swap(RefPtr<T_CppObject>& other)
{
  const auto temp = pCppObject_;
  pCppObject_ = other.pCppObject_;
  other.pCppObject_ = temp;
}

template<typename T_CppObject>
inline RefPtr<T_CppObject>&
RefPtr<T_CppObject>::operator=(const RefPtr<T_CppObject>& src)
{
  // In case you haven't seen the swap() technique to implement copy
  // assignment before, here's what it does:
  //
  // 1) Create a temporary RefPtr<> instance via the copy ctor, thereby
  //    increasing the reference count of the source object.
  //
  // 2) Swap the internal object pointers of *this and the temporary
  //    RefPtr<>.  After this step, *this already contains the new pointer,
  //    and the old pointer is now managed by temp.
  //
  // 3) The destructor of temp is executed, thereby unreferencing the
  //    old object pointer.
  //
  // This technique is described in Herb Sutter's "Exceptional C++", and
  // has a number of advantages over conventional approaches:
  //
  // - Code reuse by calling the copy ctor.
  // - Strong exception safety for free.
  // - Self assignment is handled implicitely.
  // - Simplicity.
  // - It just works and is hard to get wrong; i.e. you can use it without
  //   even thinking about it to implement copy assignment whereever the
  //   object data is managed indirectly via a pointer, which is very common.

  RefPtr<T_CppObject> temp(src);
  this->swap(temp);
  return *this;
}

template<typename T_CppObject>
template<typename T_CastFrom>
inline RefPtr<T_CppObject>&
RefPtr<T_CppObject>::operator=(const RefPtr<T_CastFrom>& src)
{
  RefPtr<T_CppObject> temp(src);
  this->swap(temp);
  return *this;
}

template<typename T_CppObject>
inline bool
RefPtr<T_CppObject>::operator==(const RefPtr<T_CppObject>& src) const
{
  return (pCppObject_ == src.pCppObject_);
}

template<typename T_CppObject>
inline bool
RefPtr<T_CppObject>::operator!=(const RefPtr<T_CppObject>& src) const
{
  return (pCppObject_ != src.pCppObject_);
}

template<typename T_CppObject>
inline RefPtr<T_CppObject>::operator bool() const
{
  return (pCppObject_ != nullptr);
}

#ifndef GLIBMM_DISABLE_DEPRECATED
template<typename T_CppObject>
inline void
RefPtr<T_CppObject>::clear()
{
  reset();
}
#endif // GLIBMM_DISABLE_DEPRECATED

template<typename T_CppObject>
inline void
RefPtr<T_CppObject>::reset()
{
  RefPtr<T_CppObject> temp; // swap with an empty RefPtr<> to clear *this
  this->swap(temp);
}

template<typename T_CppObject>
template<typename T_CastFrom>
inline RefPtr<T_CppObject>
RefPtr<T_CppObject>::cast_dynamic(const RefPtr<T_CastFrom>& src)
{
  const auto pCppObject = dynamic_cast<T_CppObject*>(src.operator->());

  if (pCppObject)
    pCppObject->reference();

  return RefPtr<T_CppObject>(pCppObject);
}

template<typename T_CppObject>
template<typename T_CastFrom>
inline RefPtr<T_CppObject>
RefPtr<T_CppObject>::cast_static(const RefPtr<T_CastFrom>& src)
{
  const auto pCppObject = static_cast<T_CppObject*>(src.operator->());

  if (pCppObject)
    pCppObject->reference();

  return RefPtr<T_CppObject>(pCppObject);
}

template<typename T_CppObject>
template<typename T_CastFrom>
inline RefPtr<T_CppObject>
RefPtr<T_CppObject>::cast_const(const RefPtr<T_CastFrom>& src)
{
  const auto pCppObject = const_cast<T_CppObject*>(src.operator->());

  if (pCppObject)
    pCppObject->reference();

  return RefPtr<T_CppObject>(pCppObject);
}

template<typename T_CppObject>
inline bool
RefPtr<T_CppObject>::operator<(const RefPtr<T_CppObject>& src) const
{
  return (pCppObject_ < src.pCppObject_);
}

template<typename T_CppObject>
inline bool
RefPtr<T_CppObject>::operator<=(const RefPtr<T_CppObject>& src) const
{
  return (pCppObject_ <= src.pCppObject_);
}

template<typename T_CppObject>
inline bool
RefPtr<T_CppObject>::operator>(const RefPtr<T_CppObject>& src) const
{
  return (pCppObject_ > src.pCppObject_);
}

template<typename T_CppObject>
inline bool
RefPtr<T_CppObject>::operator>=(const RefPtr<T_CppObject>& src) const
{
  return (pCppObject_ >= src.pCppObject_);
}

#endif /* DOXYGEN_SHOULD_SKIP_THIS */

/** @relates Glib::RefPtr */
template<typename T_CppObject>
inline void
swap(RefPtr<T_CppObject>& lhs, RefPtr<T_CppObject>& rhs)
{
  lhs.swap(rhs);
}

} // namespace Glib

#endif /* _GLIBMM_REFPTR_H */

namespace
{
std::ostringstream result_stream;

class Action : public sigc::trackable
{
public:
  Action() : ref_count(1) {}

  void reference() { ++ref_count; }
  void unreference()
  {
    if (--ref_count <= 0)
      delete this;
  }

  void emit_sig1(int n) { sig1.emit(n); }

  sigc::signal<void(int)>& signal_sig1() { return sig1; }

private:
  sigc::signal<void(int)> sig1;
  int ref_count;
};

class Test : public sigc::trackable
{
public:
  Test() : action(new Action)
  {
    result_stream << "new Test; ";
#ifdef ACTIVATE_BUG // See https://bugzilla.gnome.org/show_bug.cgi?id=564005#c14
    action->signal_sig1().connect(sigc::bind(sigc::mem_fun(*this, &Test::on_sig1), action));
#else
    Glib::RefPtr<Action> action2(new Action);
    action->signal_sig1().connect(sigc::bind(sigc::mem_fun(*this, &Test::on_sig1), action2));
#endif
  }

  ~Test() { result_stream << "delete Test; "; }

  void on_sig1(int n, Glib::RefPtr<Action> /* action */)
  {
    result_stream << "Test::on_sig1, n=" << n << "; ";
  }

  Glib::RefPtr<Action> action;

}; // end Test

} // end anonymous namespace

int
main(int argc, char* argv[])
{
  auto util = TestUtilities::get_instance();

  if (!util->check_command_args(argc, argv))
    return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;

  auto test = new Test;

  test->action->emit_sig1(23);
  delete test;
  util->check_result(result_stream, "new Test; Test::on_sig1, n=23; delete Test; ");

  return util->get_result_and_delete_instance() ? EXIT_SUCCESS : EXIT_FAILURE;
}
