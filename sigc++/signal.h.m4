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

define([SIGNAL],[dnl
ifelse($1, $2,
[template <LIST(class T_return, LOOP(class T_arg%1 = nil, $1))>],
[template <LIST(class T_return, LOOP(class T_arg%1, $1))>])
class signal ifelse($1, $2,,[<LIST(T_return, LOOP(T_arg%1,$1))>])
  : public signal$1<LIST(T_return, LOOP(T_arg%1, $1), functor::default_accumulator<T_return> ) >
{
  template <class T_accumulator>
  class accumulated
    :  public signal$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)>
    {
      public:
        typename T_accumulator::result_type operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
          { return emit(LOOP(_A_a%1, $1)); }
    };

  public:
    T_return operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
      { return emit(LOOP(_A_a%1, $1)); }

    signal() {}
};

])

define([SIGNAL_N],[dnl
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_accumulator)>
class signal$1
  : public internal::signal_base
{
  struct caller
  {
    typedef typename T_accumulator::result_type result_type;
    typedef functor::closure<LIST(T_return, LOOP(T_arg%1, $1))> closure_type;

    caller(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) ifelse($1,0,,[
      : LOOP(_A_a%1_(_A_a%1), $1)]) {}

    T_return operator()(const closure_type& _A_closure) const
      { return _A_closure(LOOP(_A_a%1_, $1)); }
dnl
    FOR(1, $1,[
    typename type_trait<T_arg%1>::take _A_a%1_;])
  };

  public:
    typedef T_accumulator accumulator_type;
    typedef typename accumulator_type::result_type        result_type;
    typedef functor::closure<LIST(T_return, LOOP(T_arg%1, $1))> closure_type;
    typedef internal::closure_list<closure_type>          closure_list;
    typedef typename closure_list::iterator               iterator;
    typedef typename closure_list::const_iterator         const_iterator;
    typedef typename closure_list::reverse_iterator       reverse_iterator;
    typedef typename closure_list::const_reverse_iterator const_reverse_iterator;

    iterator connect(const closure_type& slot_)
      { return iterator(insert(slots_.end(), static_cast<const functor::internal::closure_base&>(slot_))); }

    result_type emit(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const;

    result_type operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
      { return emit(LOOP(_A_a%1, $1)); }

    closure_list closures()
      { return closure_list(this); }

    const closure_list closures() const
      { return closure_list(const_cast<signal$1*>(this)); }
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

template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_accumulator)>
typename T_accumulator::result_type 
signal$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)>
  ::emit(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
{
  typedef internal::closure_iterator_buf<caller> closure_iterator_buf_type;

  internal::signal_exec exec(this);
  caller caller_ ifelse($1,0,,[(LOOP(_A_a%1, $1))]);
  T_accumulator accumulator;

  return accumulator(closure_iterator_buf_type(slots_.begin(), caller_),
                      closure_iterator_buf_type(slots_.end(), caller_));
}

])


divert(0)
#ifndef _SIGC_SIGNAL_H_
#define _SIGC_SIGNAL_H_

#include <list>
#include <sigc++/type_traits.h>
#include <sigc++/trackable.h>
#include <sigc++/functors/closure.h>

namespace sigc {
namespace functor {

// fixme move outside
template <class T_return>
struct default_accumulator 
{
  typedef T_return result_type;
  template<typename T_iterator>
  T_return operator()(T_iterator first, T_iterator last) const
    {
      T_return value_;
      while (first != last)
        value_ = *first++;
      return value_;
    }
};

template <>
struct default_accumulator<void>
{
  typedef void result_type;
  template<typename T_iterator>
  void operator()(T_iterator first, T_iterator last) const
    {
      while (first != last)
        *first++;
    }
};

} /* namespace functor */


namespace internal {

struct signal_exec;

template <class T_closure>
struct closure_list;

// Base class to simplify code. Notes:
// - signals are not copyable and therefore not functors
// - inherits trackable so that functors with our auto-disconnection
//   feature can be built from the emit function
struct signal_base : public trackable
{
  friend struct signal_exec;
  template <class T_closure> friend struct closure_list;

  typedef size_t size_type;

  signal_base()
    : exec_count_(0), defered_(0) {}

  bool empty() const { return slots_.empty(); }
  void clear()       { slots_.clear(); }

  size_type size() const { return slots_.size(); }

  protected:
    typedef std::list<functor::internal::closure_base>::iterator iterator_type;

    static void* notify(void* d);

    iterator_type insert(iterator_type i, const functor::internal::closure_base& slot_);
    iterator_type erase(iterator_type i)
      { return slots_.erase(i); }

    // removes empty closures from slots_
    void sweep();

    int exec_count_;
    bool defered_;
    std::list<functor::internal::closure_base> slots_;
};

// Iterator over closures.
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

  typedef typename std::list<functor::internal::closure_base>::iterator iterator_type;

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

  typedef typename std::list<functor::internal::closure_base>::const_iterator iterator_type;

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

// Templated base class to summonize stl list style interface
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

  explicit closure_list(signal_base* __list)
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
    signal_base* list_;
};

// Exception safe sweeper for cleaning up empty closures on list
struct signal_exec
{
  signal_base* sig_;
  signal_exec(const signal_base* sig) 
    : sig_(const_cast<signal_base*>(sig) )
      { (sig_->exec_count_)++; }
  ~signal_exec() 
    { 
      if (--(sig_->exec_count_) == 0&&sig_->defered_) 
        sig_->sweep(); 
    }
};

// Iterator over closures. For use in accumulators during emit.
template <class T_caller, class T_result = typename T_caller::result_type>
struct closure_iterator_buf
{
  typedef size_t                          size_type;
  typedef ptrdiff_t                       difference_type;
  typedef std::bidirectional_iterator_tag iterator_category;

  typedef T_caller                        caller_type;
  typedef T_result                        result_type;
  typedef typename T_caller::closure_type closure_type;

  typedef typename std::list<functor::internal::closure_base>::const_iterator iterator_type;

  closure_iterator_buf(const iterator_type& i, const caller_type& c)
    : i_(i), c_(c), invoked_(false) {}

  result_type operator*() const
    {
      if (!invoked_)
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
    const caller_type& c_;
    mutable result_type r_;
    mutable bool invoked_;
};

template <class T_caller>
struct closure_iterator_buf<T_caller, void>
{
  typedef size_t                          size_type;
  typedef ptrdiff_t                       difference_type;
  typedef std::bidirectional_iterator_tag iterator_category;

  typedef T_caller                        caller_type;
  typedef void                            result_type;
  typedef typename T_caller::closure_type closure_type;

  typedef typename std::list<functor::internal::closure_base>::const_iterator iterator_type;

  closure_iterator_buf(const iterator_type& i, const caller_type& c)
    : i_(i), c_(c), invoked_(false) {}

  void operator*() const
    {
      if (!invoked_)
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
    const caller_type& c_;
    mutable bool invoked_;
};

} /* namespace internal */

// signal# is the full signal declaration
FOR(0,CALL_SIZE,[[SIGNAL_N(%1)]])

// signal is a wrapper to make it nice
SIGNAL(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[SIGNAL(%1)]])

} /* namespace sigc */

#endif /* _SIGC_SIGNAL_H_ */
