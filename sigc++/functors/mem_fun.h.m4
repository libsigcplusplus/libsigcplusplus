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

define([MEMBER_FUNCTOR],[dnl
/** mem_functor$1 wraps methods with $1 arguments.
 * Use the convenience function mem_fun() to create an instance of mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class mem_functor$1 : public functor_base
{
public:
  typedef T_return (T_obj::*function_type)(LOOP(T_arg%1, $1));
  typedef T_return result_type;

  /// Constructs an invalid functor.
  mem_functor$1() {}

  /** Constructs a mem_functor$1 object that wraps the passed method.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit mem_functor$1(function_type _A_func): func_ptr_(_A_func) {}

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Pointer to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(T_obj* _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj->*func_ptr_)(LOOP(_A_a%1, $1)); }

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Reference to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(T_obj& _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj.*func_ptr_)(LOOP(_A_a%1, $1)); }

protected:
  function_type func_ptr_;
};

/** const_mem_functor$1 wraps const methods with $1 arguments.
 * Use the convenience function mem_fun() to create an instance of const_mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class const_mem_functor$1 : public functor_base
{
public:
  typedef T_return (T_obj::*function_type)(LOOP(T_arg%1, $1)) const;
  typedef T_return result_type;

  /// Constructs an invalid functor.
  const_mem_functor$1() {}

  /** Constructs a const_mem_functor$1 object that wraps the passed method.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit const_mem_functor$1(function_type _A_func): func_ptr_(_A_func) {}

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Pointer to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(const T_obj* _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj->*func_ptr_)(LOOP(_A_a%1, $1)); }

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Reference to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(const T_obj& _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj.*func_ptr_)(LOOP(_A_a%1, $1)); }

protected:
  function_type func_ptr_;
};

/** volatile_mem_functor$1 wraps volatile methods with $1 arguments.
 * Use the convenience function mem_fun() to create an instance of volatile_mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class volatile_mem_functor$1 : public functor_base
{
public:
  typedef T_return (T_obj::*function_type)(LOOP(T_arg%1, $1)) volatile;
  typedef T_return result_type;

  /// Constructs an invalid functor.
  volatile_mem_functor$1() {}

  /** Constructs a volatile_mem_functor$1 object that wraps the passed method.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit volatile_mem_functor$1(function_type _A_func): func_ptr_(_A_func) {}

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Pointer to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(T_obj* _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj->*func_ptr_)(LOOP(_A_a%1, $1)); }

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Reference to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(T_obj& _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj.*func_ptr_)(LOOP(_A_a%1, $1)); }

protected:
  function_type func_ptr_;
};

/** const_volatile_mem_functor$1 wraps const volatile methods with $1 arguments.
 * Use the convenience function mem_fun() to create an instance of const_volatile_mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class const_volatile_mem_functor$1 : public functor_base
{
public:
  typedef T_return (T_obj::*function_type)(LOOP(T_arg%1, $1)) const volatile;
  typedef T_return result_type;

  /// Constructs an invalid functor.
  const_volatile_mem_functor$1() {}

  /** Constructs a const_volatile_mem_functor$1 object that wraps the passed method.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit const_volatile_mem_functor$1(function_type _A_func): func_ptr_(_A_func) {}

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Pointer to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(const T_obj* _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj->*func_ptr_)(LOOP(_A_a%1, $1)); }

  /** Execute the wrapped method operating on the passed instance.
   * @param _A_obj Reference to instance the method should operate on.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LIST(const T_obj& _A_obj, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1))) const
    { return (_A_obj.*func_ptr_)(LOOP(_A_a%1, $1)); }

protected:
  function_type func_ptr_;
};

/** bound_mem_functor$1 encapsulates a method with $1 arguments and an object instance.
 * Use the convenience function mem_fun() to create an instance of bound_mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class bound_mem_functor$1 
  : public mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
{
  typedef mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> base_type_;
public:
  typedef typename base_type_::function_type function_type;

  /** Constructs a bound_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Pointer to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_mem_functor$1(T_obj* _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(_A_obj) {}

  /** Constructs a bound_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Reference to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_mem_functor$1(T_obj& _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(&_A_obj) {}

  /** Execute the wrapped method operating on the stored instance.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
    { return (obj_ptr_->*func_ptr_)(LOOP(_A_a%1, $1)); }

//protected:
  /// Pointer to stored object instance.
  T_obj *obj_ptr_;
};

/** bound_const_mem_functor$1 encapsulates a const method with $1 arguments and an object instance.
 * Use the convenience function mem_fun() to create an instance of bound_const_mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class bound_const_mem_functor$1 
  : public const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
{
  typedef const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> base_type_;
public:
  typedef typename base_type_::function_type function_type;

  /** Constructs a bound_const_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Pointer to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_const_mem_functor$1(const T_obj* _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(_A_obj) {}

  /** Constructs a bound_const_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Reference to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_const_mem_functor$1(const T_obj& _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(&_A_obj) {}

  /** Execute the wrapped method operating on the stored instance.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
    { return (obj_ptr_->*func_ptr_)(LOOP(_A_a%1, $1)); }

//protected:
  /// Pointer to stored object instance.
  const T_obj *obj_ptr_;
};

/** bound_volatile_mem_functor$1 encapsulates a volatile method with $1 arguments and an object instance.
 * Use the convenience function mem_fun() to create an instance of bound_volatile_mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class bound_volatile_mem_functor$1
  : public volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
{
  typedef volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> base_type_;
public:
  typedef typename base_type_::function_type function_type;

  /** Constructs a bound_volatile_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Pointer to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_volatile_mem_functor$1(T_obj* _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(_A_obj) {}

  /** Constructs a bound_volatile_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Reference to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_volatile_mem_functor$1(T_obj& _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(&_A_obj) {}

  /** Execute the wrapped method operating on the stored instance.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
    { return (obj_ptr_->*func_ptr_)(LOOP(_A_a%1, $1)); }

//protected:
  /// Pointer to stored object instance.
  T_obj *obj_ptr_;
};

/** bound_const_volatile_mem_functor$1 encapsulates a const volatile method with $1 arguments and an object instance.
 * Use the convenience function mem_fun() to create an instance of bound_const_volatile_mem_functor$1.
 *
 * The following template arguments are used:dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of operator()().])
 * - @e T_return The return type of operator()().
 * - @e T_obj The object type.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
class bound_const_volatile_mem_functor$1
  : public const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
{
  typedef const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)> base_type_;
public:
  typedef typename base_type_::function_type function_type;

  /** Constructs a bound_const_volatile_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Pointer to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_const_volatile_mem_functor$1(const T_obj* _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(_A_obj) {}

  /** Constructs a bound_const_volatile_mem_functor$1 object that wraps the passed method.
   * @param _A_obj Reference to instance the method will operate on.
   * @param _A_func Pointer to method will be invoked from operator()().
   */
  explicit bound_const_volatile_mem_functor$1(const T_obj& _A_obj, function_type _A_func)
    : base_type_(_A_func), obj_ptr_(&_A_obj) {}

  /** Execute the wrapped method operating on the stored instance.dnl
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the method.])
   * @return The return value of the method invocation.
   */
  T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const 
    { return (obj_ptr_->*func_ptr_)(LOOP(_A_a%1, $1)); }

//protected:
  /// Pointer to stored object instance.
  const T_obj *obj_ptr_;
};

/** Performs a functor on each of the targets of a functor.
 * The function overload for bound_mem_functor performs a functor
 * on the object instance stored in the bound_mem_functor object.
 *
 * @ingroup functors
 */
template <class T_action, LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
void visit_each(const T_action& _A_action,
                const bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>& _A_target)
{
  visit_each(_A_action, _A_target.obj_ptr_);
}

/** Performs a functor on each of the targets of a functor.
 * The function overload for bound_const_mem_functor performs a functor
 * on the object instance stored in the bound_const_mem_functor object.
 *
 * @ingroup functors
 */
template <class T_action, LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
void visit_each(const T_action& _A_action,
                const bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>& _A_target)
{
  visit_each(_A_action, _A_target.obj_ptr_);
}

/** Performs a functor on each of the targets of a functor.
 * The function overload for bound_volatile_mem_functor performs a functor
 * on the object instance stored in the bound_volatile_mem_functor object.
 *
 * @ingroup functors
 */
template <class T_action, LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
void visit_each(const T_action& _A_action,
                const bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>& _A_target)
{
  visit_each(_A_action, _A_target.obj_ptr_);
}

/** Performs a functor on each of the targets of a functor.
 * The function overload for bound_const_volatile_mem_functor performs a functor
 * on the object instance stored in the bound_const_volatile_mem_functor object.
 *
 * @ingroup functors
 */
template <class T_action, LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
void visit_each(const T_action& _A_action,
                const bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>& _A_target)
{
  visit_each(_A_action, _A_target.obj_ptr_);
}

])

