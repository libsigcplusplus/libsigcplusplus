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

define([SIGNAL_EMIT_N],[dnl
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_accumulator)>
struct signal_emit$1
{
  typedef signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)> self_type;
  typedef typename T_accumulator::result_type result_type;
  typedef functor::closure<LIST(T_return, LOOP(T_arg%1, $1))> closure_type;
  typedef internal::closure_iterator_buf<self_type> closure_iterator_buf_type;
  typedef signal_impl::const_iterator_type iterator_type;

  signal_emit$1(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) ifelse($1,0,,[
    : LOOP(_A_a%1_(_A_a%1), $1)]) {}

  T_return operator()(const closure_type& _A_cl) const
    { return (reinterpret_cast<typename closure_type::call_type>(_A_cl.rep_->call_))(LIST(_A_cl.rep_, LOOP(_A_a%1_, $1))); }
dnl  T_return operator()(const closure_type& _A_closure) const
dnl    { return _A_closure(LOOP(_A_a%1_, $1)); }

  static result_type emit(LIST(const iterator_type& first, const iterator_type& last, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)))
    {
      self_type self ifelse($1,0,,[(LOOP(_A_a%1, $1))]);
      T_accumulator accumulator;
      return accumulator(closure_iterator_buf_type(first, self),
                         closure_iterator_buf_type(last, self));
    }
dnl
  FOR(1, $1,[
  typename type_trait<T_arg%1>::take _A_a%1_;])
};

template <LIST(class T_return, LOOP(class T_arg%1, $1))>
struct signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), nil)>
{
  typedef signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), nil) > self_type;
  typedef T_return result_type;
  typedef functor::closure<LIST(T_return, LOOP(T_arg%1, $1))> closure_type;
  typedef signal_impl::const_iterator_type iterator_type;
  typedef typename closure_type::call_type call_type;

  static result_type emit(LIST(iterator_type first, iterator_type last, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)))
    {
      T_return r_;
      for (; first != last; ++first)
        {
          if (first->empty() || first->blocked())
            continue;
          r_ = (reinterpret_cast<call_type>(first->rep_->call_))(LIST(first->rep_, LOOP(_A_a%1, $1)));
        }
      return r_;
    }
};

template <LOOP(class T_arg%1, $1)>
struct signal_emit$1<LIST(void, LOOP(T_arg%1, $1), nil)>
{
  typedef signal_emit$1<LIST(void, LOOP(T_arg%1, $1), nil)> self_type;
  typedef void result_type;
  typedef functor::closure<LIST(void, LOOP(T_arg%1, $1))> closure_type;
  typedef signal_impl::const_iterator_type iterator_type;
  typedef ifelse($1,0,void (*call_type)(functor::internal::closure_rep*),typename closure_type::call_type call_type);

  static result_type emit(LIST(iterator_type first, iterator_type last, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)))
    {
      for (; first != last; ++first)
        {
          if (first->empty() || first->blocked())
            continue;
          (reinterpret_cast<call_type>(first->rep_->call_))(LIST(first->rep_, LOOP(_A_a%1, $1)));
        }
    }
};

])

define([SIGNAL_N],[dnl
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_accumulator)>
class signal$1
  : public internal::signal_base
{
  public:
    typedef internal::signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)> emitter_type;
    typedef typename emitter_type::result_type            result_type;
    typedef functor::closure<LIST(T_return, LOOP(T_arg%1, $1))> closure_type;
    typedef internal::closure_list<closure_type>          closure_list;
    typedef typename closure_list::iterator               iterator;
    typedef typename closure_list::const_iterator         const_iterator;
    typedef typename closure_list::reverse_iterator       reverse_iterator;
    typedef typename closure_list::const_reverse_iterator const_reverse_iterator;

    iterator connect(const closure_type& slot_)
      { return iterator(signal_base::connect(static_cast<const functor::internal::closure_base&>(slot_))); }

    result_type emit(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
      {
        if (empty())
          return result_type();
        internal::signal_exec exec(impl_);
        return emitter_type::emit(LIST(impl_->slots_.begin(), impl_->slots_.end(), LOOP(_A_a%1, $1)));
      }

    result_type operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
      { return emit(LOOP(_A_a%1, $1)); }

    closure_list closures()
      { return closure_list(impl()); }

    const closure_list closures() const
      { return closure_list(const_cast<signal$1*>(this)->impl()); }
dnl    closure_list& closures()
dnl      {
dnl        closures_proxy_ = closure_list(this);
dnl        return closures_proxy_;
dnl      }
dnl
dnl    const closure_list& closures() const
dnl      {
dnl        closures_proxy_ = closure_list(const_cast<signal$1*>(this));
dnl        return closures_proxy_;
dnl      }

    signal$1() {}

  private:
    signal$1(const signal$1&);
    signal$1& operator = (const signal$1&);
dnl
dnl  protected:
dnl    mutable closure_list closures_proxy_;
};

])

