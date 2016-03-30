#ifndef _SIGC_ADAPTORS_ADAPTOR_TRAIT_H_
#define _SIGC_ADAPTORS_ADAPTOR_TRAIT_H_
#include <sigc++config.h> //To get SIGC_TEMPLATE_KEYWORD_OPERATOR_OVERLOAD
#include <sigc++/visit_each.h>
#include <sigc++/functors/functor_trait.h>
#include <sigc++/functors/ptr_fun.h>
#include <sigc++/functors/mem_fun.h>
#include <sigc++/adaptors/adaptor_base.h>

/*
 * The idea here is simple.  To prevent the need to
 * specializing every adaptor for every type of functor
 * and worse non-functors like function pointers, we
 * will make an adaptor trait which can take ordinary
 * functors and make them adaptor functors for which
 * we will of course be able to avoid excess copies.
 * (in theory)
 *
 * this all depends on partial specialization to allow
 * us to do
 *   functor_.template operator() <types> (args);
 *
 *
 * I don't understand much of the above. However, I can
 * see that adaptors are implemented like they are because
 * there is no way to extract the return type and the argument
 * types from a functor type. Therefore, operator() is templated.
 * It's instatiated in slot_call#<>::operator() where the
 * argument types are known. The return type is finally determined
 * via the callof<> template - a tricky way to detect the return
 * type of a functor when the argument types are known. Martin.
 */

namespace sigc
{

#ifndef DOXYGEN_SHOULD_SKIP_THIS
template <class T_functor>
struct adapts;
#endif

/** @defgroup adaptors Adaptors
 * Adaptors are functors that alter the signature of a functor's
 * operator()().
 *
 * The adaptor types libsigc++ provides
 * are created with bind(), bind_return(), hide(), hide_return(),
 * retype_return(), retype(), compose(), exception_catch(), track_obj()
 * and group().
 *
 * You can easily derive your own adaptor type from sigc::adapts.
 */

/** Converts an arbitrary functor into an adaptor type.
 * All adaptor types in libsigc++ have
 * a <tt>template operator()</tt> member of every argument count
 * they support. These functions in turn invoke a stored adaptor's
 * <tt>template operator()</tt>, processing the arguments and return
 * value in a characteristic manner. Explicit function template
 * instantiation is used to pass type hints thus saving copy costs.
 *
 * adaptor_functor is a glue between adaptors and arbitrary functors
 * that just passes on the arguments. You won't use this type directly.
 *
 * The template argument @e T_functor determines the type of stored
 * functor.
 *
 * @ingroup adaptors
 */
template <class T_functor>
struct adaptor_functor : public adaptor_base
{
  using result_type = typename functor_trait<T_functor>::result_type;

  /** Invokes the wrapped functor passing on the arguments.
   * @return The return value of the functor invocation.
   */
  decltype(auto) operator()() const { return functor_(); }

  /** Invokes the wrapped functor passing on the arguments.
   * @param _A_arg... Arguments to be passed on to the functor.
   * @return The return value of the functor invocation.
   */
  template <class... T_arg>
  decltype(auto) operator()(T_arg&&... _A_arg) const
  {
    return functor_(std::forward<T_arg>(_A_arg)...);
  }

  /// Constructs an invalid functor.
  adaptor_functor() {}

  /** Constructs an adaptor_functor object that wraps the passed functor.
   * @param _A_functor Functor to invoke from operator()().
   */
  explicit adaptor_functor(const T_functor& _A_functor) : functor_(_A_functor) {}

  /** Constructs an adaptor_functor object that wraps the passed (member)
   * function pointer.
   * @param _A_type Pointer to function or class method to invoke from operator()().
   */
  template <class T_type>
  explicit adaptor_functor(const T_type& _A_type) : functor_(_A_type)
  {
  }

