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

define([EXCEPTION_CATCH_OPERATOR],[dnl
   template <LOOP(class T_arg%1,$1)>
   inline typename callof<T_functor,LOOP(T_arg%1,$1)>::result_type
     operator()(LOOP(T_arg%1 _A_a%1,$1))
     { 
        try { 
          return functor_.template operator() <LOOP(_P_(T_arg%1),$1)>
            (LOOP(_A_a%1,$1));
        } 
        catch (...)
        { return catcher_(); }
     }

])

divert(0)dnl
/*
   functor adaptor:  exception_catch(functor,catcher)

   usage:
     Allows the user to catch an exception thrown from within 
   a functor and direct it to a catcher functor.  This catcher
   can then rethrow the exception and catch it with the proper
   type.  Note that the catcher is expected to return the
   same type as functor was expected to throw so that normal
   flow can continue.  Catchers can be cascaded to catch multiple
   types because uncaught rethrown exceptions proceed to the 
   next catcher adaptor.

     struct my_catch
       {
         int operator()()
          {
            try { throw; }
            catch (std::range_error e) // catch what types we know
              { cerr << "caught "<< e.what() <<endl; }
            return 1;
          }
       }
     int foo(); // throws std::range_error
     exception_catch(&foo,my_catch()) ();

   Future directions:
     The catcher should be told what type of return it needs to
   return for multiple type functors,  to do this the user
   will need to derive from catcher_base.
*/
__FIREWALL__
#include <sigc++/adaptors/adaptor_trait.h>

namespace sigc {
namespace functor {

template <class T_functor,class T_catcher>
class exception_catch_functor : public adapts<T_functor>
{
  public:
dnl   callof0_safe<T_functor>::result_type
dnl   operator()();

FOR(1,CALL_SIZE,[[EXCEPTION_CATCH_OPERATOR(%1)]])

    exception_catch_functor() {}
    exception_catch_functor(const T_functor& _A_func,
                            const T_catcher& _A_catcher)
      : adapts<T_functor>(_A_func), catcher_(_A_catcher)
    {}
    ~exception_catch_functor() {}
  protected: 
    T_catcher catcher_; 

};

dnl template <class T_functor,class T_catcher>
dnl typename callof0_safe<T_functor>::result_type
dnl exception_catch_functor<T_functor,T_catcher>
dnl   ::operator()()
dnl      { 
dnl         try { return functor_(); }
dnl         catch (...)
dnl         { return catcher_(); }
dnl      }

template <class T_action, class T_functor, class T_catcher>
void visit_each(const T_action& _A_action,
                const exception_catch_functor<T_functor,T_catcher>& _A_target)
{
  visit_each(_A_action,_A_target.functor_);
  visit_each(_A_action,_A_target.catcher_);
}


template <class T_functor,class T_catcher>
inline exception_catch_functor<T_functor,T_catcher>
exception_catch(const T_functor& _A_func,const T_catcher& _A_catcher)
  { return exception_catch_functor<T_functor,T_catcher>(_A_func,_A_catcher); }

} /* namespace functor */
} /* namespace sigc */