define([SIGNAL],[dnl
ifelse($1, $2,
[template <LIST(class T_return, LOOP(class T_arg%1 = nil, $1))>],
[template <LIST(class T_return, LOOP(class T_arg%1, $1))>])
class signal ifelse($1, $2,,[<LIST(T_return, LOOP(T_arg%1,$1))>])
  : public signal$1<LIST(T_return, LOOP(T_arg%1, $1),nil)>
{
  template <class T_accumulator>
  class accumulated
    : public signal$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)>
    {
      public:
        inline typename T_accumulator::result_type operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
          { return emit(LOOP(_A_a%1, $1)); }
    };

  public:
    T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
      { return emit(LOOP(_A_a%1, $1)); }

    signal() {}
};

])


divert(0)
#ifndef _SIGC_SIGNAL_H_
#define _SIGC_SIGNAL_H_

#include <list>
#include <sigc++/type_traits.h>
#include <sigc++/trackable.h>
#include <sigc++/functors/closure.h>

namespace sigc {

namespace internal {

/** Implementation of the signal interface.
 * signal_impl manages a list of closures. When a closure becomes
 * invalid (because some referred object dies), notify() is executed.
 * notify() either calls sweep() directly or defers the execution of
 * sweep() when the signal is being emitted. sweep() removes all
 * invalid closure from the list. sweep() also deletes "this" if
 * the destruction was defered because the signal died during
 * emission calling destroy().
 */
struct signal_impl
{
  typedef size_t size_type;
  typedef std::list<functor::internal::closure_base>::iterator iterator_type;
  typedef std::list<functor::internal::closure_base>::const_iterator const_iterator_type;

  signal_impl()
    : exec_count_(0), defered_(0), destroy_(0) {}

  inline bool empty() const
    { return slots_.empty(); }

  void clear()
    { slots_.clear(); }

  size_type size() const
    { return slots_.size(); }

  iterator_type connect(const functor::internal::closure_base& slot_)
    { return insert(slots_.end(), slot_); }

  iterator_type insert(iterator_type i, const functor::internal::closure_base& slot_);

  iterator_type erase(iterator_type i)
    { return slots_.erase(i); }

  // removes empty closures from slots_
  void sweep();

  // deletes this if exec_count==0
  void destroy();

  static void* notify(void* d);

  int exec_count_;
  bool defered_;
  bool destroy_;
  std::list<functor::internal::closure_base> slots_;
};

/** Base class for the signal#<> templates.
 * signal_base integrates most of the interface of the derived signal#<>
 * templates (therefore reducing code size). The implementation, however,
 * resides in signal_impl. A signal_impl object is dynamically allocated
 * from signal_base when first connecting a closure to the signal. This
 * measure drastically reduces the size of empty signals.
 * Note that signals are not copyable and therefore cannot be functors,
 * i.e. no closure can be built from a signal directly.
 * However, functors can be built from member functions of signal_base
 * or signal#<> using mem_fun(). Closures built from these functors are
 * automatically disconnected when the signal dies because signal_base
 * inherits trackable.
 */
struct signal_base : public trackable
{
  typedef size_t size_type;

  signal_base()
    : impl_(0) {}

  ~signal_base();

  inline bool empty() const
    { return (!impl_ || impl_->empty()); }

  void clear()
    { if (impl_) impl_->clear(); }

  size_type size() const
    { return (impl_ ? impl_->size() : 0); }

  protected:
    typedef std::list<functor::internal::closure_base>::iterator iterator_type;

    iterator_type connect(const functor::internal::closure_base& slot_)
      { return impl()->connect(slot_); }

    iterator_type insert(iterator_type i, const functor::internal::closure_base& slot_)
      { return impl()->insert(i, slot_); }

    iterator_type erase(iterator_type i)
      { return impl()->erase(i); }

    signal_impl* impl_;
    signal_impl* impl();
};

/** Exception safe sweeper for cleaning up empty closures on list.
 */
struct signal_exec
{
  signal_impl* sig_;
  inline signal_exec(const signal_impl* sig) 
    : sig_(const_cast<signal_impl*>(sig) )
      { (sig_->exec_count_)++; }
  inline ~signal_exec() 
    { 
      if (--(sig_->exec_count_) == 0 && sig_->defered_)
        sig_->sweep(); 
    }
};

/** Stl-style iterator for closure_list.
 */
template <typename T_closure>
struct closure_iterator
{
  typedef size_t                          size_type;
  typedef ptrdiff_t                       difference_type;
  typedef std::bidirectional_iterator_tag iterator_category;

