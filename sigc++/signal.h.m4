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
/** Abstracts signal emission.
 * This template implements the emit() function of signal$1<>.
 * Template specializations are available to optimize signal
 * emission when no accumulator is used, i.e. the template
 * argument @p T_accumulator is @p nil.
 *
 * @ingroup signal
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_accumulator)>
struct signal_emit$1
{
  typedef signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)> self_type;
  typedef typename T_accumulator::result_type result_type;
  typedef functor::slot<LIST(T_return, LOOP(T_arg%1, $1))> slot_type;
  typedef internal::slot_iterator_buf<self_type> slot_iterator_buf_type;
  typedef signal_impl::const_iterator_type iterator_type;

  /** Instantiates the class.
ifelse($1,0,,[dnl
   * The parameters are stored in member variables. operator()() passes
   * the values on to some slot.])
   */
  signal_emit$1(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) ifelse($1,0,,[
    : LOOP(_A_a%1_(_A_a%1), $1)]) {}

ifelse($1,0,[dnl
  /** Invokes a slot.],[
  /** Invokes a slot using the buffered parameter values.])
   * @param _A_slot Some slot to invoke.
   * @return The slot's return value.
   */
  T_return operator()(const slot_type& _A_slot) const
    { return (reinterpret_cast<typename slot_type::call_type>(_A_slot.rep_->call_))(LIST(_A_slot.rep_, LOOP(_A_a%1_, $1))); }
dnl  T_return operator()(const slot_type& _A_slot) const
dnl    { return _A_slot(LOOP(_A_a%1_, $1)); }

  /** Executes a list of slots using an accumulator of type @p T_accumulator.
ifelse($1,0,,[dnl
   * The arguments are buffered in a temporary instance of signal_emit$1.])
   * @param first An iterator pointing to the first slot in the list.
   * @param last An iterator pointing to the last slot in the list.
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the slots.])
   * @return The accumulated return values of the slot invocations as processed by the accumulator.
   */
  static result_type emit(LIST(const iterator_type& first, const iterator_type& last, LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)))
    {
      self_type self ifelse($1,0,,[(LOOP(_A_a%1, $1))]);
      T_accumulator accumulator;
      return accumulator(slot_iterator_buf_type(first, self),
                         slot_iterator_buf_type(last, self));
    }
dnl
  FOR(1, $1,[
  typename type_trait<T_arg%1>::take _A_a%1_;])
};

/** Abstracts signal emission.
 * This template specialization implements an optimized emit()
 * function for the case that no accumulator is used.
 *
 * @ingroup signal
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>
struct signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), nil)>
{
  typedef signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), nil) > self_type;
  typedef T_return result_type;
  typedef functor::slot<LIST(T_return, LOOP(T_arg%1, $1))> slot_type;
  typedef signal_impl::const_iterator_type iterator_type;
  typedef typename slot_type::call_type call_type;

  /** Executes a list of slots using an accumulator of type @p T_accumulator.
ifelse($1,0,,[dnl
   * The arguments are passed directly on to the slots.])
   * The return value of the last slot invoked is returned.
   * @param first An iterator pointing to the first slot in the list.
   * @param last An iterator pointing to the last slot in the list.
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the slots.])
   * @return The return value of the last slot invoked.
   */
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

/** Abstracts signal emission.
 * This template specialization implements an optimized emit()
 * function for the case that no accumulator is used and the
 * return type is void.
 *
 * @ingroup signal
 */
template <LOOP(class T_arg%1, $1)>
struct signal_emit$1<LIST(void, LOOP(T_arg%1, $1), nil)>
{
  typedef signal_emit$1<LIST(void, LOOP(T_arg%1, $1), nil)> self_type;
  typedef void result_type;
  typedef functor::slot<LIST(void, LOOP(T_arg%1, $1))> slot_type;
  typedef signal_impl::const_iterator_type iterator_type;
  typedef ifelse($1,0,void (*call_type)(functor::internal::slot_rep*),typename slot_type::call_type call_type);