define([MEM_FUN],[dnl
/** Creates a functor of type mem_functor$1 which wraps a method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type const_mem_functor$1 which wraps a const method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type volatile_functor$1 which wraps a volatile method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type const_volatile_mem_functor$1 which wraps a const volatile method.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_func); }

/** Creates a functor of type bound_mem_functor$1 which encapsulates a method and an object instance.
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_mem_functor$1 which encapsulates a method and an object instance.
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)))
{ return bound_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_const_mem_functor$1 which encapsulates a const method and an object instance.
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(const T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_const_mem_functor$1 which encapsulates a const method and an object instance.
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(const T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const)
{ return bound_const_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_volatile_mem_functor$1 which encapsulates a volatile method and an object instance.
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_volatile_mem_functor$1 which encapsulates a volatile method and an object instance.
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) volatile)
{ return bound_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_const_volatile_mem_functor$1 which encapsulates a const volatile method and an object instance.
 * @param _A_obj Pointer to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(const T_obj* _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }

/** Creates a functor of type bound_const_volatile_mem_functor$1 which encapsulates a const volatile method and an object instance.
 * @param _A_obj Reference to object instance the functor should operate on.
 * @param _A_func Pointer to method that should be wrapped.
 * @return Functor that executes _A_func on invokation.
 *
 * @ingroup functors
 */
template <LIST(LOOP(class T_arg%1, $1), class T_return, class T_obj)>
inline bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>
mem_fun[]ifelse($2,, $1)(const T_obj& _A_obj, T_return (T_obj::*_A_func)(LOOP(T_arg%1,$1)) const volatile)
{ return bound_const_volatile_mem_functor$1<LIST(LOOP(T_arg%1, $1), T_return, T_obj)>(_A_obj, _A_func); }
])

divert(0)

// implementation notes:  
//  - we do not use bind here, because it would introduce
//    an extra copy and complicate the header include order if bind is
//    to have automatic conversion for member pointers.
__FIREWALL__
#include <sigc++/type_traits.h>
#include <sigc++/functors/functor_trait.h>

namespace sigc {

FOR(0,CALL_SIZE,[[MEMBER_FUNCTOR(%1)]])dnl

// numbered
FOR(0,CALL_SIZE,[[MEM_FUN(%1)]])dnl

// unnumbered
FOR(0,CALL_SIZE,[[MEM_FUN(%1,1)]])dnl

} /* namespace sigc */
