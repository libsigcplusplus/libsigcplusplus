dnl Copyright 2002, The libsigc++ Development Team 
dnl 
dnl This library is free software; you can redistribute it and/or 
dnl modify it under the terms of the GNU Lesser General Public 
dnl License as published by the Free Software Foundation; either 
dnl version 2.1 of the License, or (at your option) any later version. 
dnl 
dnl This library is distributed in the hope that it will be useful, 
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of 
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
dnl Lesser General Public License for more details. 
dnl 
dnl You should have received a copy of the GNU Lesser General Public 
dnl License along with this library; if not, write to the Free Software 
dnl Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
dnl
divert(-1)

include(template.macros.m4)

define([BIND_RETURN_OPERATOR],[dnl
   template <LOOP(class T_arg%1, $1)>
   inline T_return operator()(LOOP(T_arg%1 _A_a%1, $1))
     { functor_.template operator()<LOOP(_P_(T_arg%1), $1)>
        (LOOP(_A_a%1, $1)); return ret_value_; 
     }
])

divert(0)dnl
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc {
namespace functor {

template <class T_return, class T_functor>
class bind_return_functor : public adapts<T_functor>
{
  public:
    typedef T_return result_type;
    T_return operator()();

FOR(1,CALL_SIZE,[[BIND_RETURN_OPERATOR(%1)]])

    bind_return_functor() {}
    bind_return_functor(_R_(T_functor) _A_functor, _R_(T_return) _A_ret_value)
      : adapts<T_functor>(_A_functor), ret_value_(_A_ret_value)
    {}
  protected: 
    T_return ret_value_; 
};

template <class T_return, class T_functor>
T_return bind_return_functor<T_return, T_functor>::operator()()
  { functor_(); return ret_value_; }

template <class T_action, class T_return, class T_functor>
void visit_each(const T_action& _A_action,
                const bind_return_functor<T_return, T_functor>& _A_target)
{
  visit_each(_A_action, _A_target.ret_value_);
  visit_each(_A_action, _A_target.functor_);
}

template <class T_return, class T_functor>
inline bind_return_functor<T_return, T_functor>
bind_return(const T_functor& _A_functor, T_return _A_ret_value)
  { return bind_return_functor<T_return, T_functor>(_A_functor, _A_ret_value); }

} /* namespace functor */
} /* namespace sigc */