  /** Executes a list of slots using an accumulator of type @p T_accumulator.
ifelse($1,0,,[dnl
   * The arguments are passed directly on to the slots.])
   * @param first An iterator pointing to the first slot in the list.
   * @param last An iterator pointing to the last slot in the list.
FOR(1, $1,[
   * @param _A_a%1 Argument to be passed on to the slots.])
   */
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
/** Signal declaration.
 * signal$1 can be used to connect() slots that are invoked
 * during subsequent calls to emit(). Any functor of closure
 * can be passed into connect(). It is converted into a slot
 * implicitely.
 * An stl style list interface for the signal's list of slots
 * can be retrieved with slots(). This interface supports
 * iteration, insertion and removal of slots.
 *
 * The following template arguments are used:
 * - @e T_return The desired return type for the emit() function (may be overridden by the accumulator).dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of emit().])
 * - @e T_accumulator The accumulator type used for emission.
 *
 * You should use the unnumbered signal<> template for convinience.
 *
 * @ingroup signal
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1), class T_accumulator)>
class signal$1
  : public internal::signal_base
{
  public:
    typedef internal::signal_emit$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)> emitter_type;
    typedef typename emitter_type::result_type            result_type;
    typedef functor::slot<LIST(T_return, LOOP(T_arg%1, $1))> slot_type;
    typedef internal::slot_list<slot_type>          slot_list;
    typedef typename slot_list::iterator               iterator;
    typedef typename slot_list::const_iterator         const_iterator;
    typedef typename slot_list::reverse_iterator       reverse_iterator;
    typedef typename slot_list::const_reverse_iterator const_reverse_iterator;

    /** Add a slot to the list of slots.
     * Any functor or closure may be passed into connect().
     * It will be converted into a slot implicitely.
     * The returned iterator may be stored for disconnection
     * of the slot at some later point. It stays valid until
     * the slot is removed from the list of slots. The iterator
     * can also be implicitely converted into a connection object
     * that may be used safely beyond the life time of the slot.
     * @param slot_ The slot to add to the list of slots.
     * @return An iterator pointing to the new slot in the list.
     */
    iterator connect(const slot_type& slot_)
      { return iterator(signal_base::connect(static_cast<const functor::internal::slot_base&>(slot_))); }

    /** Triggers the emission of the signal.
     * During signal emission all slots that have been connected
     * to the signal are invoked unless they are manually set into
     * a blocking state. The parameters are passed on to the slots.
     * If @p T_accumulated is not @p nil, an accumulator of this type
     * is used to process the return values of the slot invocations.
     * Otherwise, the return value of the last slot invoked is returned.dnl
FOR(1, $1,[
     * @param _A_a%1 Argument to be passed on to the slots.])
     * @return The accumulated return values of the slot invocations.
     */
    result_type emit(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
      {
        if (empty())
          return result_type();
        internal::signal_exec exec(impl_);
        return emitter_type::emit(LIST(impl_->slots_.begin(), impl_->slots_.end(), LOOP(_A_a%1, $1)));
      }

    /** Triggers the emission of the signal (see emit()). */
    result_type operator()(LOOP(typename type_trait<T_arg%1>::take _A_a%1, $1)) const
      { return emit(LOOP(_A_a%1, $1)); }

    /** Creates an stl style interface for the signal's list of slots.
     * This interface supports iteration, insertion and removal of slots.
     * @return An stl stlye interface for the signal's list of slots.
     */
    slot_list slots()
      { return slot_list(impl()); }

    /** Creates an stl style interface for the signal's list of slots.
     * This interface supports iteration, insertion and removal of slots.
     * @return An stl stlye interface for the signal's list of slots.
     */
    const slot_list slots() const
      { return slot_list(const_cast<signal$1*>(this)->impl()); }

    /** Constructs a signal. */
    signal$1() {}

  private:
    signal$1(const signal$1&);
    signal$1& operator = (const signal$1&);
};

])

