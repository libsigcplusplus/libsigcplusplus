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

struct trackable_dependency
{
  void* obj_;
  void* (*func_)(void*);
  trackable_dependency(void* o, void* (*f)(void*))
    : obj_(o), func_(f) {}
};

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

class trackable
{
  public:
    trackable() {}

    trackable(const trackable& t) {}

    trackable& operator=(const trackable& t)
      {
        dep_list_.clear();
        return *this;
      }

    /*virtual ~trackable() {} */  /* we would need a virtual dtor for users
                                     who insist on using "trackable*" as
                                     pointer type for their own derived objects */

    void add_dependency(void* o, void* (f)(void*)) const
      { dep_list_.add_dependency(o,f); }
    void remove_dependency(void* o) const
      { dep_list_.remove_dependency(o); }

  private:
    mutable internal::trackable_dep_list dep_list_;
};

} /* namespace sigc */

#endif /* _SIGC_TRACKABLE_HPP_ */
