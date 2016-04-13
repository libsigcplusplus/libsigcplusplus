#ifndef _SIGC_ADAPTORS_EXCEPTION_CATCH_H_
#define _SIGC_ADAPTORS_EXCEPTION_CATCH_H_
#include <sigc++/adaptors/adapts.h>

namespace sigc
{

/*
   functor adaptor:  exception_catch(functor, catcher)

   usage:


   Future directions:
     The catcher should be told what type of return it needs to
   return for multiple type functors,  to do this the user
   will need to derive from catcher_base.
*/
/** @defgroup exception_catch exception_catch()
 * sigc::exception_catch() catches an exception thrown from within
 * the wrapped functor and directs it to a catcher functor.
 * This catcher can then rethrow the exception and catch it with the proper type.
 *
 * Note that the catcher is expected to return the same type
 * as the wrapped functor so that normal flow can continue.
 *
 * Catchers can be cascaded to catch multiple types, because uncaught
 * rethrown exceptions proceed to the next catcher adaptor.
 *
 * @par Examples:
 * @code
 * struct my_catch
 * {
 *   int operator()()
 *   {
 *     try { throw; }
 *     catch (std::range_error e) // catch what types we know
 *       { std::cerr << "caught " << e.what() << std::endl; }
 *     return 1;
 *   }
 * }
 * int foo(); // throws std::range_error
 * sigc::exception_catch(&foo, my_catch())();
 * @endcode
 *
 * The functor sigc::exception_catch() returns can be directly passed into
 * sigc::signal::connect().
 *
 * @par Example:
 * @code
 * sigc::signal<int()> some_signal;
 * some_signal.connect(sigc::exception_catch(&foo, my_catch));
 * @endcode
 *
 * @ingroup adaptors
 */

template <class T_functor, class T_catcher,
  class T_return = typename adapts<T_functor>::result_type>
struct exception_catch_functor : public adapts<T_functor>
{
public:
  using result_type = T_return;

  decltype(auto) operator()()
  {
    try
    {
      return this->functor_();
    }
    catch (...)
    {
      return catcher_();
    }
  }

  template <class... T_arg>
  decltype(auto) operator()(T_arg... _A_a)
  {
    try
    {
      return this->functor_.template operator()<type_trait_pass_t<T_arg>...>(_A_a...);
    }
    catch (...)
    {
      return catcher_();
    }
  }

  exception_catch_functor(const T_functor& _A_func, const T_catcher& _A_catcher)
  : adapts<T_functor>(_A_func), catcher_(_A_catcher)
  {
  }

  T_catcher catcher_;
};

// void specialization
template <class T_functor, class T_catcher>
struct exception_catch_functor<T_functor, T_catcher, void> : public adapts<T_functor>
{
public:
  using result_type = void;


  template <class... T_arg>
  decltype(auto) operator()(T_arg... _A_a)
  {
    try
    {
      return this->functor_.template operator()<type_trait_pass_t<T_arg>...>(_A_a...);
    }
    catch (...)
    {
      return catcher_();
    }
  }

  exception_catch_functor() = default;
  exception_catch_functor(const T_functor& _A_func, const T_catcher& _A_catcher)
  : adapts<T_functor>(_A_func), catcher_(_A_catcher)
  {
  }
  ~exception_catch_functor() = default;

  T_catcher catcher_;
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS
// template specialization of visitor<>::do_visit_each<>(action, functor):
template <class T_functor, class T_catcher, class T_return>
struct visitor<exception_catch_functor<T_functor, T_catcher, T_return>>
{
  template <typename T_action>
  static void do_visit_each(const T_action& _A_action,
    const exception_catch_functor<T_functor, T_catcher, T_return>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
    sigc::visit_each(_A_action, _A_target.catcher_);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

template <class T_functor, class T_catcher>
inline decltype(auto)
exception_catch(const T_functor& _A_func, const T_catcher& _A_catcher)
{
  return exception_catch_functor<T_functor, T_catcher>(_A_func, _A_catcher);
}

} /* namespace sigc */
#endif /* _SIGC_ADAPTORS_EXCEPTION_CATCH_H_ */