define([SIGNAL],[dnl
ifelse($1, $2,[dnl
/** Convinience wrapper for the numbered signal#<> templates.
 * signal can be used to connect() slots that are invoked
 * during subsequent calls to emit(). Any functor of closure
 * can be passed into connect(). It is converted into a slot
 * implicitely.
 * An stl style list interface for the signal's list of slots
 * can be retrieved with slots(). This interface supports
 * iteration, insertion and removal of slots.
 *
 * The following template arguments are used:
 * - @e T_return The desired return type of the emit() function.dnl
FOR(1,$1,[
 * - @e T_arg%1 Argument type used in the definition of emit(). The default @p nil means no argument.])
 *
 * To specify an accumulator type the nested class accumulated can be used.
 *
 * @par Example:
 *   @code
 *   void foo(int) {}
 *   signal<void, long> sig;
 *   sig.connect(ptr_fun(&foo));
 *   sig.emit(19);
 *   @endcode
 *
 * @ingroup signal
 */
template <LIST(class T_return, LOOP(class T_arg%1 = nil, $1))>],[dnl
/** Convinience wrapper for the numbered signal#<> templates.
 * This is the template specialization of the unnumbered signal<>
 * template for $1 arguments.
 *
 * @ingroup signal
 */
template <LIST(class T_return, LOOP(class T_arg%1, $1))>])
class signal ifelse($1, $2,,[<LIST(T_return, LOOP(T_arg%1,$1))>])
  : public signal$1<LIST(T_return, LOOP(T_arg%1, $1),nil)>
{
  /** Convinience wrapper for the numbered signal#<> templates.
   * Like signal<> but the additional template parameter @p T_accumulator
   * defines the accumulator type that should be used.
   *
   * @ingroup signal
   */
  template <class T_accumulator>
  class accumulated
    : public signal$1<LIST(T_return, LOOP(T_arg%1, $1), T_accumulator)>
    {};
};

])


divert(0)
#ifndef _SIGC_SIGNAL_H_
#define _SIGC_SIGNAL_H_

#include <list>
#include <sigc++/type_traits.h>
#include <sigc++/trackable.h>
#include <sigc++/functors/slot.h>

namespace sigc {

/** @defgroup signal Signals and Slots
 * signal and slot objects provide the core functionality of this
 * library. A slot is a container for an arbitrary functor.
 * A signal is a list of slots that are executed on emission.
 * For compile time type safety a list of template arguments
 * must be provided for the signal template that determines the
 * parameter list for emission. Functors and closures are converted
 * into slots implicitely on connection, triggering compiler errors
 * if the given functor or closure cannot be invoked with the
 * parameter list of the signal to connect to.
 */

namespace internal {

/** Implementation of the signal interface.
 * signal_impl manages a list of slots. When a slot becomes
 * invalid (because some referred object dies), notify() is executed.
 * notify() either calls sweep() directly or defers the execution of
 * sweep() when the signal is being emitted. sweep() removes all
 * invalid slot from the list. sweep() also deletes @em this by calling
 * destroy() if the destruction was defered because the parent signal
 * died during emission.
 *
 * @ingroup signal
 */
struct signal_impl
{
  typedef size_t size_type;
  typedef std::list<functor::internal::slot_base>::iterator iterator_type;
  typedef std::list<functor::internal::slot_base>::const_iterator const_iterator_type;

  /** Constructs a list of slots. */
  signal_impl()
    : exec_count_(0), defered_(0), destroy_(0) {}

  /** Returns whether the list of slots is empty.
   * @return @p true if the list of slots is empty.
   */
  inline bool empty() const
    { return slots_.empty(); }

  /** Empties the list of slots. */
  void clear()
    { slots_.clear(); }

  /** Returns the number of slots in the list.
   * @return The number of slots in the list.
   */
  size_type size() const
    { return slots_.size(); }

  /** Add a slot at the bottom of the list of slots.
   * @param slot_ The slot to add to the list of slots.
   * @return An iterator pointing to the new slot in the list.
   */
  iterator_type connect(const functor::internal::slot_base& slot_)
    { return insert(slots_.end(), slot_); }

  /** Add a slot at the given position into the list of slots.
   * @param i An iterator indicating the position where @p slot_ should be inserted.
   * @param slot_ The slot to add to the list of slots.
   * @return An iterator pointing to the new slot in the list.
   */
  iterator_type insert(iterator_type i, const functor::internal::slot_base& slot_);

