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
#ifndef _SIGC_TRACKABLE_HPP_
#define _SIGC_TRACKABLE_HPP_
#include <list>

namespace sigc {

class trackable;

namespace internal {

/** Representative of a dependency.
 * A dependency consists of a pointer and a callback. This callback is
 * executed from the dependency list (of type trackable_dep_list) that
 * holds the dependency when its parent object (of type trackable) is
 * destroyed or overwritten.
 */
struct trackable_dependency
{
  void* obj_;
  void* (*func_)(void*);
  trackable_dependency(void* o, void* (*f)(void*))
    : obj_(o), func_(f) {}
};

/** Dependency list.
 * A dependency list has an stl list of dependencies of type
 * trackable_dependency. Dependencies can be added and removed from the
 * list with the member functions add_dependency(), remove_dependency()
 * and clear(). The dependencies' callbacks are executed from clear()
 * and from the destructor.
 */
class trackable_dep_list
{
    typedef std::list<trackable_dependency> dep_list;
  public: 

    void add_dependency(void* target, void* (*func)(void*) );
    void remove_dependency(void* target);
    void clear();

    trackable_dep_list()
      : clearing_(false) {}

    ~trackable_dep_list();

  private:
    dep_list    deps_;
    bool        clearing_;
};

} /* namespace internal */

/** Base class for objects with auto-disconnection.
 * trackable is the class that must be inherited when objects shall
 * automatically invalidate slots that depend on them on destruction.
 * slots which are built from member functions of a class inheriting
 * trackable add a dependency to the object thus installing a callback
 * notifying them when the object is destroyed or overwritten.
 * add_dependency() and remove_dependency() are part of the public API
 * so that it can also be used at any place notification of the object
 * dying is needed.
 * The dependencies are hold in a dependency list of type
 * trackable_dep_list. This list is allocated dynamically when the
 * first dependency is added.
 * Note that there is no virtual destructor. Therefore it would be
 * unwise to use "trackable*" as pointer type for storing derived
 * objects if their destructor should be called or if they have
 * virtual functions.
 */
class trackable
{
  public:
    trackable() : dep_list_(0) {}

    trackable(const trackable& t)
      : dep_list_(0) {}

    trackable& operator=(const trackable& t)
      {
        if (dep_list_) dep_list_->clear();
        return *this;
      }

    ~trackable()
      { if (dep_list_) delete dep_list_; }

    /*virtual ~trackable() {} */  /* we would need a virtual dtor for users
                                     who insist on using "trackable*" as
                                     pointer type for their own derived objects */

    void add_dependency(void* o, void* (f)(void*)) const
      { dep_list()->add_dependency(o, f); }
    void remove_dependency(void* o) const
      { dep_list()->remove_dependency(o); }

  private:
    internal::trackable_dep_list* dep_list() const;
    mutable internal::trackable_dep_list* dep_list_;
};

} /* namespace sigc */

#endif /* _SIGC_TRACKABLE_HPP_ */