  typedef T_closure  closure_type;

  typedef T_closure  value_type;
  typedef T_closure* pointer;
  typedef T_closure& reference;

  typedef typename signal_impl::iterator_type iterator_type;

  closure_iterator()
    {}

  explicit closure_iterator(const iterator_type& i)
    : i_(i) {}

  reference operator*() const
    { return static_cast<reference>(*i_); }

  pointer operator->() const
    { return &(operator*()); }

  closure_iterator& operator++()
    {
      ++i_;
      return *this;
    }

  closure_iterator operator++(int)
    { 
      closure_iterator __tmp(*this);
      ++i_;
      return __tmp;
    }

  closure_iterator& operator--()
    {
      --i_;
      return *this;
    }

  closure_iterator& operator--(int)
    {
      closure_iterator __tmp(*this);
      --i_;
      return __tmp;
    }

  bool operator == (const closure_iterator& other) const
    { return i_ == other.i_; }

  bool operator != (const closure_iterator& other) const
    { return i_ != other.i_; }

  iterator_type i_;
};

/** Stl-style const iterator for closure_list.
 */
template <typename T_closure>
struct closure_const_iterator
{
  typedef size_t                          size_type;
  typedef ptrdiff_t                       difference_type;
  typedef std::bidirectional_iterator_tag iterator_category;

  typedef T_closure        closure_type;

  typedef T_closure        value_type;
  typedef const T_closure* pointer;
  typedef const T_closure& reference;

  typedef typename signal_impl::const_iterator_type iterator_type;

  closure_const_iterator()
    {}

  explicit closure_const_iterator(const iterator_type& i)
    : i_(i) {}

  reference operator*() const
    { return static_cast<reference>(*i_); }

  pointer operator->() const
    { return &(operator*()); }

  closure_const_iterator& operator++()
    {
      ++i_;
      return *this;
    }

  closure_const_iterator operator++(int)
    { 
      closure_const_iterator __tmp(*this);
      ++i_;
      return __tmp;
    }

  closure_const_iterator& operator--()
    {
      --i_;
      return *this;
    }

  closure_const_iterator& operator--(int)
    {
      closure_const_iterator __tmp(*this);
      --i_;
      return __tmp;
    }

  bool operator == (const closure_const_iterator& other) const
    { return i_ == other.i_; }

  bool operator != (const closure_const_iterator& other) const
    { return i_ != other.i_; }

  iterator_type i_;
};

/** Stl style list interface for signal#<>.
 * closure_list can be used to access the list of closures that
 * is managed by a signal. A closure_list object can be retrieved
 * from signal#<>::closures().
 */
template <class T_closure>
struct closure_list
{
  typedef T_closure closure_type;

  typedef closure_type& reference;
  typedef const closure_type& const_reference;

  typedef internal::closure_iterator<closure_type>       iterator;
  typedef internal::closure_const_iterator<closure_type> const_iterator;
  typedef std::reverse_iterator<iterator>       reverse_iterator;
  typedef std::reverse_iterator<const_iterator> const_reverse_iterator;

  closure_list()
    : list_(0) {}

  explicit closure_list(signal_impl* __list)
    : list_(__list) {}

  iterator begin()
    { return iterator(list_->slots_.begin()); }

  const_iterator begin() const
    { return const_iterator(list_->slots_.begin()); }

  iterator end()
    { return iterator(list_->slots_.end()); }

  const_iterator end() const
    { return const_iterator(list_->slots_.end()); }

  reverse_iterator rbegin() 
    { return reverse_iterator(end()); }

  const_reverse_iterator rbegin() const 
    { return const_reverse_iterator(end()); }

  reverse_iterator rend()
    { return reverse_iterator(begin()); }

  const_reverse_iterator rend() const
    { return const_reverse_iterator(begin()); }

  reference front()
    { return *begin(); }

  const_reference front() const
    { return *begin(); }

  reference back()
    { return *(--end()); }

  const_reference back() const
    { return *(--end()); }

  iterator insert(iterator i, const closure_type& slot_)
    { return iterator(list_->insert(i.i_, static_cast<const functor::internal::closure_base&>(slot_))); }

  void push_front(const closure_type& c)
    { insert(begin(), c); }

  void push_back(const closure_type& c)
    { insert(end(), c); }

  iterator erase(iterator i)
    { return iterator(list_->erase(i.i_)); }

  iterator erase(iterator first_, iterator last_)
    {
      while (first_ != last_)
        erase(first_++);
      return last_;
    }

  void pop_front()
    { erase(begin()); }

  void pop_back()
    { 
      iterator tmp_ = end();
      erase(--tmp_);
    }