  /** Remove the slot at the given position from the list of slots.
   * @param i An iterator pointing to the slot to be removed.
   * @return An iterator pointing to the slot in the list after the one removed.
   */
  iterator_type erase(iterator_type i)
    { return slots_.erase(i); }

  /** Removes invalid slots from the list of slots. */
  void sweep();

  /** Deletes @em this if @p exec_count_ == @p 0. */
  void destroy();

  /** Callback that is executed when some slot becomes invalid.
   * This callback is registered in every slot when inserted into
   * the list of slots. It is executed when a slot becomes invalid
   * because of some referred object dying.
   * It either calls sweep() directly or defers the execution of
   * sweep() when the signal is being emitted.
   * @param d The slot that is becoming invalid.
   */
  static void* notify(void* d);

  /** Indicates whether the signal is being emitted. */
  int exec_count_;

  /** Indicates whether the execution of sweep() is being deferred. */
  bool defered_;

  /** Indicates whether the destruction of @em this is being deferred. */
  bool destroy_;

  /** The list of slots. */
  std::list<functor::internal::slot_base> slots_;
};

/** Base class for the signal#<> templates.
 * signal_base integrates most of the interface of the derived signal#<>
 * templates (therefore reducing code size). The implementation, however,
 * resides in signal_impl. A signal_impl object is dynamically allocated
 * from signal_base when first connecting a slot to the signal. This
 * technique drastically reduces the size of empty signals.
 * Note that signals are not copyable and therefore cannot be used as
 * functors, i.e. no slot can be built from a signal directly.
 * However, functors can be built from member functions of signal_base
 * or signal#<> using e.g. mem_fun(). slots built from these functors are
 * automatically disconnected when the signal dies because signal_base
 * inherits trackable.
 *
 * @ingroup signal
 */
struct signal_base : public trackable
{
  typedef size_t size_type;

  /** Constructs a signal. */
  signal_base()
    : impl_(0) {}

  /** Destructs a signal.
   * The destruction of the signal_impl object is deferred when
   * executed during emission.
   */
  ~signal_base();

  /** Returns whether the list of slots is empty.
   * @return @p true if the list of slots is empty.
   */
  inline bool empty() const
    { return (!impl_ || impl_->empty()); }

  /** Empties the list of slots. */
  void clear()
    { if (impl_) impl_->clear(); }

  /** Returns the number of slots in the list.
   * @return The number of slots in the list.
   */
  size_type size() const
    { return (impl_ ? impl_->size() : 0); }

  protected:
    typedef std::list<functor::internal::slot_base>::iterator iterator_type;

    /** Add a slot at the bottom of the list of slots.
     * @param slot_ The slot to add to the list of slots.
     * @return An iterator pointing to the new slot in the list.
     */
    iterator_type connect(const functor::internal::slot_base& slot_)
      { return impl()->connect(slot_); }

    /** Add a slot at the given position into the list of slots.
     * @param i An iterator indicating the position where @p slot_ should be inserted.
     * @param slot_ The slot to add to the list of slots.
     * @return An iterator pointing to the new slot in the list.
     */
    iterator_type insert(iterator_type i, const functor::internal::slot_base& slot_)
      { return impl()->insert(i, slot_); }

    /** Remove the slot at the given position from the list of slots.
     * @param i An iterator pointing to the slot to be removed.
     * @return An iterator pointing to the slot in the list after the one removed.
     */
    iterator_type erase(iterator_type i)
      { return impl()->erase(i); }

    /** The signal_impl object encapsulating the list of slots. */
    signal_impl* impl_;

    /** Returns the signal_impl object encapsulating the list of slots.
     * @return The signal_impl object encapsulating the list of slots.
     */
    signal_impl* impl();
};

/** Exception safe sweeper for cleaning up invalid slots on list.
 *
 * @ingroup signal
 */
struct signal_exec
{
  /** The parent signal_impl object. */
  signal_impl* sig_;

  /** Increments the execution counter of the parent signal_impl object.
   * @param sig The parent signal_impl object.
   */
  inline signal_exec(const signal_impl* sig) 
    : sig_(const_cast<signal_impl*>(sig) )
      { (sig_->exec_count_)++; }

