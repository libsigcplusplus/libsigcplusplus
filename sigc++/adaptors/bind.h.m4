dnl Copyright 2002, Karl Einar Nelson 
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

define([BIND_FUNCTOR],[dnl
template <class T_bound, class T_functor>
struct bind_functor <$1,T_bound,T_functor> : public adapts<T_functor>
{
  typedef typename adapts<T_functor>::adaptor_type adaptor_type;

FOR($1,CALL_SIZE,[[BIND_OPERATOR($1,%1)]])
  bind_functor(_R_(T_functor) _A_func,_R_(T_bound) _A_bound)
    : adapts<T_functor>(_A_func), bound_(_A_bound)
    {}

  T_bound bound_;
};

])
define([BIND_OPERATOR],
[ifelse($2,0,[],$2,1,[dnl
  void 
  operator()()
    { functor_.template operator()<_P_(T_bound)>
       (bound_); 
    }
],$1,0,[dnl
  template <LOOP([class T_arg%1],eval($2-1))>
  typename callof<LIST(adaptor_type,LOOP(T_arg%1,eval($2-1)),T_bound)>::result_type
  operator()(LOOP(T_arg%1 _A_arg%1,eval($2-1)))
    { functor_.template operator()<LIST(LOOP([_P_(T_arg%1)],eval($2-1)),_P_(T_bound))>
       (LIST(LOOP(_A_arg%1,eval($2-1)),bound_)); 
    }
],[dnl
  template <LOOP([class T_arg%1],eval($2-1))>
  typename callof<LIST(adaptor_type,LOOP(T_arg%1,eval($1-1)),T_bound,FOR($1,eval($2-1),[T_arg%1,]))>::result_type
  operator()(LOOP(T_arg%1 _A_arg%1,eval($2-1)))
    { return functor_.template operator()<LIST(LOOP([_P_(T_arg%1)],eval($1-1)),_P_(T_bound),FOR($1,eval($2-1),[_P_(T_arg%1),]))>
      (LIST(LOOP(_A_arg%1,eval($1-1)),bound_,FOR($1,eval($2-1),[_A_arg%1,]))); 
    }
])dnl
])

divert(0)dnl
/*
  functor adaptor:  bind<#>(functor, argument1, ...)
  usage:
    This converter takes a functor and binds arguments to specific
  values.  The parameter number to bind is specified by non-optional
  integer argument.  The types of the arguments can optionally be 
  specified if not deduced.  A value of 0 binds the last parameter
  to the value.  This is convient for covering up optional values
  which have become exposed.  It can take up to 3 parameters to be
  bound.

    void foo (int,int,int);
    bind<0>(&foo,1,2)(3) -> calls foo(3,1,2);
    bind<1>(&foo,1,2)(3) -> calls foo(1,2,3);

  For a more powerful version of this functionality see the 
  lamda library "call" adaptor which can bind hide and reorder
  arguments arbitrarily.  Although lambda call is more flexible,
  bind provides a means of binding parameters when then total
  number of parameters called is variable.

*/
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc { 
namespace functor {

template <int I_location,class T_type, class T_functor>
class bind_functor;

FOR(0,CALL_SIZE,[[BIND_FUNCTOR(%1)]])

template <class T_action, int T_loc, class T_bound, class T_functor>
void visit_each(const T_action& _A_action,
                const bind_functor<T_loc,T_bound,T_functor>& _A_target)
{
  visit_each(_A_action,_A_target.functor_);
  visit_each(_A_action,_A_target.bound_);
}


// lets limit this to 3 deep for now
template <int I_location,class T_bound1,class T_functor>
inline bind_functor<I_location,T_bound1,T_functor>
bind(const T_functor& _A_func,T_bound1 _A_b1)
  { 
    return bind_functor<I_location,T_bound1,T_functor>
             (_A_func,_A_b1);
  }

template <int I_location,class T_bound1,class T_bound2,class T_functor>
inline bind_functor<I_location,T_bound1,
       bind_functor<I_location+1?I_location+1:0,T_bound2,T_functor> >
bind(const T_functor& _A_functor,T_bound1 _A_b1,T_bound2 _A_b2)
  { 
    return bind_functor<I_location,T_bound1,
           bind_functor<I_location?I_location+1:0,T_bound2,T_functor> >
             (bind<I_location?I_location+1:0>(_A_functor,_A_b2),_A_b1); 
  }

template <int I_location,class T_bound1,class T_bound2,class T_bound3,class T_functor>
inline bind_functor<I_location,T_bound1,
       bind_functor<I_location?I_location+1:0,T_bound2,
       bind_functor<I_location?I_location+2:0,T_bound3,T_functor> > >
bind(const T_functor& _A_functor,T_bound1 _A_b1,T_bound2 _A_b2,T_bound3 _A_b3)
  { 
    return bind_functor<I_location,T_bound1,
           bind_functor<I_location?I_location+1:0,T_bound2,
           bind_functor<I_location?I_location+2:0,T_bound3,T_functor> > >
             (bind<I_location?I_location+1:0>(_A_functor,_A_b2,_A_b3),_A_b1); 
  }


} /* namespace functor */
} /* namespace sigc */