  protected:
    signal_impl* list_;
};

/** Special iterator over signal_impl's closure list that holds extra data.
 * This iterators is for use in accumulators. operator*() executes the closure.
 * The return value is buffered, so that in an expression like "a = *i * *i;"
 * the closure is only executed once.
 */
template <class T_emitter, class T_result = typename T_emitter::result_type>
struct closure_iterator_buf
{
  typedef size_t                           size_type;
  typedef ptrdiff_t                        difference_type;
  typedef std::bidirectional_iterator_tag  iterator_category;

  typedef T_emitter                        emitter_type;
  typedef T_result                         result_type;
  typedef typename T_emitter::closure_type closure_type;

  typedef signal_impl::const_iterator_type iterator_type;

  closure_iterator_buf(const iterator_type& i, const emitter_type& c)
    : i_(i), c_(c), invoked_(false) {}

  result_type operator*() const
    {
      if (!i_->empty() && !i_->blocked() && !invoked_)
        {
          r_ = c_(static_cast<const closure_type&>(*i_));
          invoked_ = true;
        }
      return r_;
    }

  closure_iterator_buf& operator++()
    {
      ++i_;
      invoked_ = false;
      return *this;
    }

  closure_iterator_buf operator++(int)
    { 
      closure_iterator_buf __tmp(*this);
      ++i_;
      invoked_ = false;
      return __tmp;
    }

  closure_iterator_buf& operator--()
    {
      --i_;
      invoked_ = false;
      return *this;
    }

  closure_iterator_buf& operator--(int)
    {
      closure_iterator_buf __tmp(*this);
      --i_;
      invoked_ = false;
      return __tmp;
    }

  bool operator == (const closure_iterator_buf& other) const
    { return i_ == other.i_; }

  bool operator != (const closure_iterator_buf& other) const
    { return i_ != other.i_; }

  private:
    iterator_type i_;
    const emitter_type& c_;
    mutable result_type r_;
    mutable bool invoked_;
};

/** Template specialization of closure_iterator_buf for void return.
 */
template <class T_emitter>
struct closure_iterator_buf<T_emitter, void>
{
  typedef size_t                           size_type;
  typedef ptrdiff_t                        difference_type;
  typedef std::bidirectional_iterator_tag  iterator_category;

  typedef T_emitter                        emitter_type;
  typedef void                             result_type;
  typedef typename T_emitter::closure_type closure_type;

  typedef typename std::list<functor::internal::closure_base>::const_iterator iterator_type;

  closure_iterator_buf(const iterator_type& i, const emitter_type& c)
    : i_(i), c_(c), invoked_(false) {}

  void operator*() const
    {
      if (!i_->empty_or_blocked() && !invoked_)
        {
          c_(static_cast<const closure_type&>(*i_));
          invoked_ = true;
        }
    }

  closure_iterator_buf& operator++()
    {
      ++i_;
      invoked_ = false;
      return *this;
    }

  closure_iterator_buf operator++(int)
    { 
      closure_iterator_buf __tmp(*this);
      ++i_;
      invoked_ = false;
      return __tmp;
    }

  closure_iterator_buf& operator--()
    {
      --i_;
      invoked_ = false;
      return *this;
    }

  closure_iterator_buf& operator--(int)
    {
      closure_iterator_buf __tmp(*this);
      --i_;
      invoked_ = false;
      return __tmp;
    }

  bool operator == (const closure_iterator_buf& other) const
    { return i_ == other.i_; }

  bool operator != (const closure_iterator_buf& other) const
    { return i_ != other.i_; }

  private:
    iterator_type i_;
    const emitter_type& c_;
    mutable bool invoked_;
};

/** Abstracts signal emission.
 * This template implements the emit() function of signal#<>.
 * Template specializations are available to optimize signal
 * emission when no accumulator is used (T_accumulator == nil).
 */
FOR(0,CALL_SIZE,[[SIGNAL_EMIT_N(%1)]])

} /* namespace internal */

/** Signal declaration.
 * An stl style list interface for the signal's list of
 * closures can be retrieved with closures().
 */
FOR(0,CALL_SIZE,[[SIGNAL_N(%1)]])

/** Convinience wrappers for the signal#<> templates.
 * Connect some closures to the signal and call emit() when
 * you want the closures to be executed. The closure<>
 * templates have implicit constructors so that you can
 * pass any functor into the connect function.
 * To disconnect a specific closure you need its iterator.
 * You get iterators from connect() or from the stl style
 * list interface of signal that can be retrieved from closures().
 *
 * Example:
 *   void foo(int) {}
 *   signal<void, long> sig;
 *   sig.connect(ptr_fun(&foo));
 *   sig.emit(19);
 *
 */
SIGNAL(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[SIGNAL(%1)]])

} /* namespace sigc */

#endif /* _SIGC_SIGNAL_H_ */