  /** Decrements the execution counter of the parent signal_impl object.
   * Invoke the parent signal_impl object's sweep() function
   * if it's execution has been deferred.
   */
  inline ~signal_exec() 
    { 
      if (--(sig_->exec_count_) == 0 && sig_->defered_)
        sig_->sweep(); 
    }
};

/** Stl style iterator for slot_list.
 *
 * @ingroup signal
 */
template <typename T_slot>
struct slot_iterator
{
  typedef size_t                          size_type;
  typedef ptrdiff_t                       difference_type;
  typedef std::bidirectional_iterator_tag iterator_category;

  typedef T_slot  slot_type;

  typedef T_slot  value_type;
  typedef T_slot* pointer;
  typedef T_slot& reference;

  typedef typename signal_impl::iterator_type iterator_type;

  slot_iterator()
    {}

  explicit slot_iterator(const iterator_type& i)
    : i_(i) {}

  reference operator*() const
    { return static_cast<reference>(*i_); }

  pointer operator->() const
    { return &(operator*()); }

  slot_iterator& operator++()
    {
      ++i_;
      return *this;
    }

  slot_iterator operator++(int)
    { 
      slot_iterator __tmp(*this);
      ++i_;
      return __tmp;
    }

  slot_iterator& operator--()
    {
      --i_;
      return *this;
    }

  slot_iterator& operator--(int)
    {
      slot_iterator __tmp(*this);
      --i_;
      return __tmp;
    }

  bool operator == (const slot_iterator& other) const
    { return i_ == other.i_; }

  bool operator != (const slot_iterator& other) const
    { return i_ != other.i_; }

  iterator_type i_;
};

/** Stl style const iterator for slot_list.
 *
 * @ingroup signal
 */
template <typename T_slot>
struct slot_const_iterator
{
  typedef size_t                          size_type;
  typedef ptrdiff_t                       difference_type;
  typedef std::bidirectional_iterator_tag iterator_category;

  typedef T_slot        slot_type;

  typedef T_slot        value_type;
  typedef const T_slot* pointer;
  typedef const T_slot& reference;

  typedef typename signal_impl::const_iterator_type iterator_type;

  slot_const_iterator()
    {}

  explicit slot_const_iterator(const iterator_type& i)
    : i_(i) {}

  reference operator*() const
    { return static_cast<reference>(*i_); }

  pointer operator->() const
    { return &(operator*()); }

  slot_const_iterator& operator++()
    {
      ++i_;
      return *this;
    }

  slot_const_iterator operator++(int)
    { 
      slot_const_iterator __tmp(*this);
      ++i_;
      return __tmp;
    }

  slot_const_iterator& operator--()
    {
      --i_;
      return *this;
    }

  slot_const_iterator& operator--(int)
    {
      slot_const_iterator __tmp(*this);
      --i_;
      return __tmp;
    }

  bool operator == (const slot_const_iterator& other) const
    { return i_ == other.i_; }

  bool operator != (const slot_const_iterator& other) const
    { return i_ != other.i_; }

  iterator_type i_;
};

/** Stl style list interface for signal#<>.
 * slot_list can be used to iterate over the list of slots that
 * is managed by a signal. Slots can be added or removed from
 * the list while existing iterators stay valid. A slot_list
 * object can be retrieved from the signal's slots() function.
 *
 * @ingroup signal
 */
template <class T_slot>
struct slot_list
{
  typedef T_slot slot_type;

  typedef slot_type& reference;
  typedef const slot_type& const_reference;

  typedef internal::slot_iterator<slot_type>       iterator;
  typedef internal::slot_const_iterator<slot_type> const_iterator;
  typedef std::reverse_iterator<iterator>       reverse_iterator;
  typedef std::reverse_iterator<const_iterator> const_reverse_iterator;

  slot_list()
    : list_(0) {}

  explicit slot_list(signal_impl* __list)
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

  iterator insert(iterator i, const slot_type& slot_)
    { return iterator(list_->insert(i.i_, static_cast<const functor::internal::slot_base&>(slot_))); }

  void push_front(const slot_type& c)
    { insert(begin(), c); }