  /// Functor that is invoked from operator()().
  mutable T_functor functor_;
};

#ifndef DOXYGEN_SHOULD_SKIP_THIS
// template specialization of visitor<>::do_visit_each<>(action, functor):
/** Performs a functor on each of the targets of a functor.
 * The function overload for sigc::adaptor_functor performs a functor
 * on the functor stored in the sigc::adaptor_functor object.
 *
 * @ingroup adaptors
 */
template <class T_functor>
struct visitor<adaptor_functor<T_functor>>
{
  template <class T_action>
  static void do_visit_each(const T_action& _A_action, const adaptor_functor<T_functor>& _A_target)
  {
    sigc::visit_each(_A_action, _A_target.functor_);
  }
};
#endif // DOXYGEN_SHOULD_SKIP_THIS

/** Trait that specifies what is the adaptor version of a functor type.
 * Template specializations for sigc::adaptor_base derived functors,
 * for function pointers and for class methods are provided.
 *
 * The template argument @e T_functor is the functor type to convert.
 * @e I_isadaptor indicates whether @e T_functor inherits from sigc::adaptor_base.
 *
 * @ingroup adaptors
 */
#ifndef DOXYGEN_SHOULD_SKIP_THIS
template <class T_functor, bool I_isadaptor = std::is_base_of<adaptor_base, T_functor>::value>
struct adaptor_trait;
#else
template <class T_functor, bool I_isadaptor = std::is_base_of<adaptor_base, T_functor>::value>
struct adaptor_trait
{
};
#endif

/** Trait that specifies what is the adaptor version of a functor type.
 * This template specialization is used for types that inherit from adaptor_base.
 * adaptor_type is equal to @p T_functor in this case.
 */
template <class T_functor>
struct adaptor_trait<T_functor, true>
{
  using result_type = typename T_functor::result_type;
  using functor_type = T_functor;
  using adaptor_type = T_functor;
};

/** Trait that specifies what is the adaptor version of a functor type.
 * This template specialization is used for arbitrary functors,
 * for function pointers and for class methods are provided.
 * The latter are converted into @p pointer_functor or @p mem_functor types.
 * adaptor_type is equal to @p adaptor_functor<functor_type>.
 */
template <class T_functor>
struct adaptor_trait<T_functor, false>
{
  using result_type = typename functor_trait<T_functor>::result_type;
  using functor_type = typename functor_trait<T_functor>::functor_type;
  using adaptor_type = adaptor_functor<functor_type>;
};

// Doxygen (at least version 1.8.4) removes blank lines in a code block.
// That's why there are empty comment lines in the following code block.
/** Base type for adaptors.
 * sigc::adapts wraps adaptors, functors, function pointers and class methods.
 * It contains a single member functor which is always a sigc::adaptor_base.
 * The adaptor_type alias defines the exact type that is used
 * to store the adaptor, functor, function pointer or class method passed
 * into the constructor. It differs from @a T_functor unless @a T_functor
 * inherits from sigc::adaptor_base.
 *
 * @par Example of a simple adaptor:
 * @code
 * namespace my_ns
 * {
 * template <class T_functor>
 * struct my_adaptor : public sigc::adapts<T_functor>
 * {
 *   using result_type = typename sigc::functor_trait<T_functor>::result_type;
 *   //
 *   result_type
 *   operator()() const;
 *   //
 *   template <class T_arg1>
 *   decltype(auto)
 *   operator()(T_arg1 _A_arg1) const;
 *   //
 *   template <class T_arg1, class T_arg2>
 *   decltype(auto)
 *   operator()(T_arg1 _A_arg1, T_arg2 _A_arg2) const;
 *   //
 *   // Constructs a my_adaptor object that wraps the passed functor.
 *   // Initializes adapts<T_functor>::functor_, which is invoked from operator()().
 *   explicit my_adaptor(const T_functor& _A_functor)
 *     : sigc::adapts<T_functor>(_A_functor) {}
 * };
 * } // end namespace my_ns
 * //
 * // Specialization of sigc::visitor for my_adaptor.
 * namespace sigc
 * {
 * template <class T_functor>
 * struct visitor<my_ns::my_adaptor<T_functor> >
 * {
 *   template <class T_action>
 *   static void do_visit_each(const T_action& _A_action,
 *                             const my_ns::my_adaptor<T_functor>& _A_target)
 *   {
 *     sigc::visit_each(_A_action, _A_target.functor_);
 *   }
 * };
 * } // end namespace sigc
 * @endcode
 *
 * If you implement your own adaptor, you must also provide your specialization
 * of sigc::visitor<>::do_visit_each<>() that will forward the call to the functor(s)
 * your adapter is wrapping. Otherwise, pointers stored within the functor won't be
 * invalidated when a sigc::trackable object is destroyed and you can end up
 * executing callbacks on destroyed objects.
 *
 * Your specialization of sigc::visitor<> must be in namespace sigc.
 *
 * @ingroup adaptors
 */
template <class T_functor>
struct adapts : public adaptor_base
{
  using result_type = typename adaptor_trait<T_functor>::result_type;
  using adaptor_type = typename adaptor_trait<T_functor>::adaptor_type;

  /** Constructs an adaptor that wraps the passed functor.
   * @param _A_functor Functor to invoke from operator()().
   */
  explicit adapts(const T_functor& _A_functor) : functor_(_A_functor) {}

  /// Adaptor that is invoked from operator()().
  mutable adaptor_type functor_;
};

} /* namespace sigc */
#endif /* _SIGC_ADAPTORS_ADAPTOR_TRAIT_H_ */