  void push_back(const slot_type& c)
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

/** Special iterator over signal_impl's slot list that holds extra data.
 * This iterators is for use in accumulators. operator*() executes
 * the slot. The return value is buffered, so that in an expression
 * like @code a = *i * *i; @endcode the slot is executed only once.
 *
 * @ingroup signal
 */
template <class T_emitter, class T_result = typename T_emitter::result_type>
struct slot_iterator_buf
{
  typedef size_t                           size_type;
  typedef ptrdiff_t                        difference_type;
  typedef std::bidirectional_iterator_tag  iterator_category;

  typedef T_emitter                        emitter_type;
  typedef T_result                         result_type;
  typedef typename T_emitter::slot_type slot_type;

  typedef signal_impl::const_iterator_type iterator_type;

  slot_iterator_buf(const iterator_type& i, const emitter_type& c)
    : i_(i), c_(c), invoked_(false) {}

  result_type operator*() const
    {
      if (!i_->empty() && !i_->blocked() && !invoked_)
        {
          r_ = c_(static_cast<const slot_type&>(*i_));
          invoked_ = true;
        }
      return r_;
    }

  slot_iterator_buf& operator++()
    {
      ++i_;
      invoked_ = false;
      return *this;
    }

  slot_iterator_buf operator++(int)
    { 
      slot_iterator_buf __tmp(*this);
      ++i_;
      invoked_ = false;
      return __tmp;
    }

  slot_iterator_buf& operator--()
    {
      --i_;
      invoked_ = false;
      return *this;
    }

  slot_iterator_buf& operator--(int)
    {
      slot_iterator_buf __tmp(*this);
      --i_;
      invoked_ = false;
      return __tmp;
    }

  bool operator == (const slot_iterator_buf& other) const
    { return i_ == other.i_; }

  bool operator != (const slot_iterator_buf& other) const
    { return i_ != other.i_; }

  private:
    iterator_type i_;
    const emitter_type& c_;
    mutable result_type r_;
    mutable bool invoked_;
};

/** Template specialization of slot_iterator_buf for void return signals.
 *
 * @ingroup signal
 */
template <class T_emitter>
struct slot_iterator_buf<T_emitter, void>
{
  typedef size_t                           size_type;
  typedef ptrdiff_t                        difference_type;
  typedef std::bidirectional_iterator_tag  iterator_category;

  typedef T_emitter                        emitter_type;
  typedef void                             result_type;
  typedef typename T_emitter::slot_type slot_type;

  typedef typename std::list<functor::internal::slot_base>::const_iterator iterator_type;

  slot_iterator_buf(const iterator_type& i, const emitter_type& c)
    : i_(i), c_(c), invoked_(false) {}

  void operator*() const
    {
      if (!i_->empty_or_blocked() && !invoked_)
        {
          c_(static_cast<const slot_type&>(*i_));
          invoked_ = true;
        }
    }

  slot_iterator_buf& operator++()
    {
      ++i_;
      invoked_ = false;
      return *this;
    }

  slot_iterator_buf operator++(int)
    { 
      slot_iterator_buf __tmp(*this);
      ++i_;
      invoked_ = false;
      return __tmp;
    }

  slot_iterator_buf& operator--()
    {
      --i_;
      invoked_ = false;
      return *this;
    }

  slot_iterator_buf& operator--(int)
    {
      slot_iterator_buf __tmp(*this);
      --i_;
      invoked_ = false;
      return __tmp;
    }

  bool operator == (const slot_iterator_buf& other) const
    { return i_ == other.i_; }

  bool operator != (const slot_iterator_buf& other) const
    { return i_ != other.i_; }

  private:
    iterator_type i_;
    const emitter_type& c_;
    mutable bool invoked_;
};

FOR(0,CALL_SIZE,[[SIGNAL_EMIT_N(%1)]])

} /* namespace internal */

FOR(0,CALL_SIZE,[[SIGNAL_N(%1)]])

SIGNAL(CALL_SIZE,CALL_SIZE)
FOR(0,eval(CALL_SIZE-1),[[SIGNAL(%1)]])

} /* namespace sigc */

#endif /* _SIGC_SIGNAL_H_ */
