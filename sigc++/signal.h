/*
 * Copyright 2002-2016, The libsigc++ Development Team
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

#ifndef _SIGC_SIGNAL_H_
#define _SIGC_SIGNAL_H_

#include <list>
#include <sigc++/signal_base.h>
#include <sigc++/type_traits.h>
#include <sigc++/trackable.h>
#include <sigc++/functors/slot.h>
#include <sigc++/functors/mem_fun.h>
#include <tuple>
#include <utility>

namespace sigc
{

/** STL-style iterator for slot_list.
 *
 * @ingroup signal
 */
template <typename T_slot>
struct slot_iterator
{
  using size_type = std::size_t;
  using difference_type = std::ptrdiff_t;
  using iterator_category = std::bidirectional_iterator_tag;

  using slot_type = T_slot;

  using value_type = T_slot;
  using pointer = T_slot*;
  using reference = T_slot&;

  using iterator_type = typename internal::signal_impl::iterator_type;

  slot_iterator() = default;

  explicit slot_iterator(const iterator_type& i) : i_(i) {}

  reference operator*() const { return static_cast<reference>(*i_); }

  pointer operator->() const { return &(operator*()); }

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

  slot_iterator operator--(int)
  {
    slot_iterator __tmp(*this);
    --i_;
    return __tmp;
  }

  bool operator==(const slot_iterator& other) const { return i_ == other.i_; }

  bool operator!=(const slot_iterator& other) const { return i_ != other.i_; }

  iterator_type i_;
};

/** STL-style const iterator for slot_list.
 *
 * @ingroup signal
 */
template <typename T_slot>
struct slot_const_iterator
{
  using size_type = std::size_t;
  using difference_type = std::ptrdiff_t;
  using iterator_category = std::bidirectional_iterator_tag;

  using slot_type = T_slot;

  using value_type = T_slot;
  using pointer = const T_slot*;
  using reference = const T_slot&;

  using iterator_type = typename internal::signal_impl::const_iterator_type;

  slot_const_iterator() = default;

  explicit slot_const_iterator(const iterator_type& i) : i_(i) {}

  reference operator*() const { return static_cast<reference>(*i_); }

  pointer operator->() const { return &(operator*()); }

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

  slot_const_iterator operator--(int)
  {
    slot_const_iterator __tmp(*this);
    --i_;
    return __tmp;
  }

  bool operator==(const slot_const_iterator& other) const { return i_ == other.i_; }

  bool operator!=(const slot_const_iterator& other) const { return i_ != other.i_; }

  iterator_type i_;
};

/** STL-style list interface for sigc::signal#.
 * slot_list can be used to iterate over the list of slots that
 * is managed by a signal. Slots can be added or removed from
 * the list while existing iterators stay valid. A slot_list
 * object can be retrieved from the signal's slots() function.
 *
 * @ingroup signal
 */
template <typename T_slot>
struct slot_list
{
  using slot_type = T_slot;

  using reference = slot_type&;
  using const_reference = const slot_type&;

  using iterator = slot_iterator<slot_type>;
  using const_iterator = slot_const_iterator<slot_type>;

  using reverse_iterator = std::reverse_iterator<iterator>;
  using const_reverse_iterator = std::reverse_iterator<const_iterator>;

  slot_list() : list_(nullptr) {}

  explicit slot_list(internal::signal_impl* __list) : list_(__list) {}

  iterator begin() { return iterator(list_->slots_.begin()); }

  const_iterator begin() const { return const_iterator(list_->slots_.begin()); }

  iterator end() { return iterator(list_->slots_.end()); }

  const_iterator end() const { return const_iterator(list_->slots_.end()); }

  reverse_iterator rbegin() { return reverse_iterator(end()); }

  const_reverse_iterator rbegin() const { return const_reverse_iterator(end()); }

  reverse_iterator rend() { return reverse_iterator(begin()); }

  const_reverse_iterator rend() const { return const_reverse_iterator(begin()); }

  reference front() { return *begin(); }

  const_reference front() const { return *begin(); }

  reference back() { return *(--end()); }

  const_reference back() const { return *(--end()); }

  iterator insert(iterator i, const slot_type& slot_)
  {
    return iterator(list_->insert(i.i_, static_cast<const slot_base&>(slot_)));
  }

  iterator insert(iterator i, slot_type&& slot_)
  {
    return iterator(list_->insert(i.i_, std::move(static_cast<slot_base&>(slot_))));
  }

  void push_front(const slot_type& c) { insert(begin(), c); }

  void push_front(slot_type&& c) { insert(begin(), std::move(c)); }

  void push_back(const slot_type& c) { insert(end(), c); }

  void push_back(slot_type&& c) { insert(end(), std::move(c)); }

  iterator erase(iterator i) { return iterator(list_->erase(i.i_)); }

  iterator erase(iterator first_, iterator last_)
  {
    while (first_ != last_)
      first_ = erase(first_);
    return last_;
  }

  void pop_front() { erase(begin()); }

  void pop_back()
  {
    auto tmp_ = end();
    erase(--tmp_);
  }

private:
  internal::signal_impl* list_;
};

namespace internal
{

/** Special iterator over sigc::internal::signal_impl's slot list that holds extra data.
 * This iterators is for use in accumulators. operator*() executes
 * the slot. The return value is buffered, so that in an expression
 * like @code a = (*i) * (*i); @endcode the slot is executed only once.
 */
template <typename T_emitter, typename T_result = typename T_emitter::result_type>
struct slot_iterator_buf
{
  using size_type = std::size_t;
  using difference_type = std::ptrdiff_t;
  using iterator_category = std::bidirectional_iterator_tag;

  // These are needed just to make this a proper C++ iterator,
  // that can be used with standard C++ algorithms.
  using value_type = T_result;
  using reference = T_result&;
  using pointer = T_result*;

  using emitter_type = T_emitter;
  using slot_type = typename T_emitter::slot_type;

  using iterator_type = signal_impl::const_iterator_type;

  slot_iterator_buf() : c_(nullptr), invoked_(false) {}

  slot_iterator_buf(const iterator_type& i, const emitter_type* c) : i_(i), c_(c), invoked_(false)
  {
  }

  decltype(auto) operator*() const
  {
    if (!i_->empty() && !i_->blocked() && !invoked_)
    {
      r_ = (*c_)(static_cast<const slot_type&>(*i_));
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

  slot_iterator_buf operator--(int)
  {
    slot_iterator_buf __tmp(*this);
    --i_;
    invoked_ = false;
    return __tmp;
  }

  bool operator==(const slot_iterator_buf& other) const
  {
    return (!c_ || (i_ == other.i_));
  } /* If '!c_' the iterators are empty.
     * Unfortunately, empty stl iterators are not equal.
     * We are forcing equality so that 'first==last'
     * in the accumulator's emit function yields true. */

  bool operator!=(const slot_iterator_buf& other) const { return (c_ && (i_ != other.i_)); }

private:
  iterator_type i_;
  const emitter_type* c_;
  mutable T_result r_;
  mutable bool invoked_;
};

/** Template specialization of slot_iterator_buf for void return signals.
 */
template <typename T_emitter>
struct slot_iterator_buf<T_emitter, void>
{
  using size_type = std::size_t;
  using difference_type = std::ptrdiff_t;
  using iterator_category = std::bidirectional_iterator_tag;

  using emitter_type = T_emitter;
  using slot_type = typename T_emitter::slot_type;

  using iterator_type = signal_impl::const_iterator_type;

  slot_iterator_buf() : c_(nullptr), invoked_(false) {}

  slot_iterator_buf(const iterator_type& i, const emitter_type* c) : i_(i), c_(c), invoked_(false)
  {
  }

  void operator*() const
  {
    if (!i_->empty() && !i_->blocked() && !invoked_)
    {
      (*c_)(static_cast<const slot_type&>(*i_));
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

  slot_iterator_buf operator--(int)
  {
    slot_iterator_buf __tmp(*this);
    --i_;
    invoked_ = false;
    return __tmp;
  }

  bool operator==(const slot_iterator_buf& other) const { return i_ == other.i_; }

  bool operator!=(const slot_iterator_buf& other) const { return i_ != other.i_; }

private:
  iterator_type i_;
  const emitter_type* c_;
  mutable bool invoked_;
};

/** Reverse version of sigc::internal::slot_iterator_buf. */
template <typename T_emitter, typename T_result = typename T_emitter::result_type>
struct slot_reverse_iterator_buf
{
  using size_type = std::size_t;
  using difference_type = std::ptrdiff_t;
  using iterator_category = std::bidirectional_iterator_tag;

  // These are needed just to make this a proper C++ iterator,
  // that can be used with standard C++ algorithms.
  using value_type = T_result;
  using reference = T_result&;
  using pointer = T_result*;

  using emitter_type = T_emitter;
  using slot_type = typename T_emitter::slot_type;

  using iterator_type = signal_impl::const_iterator_type;

  slot_reverse_iterator_buf() : c_(nullptr), invoked_(false) {}

  slot_reverse_iterator_buf(const iterator_type& i, const emitter_type* c)
  : i_(i), c_(c), invoked_(false)
  {
  }

  decltype(auto) operator*() const
  {
    auto __tmp(i_);
    --__tmp;
    if (!__tmp->empty() && !__tmp->blocked() && !invoked_)
    {
      r_ = (*c_)(static_cast<const slot_type&>(*__tmp));
      invoked_ = true;
    }
    return r_;
  }

  slot_reverse_iterator_buf& operator++()
  {
    --i_;
    invoked_ = false;
    return *this;
  }

  slot_reverse_iterator_buf operator++(int)
  {
    slot_reverse_iterator_buf __tmp(*this);
    --i_;
    invoked_ = false;
    return __tmp;
  }

  slot_reverse_iterator_buf& operator--()
  {
    ++i_;
    invoked_ = false;
    return *this;
  }

  slot_reverse_iterator_buf operator--(int)
  {
    slot_reverse_iterator_buf __tmp(*this);
    ++i_;
    invoked_ = false;
    return __tmp;
  }

  bool operator==(const slot_reverse_iterator_buf& other) const
  {
    return (!c_ || (i_ == other.i_));
  } /* If '!c_' the iterators are empty.
     * Unfortunately, empty stl iterators are not equal.
     * We are forcing equality so that 'first==last'
     * in the accumulator's emit function yields true. */

  bool operator!=(const slot_reverse_iterator_buf& other) const { return (c_ && (i_ != other.i_)); }

private:
  iterator_type i_;
  const emitter_type* c_;
  mutable T_result r_;
  mutable bool invoked_;
};

/** Template specialization of slot_reverse_iterator_buf for void return signals.
 */
template <typename T_emitter>
struct slot_reverse_iterator_buf<T_emitter, void>
{
  using size_type = std::size_t;
  using difference_type = std::ptrdiff_t;
  using iterator_category = std::bidirectional_iterator_tag;

  using emitter_type = T_emitter;
  using slot_type = typename T_emitter::slot_type;

  using iterator_type = signal_impl::const_iterator_type;

  slot_reverse_iterator_buf() : c_(nullptr), invoked_(false) {}

  slot_reverse_iterator_buf(const iterator_type& i, const emitter_type* c)
  : i_(i), c_(c), invoked_(false)
  {
  }

  void operator*() const
  {
    auto __tmp(i_);
    --__tmp;
    if (!__tmp->empty() && !__tmp->blocked() && !invoked_)
    {
      (*c_)(static_cast<const slot_type&>(*__tmp));
      invoked_ = true;
    }
  }

  slot_reverse_iterator_buf& operator++()
  {
    --i_;
    invoked_ = false;
    return *this;
  }

  slot_reverse_iterator_buf operator++(int)
  {
    slot_reverse_iterator_buf __tmp(*this);
    --i_;
    invoked_ = false;
    return __tmp;
  }

  slot_reverse_iterator_buf& operator--()
  {
    ++i_;
    invoked_ = false;
    return *this;
  }

  slot_reverse_iterator_buf operator--(int)
  {
    slot_reverse_iterator_buf __tmp(*this);
    ++i_;
    invoked_ = false;
    return __tmp;
  }

  bool operator==(const slot_reverse_iterator_buf& other) const { return i_ == other.i_; }

  bool operator!=(const slot_reverse_iterator_buf& other) const { return i_ != other.i_; }

private:
  iterator_type i_;
  const emitter_type* c_;
  mutable bool invoked_;
};

/** Temporary slot list used during signal emission.
 *  Through evolution this class is slightly misnamed.  It is now
 *  an index into the slot_list passed into it.  It simply keeps track
 *  of where the end of this list was at construction, and pretends that's
 *  the end of your list.  This way you may connect during emission without
 *  inadvertently entering an infinite loop, as well as make other
 *  modifications to the slot_list at your own risk.
 */
struct temp_slot_list
{
  using slot_list = signal_impl::slot_list;
  using iterator = signal_impl::iterator_type;
  using const_iterator = signal_impl::const_iterator_type;

  temp_slot_list(slot_list& slots) : slots_(slots)
  {
    placeholder = slots_.insert(slots_.end(), slot_base());
  }

  ~temp_slot_list() { slots_.erase(placeholder); }

  iterator begin() { return slots_.begin(); }
  iterator end() { return placeholder; }
  const_iterator begin() const { return slots_.begin(); }
  const_iterator end() const { return placeholder; }

private:
  slot_list& slots_;
  slot_list::iterator placeholder;
};

/** Abstracts signal emission.
 * This template implements the emit() function of signal_with_accumulator.
 * Template specializations are available to optimize signal
 * emission when no accumulator is used, for example when the template
 * argument @e T_accumulator is @p void.
 */
template <typename T_return, typename T_accumulator, typename... T_arg>
struct signal_emit
{
  using self_type = signal_emit<T_return, T_accumulator, T_arg...>;
  using slot_type = slot<T_return(T_arg...)>;
  using slot_iterator_buf_type = internal::slot_iterator_buf<self_type, T_return>;
  using slot_reverse_iterator_buf_type = internal::slot_reverse_iterator_buf<self_type, T_return>;
  using iterator_type = signal_impl::const_iterator_type;

  /** Instantiates the class.
   * The parameters are stored in member variables. operator()() passes
   * the values on to some slot.
   */
  signal_emit(type_trait_take_t<T_arg>... _A_a) : _A_a_(_A_a...) {}

  /** Invokes a slot using the buffered parameter values.
   * @param _A_slot Some slot to invoke.
   * @return The slot's return value.
   */
  T_return operator()(const slot_type& _A_slot) const
  {
    const auto seq = std::make_index_sequence<std::tuple_size<decltype(_A_a_)>::value>();
    return call_call_type_operator_parentheses_with_tuple(_A_slot, _A_a_, seq);
  }

  /** Executes a list of slots using an accumulator of type @e T_accumulator.
   * The arguments are buffered in a temporary instance of signal_emit.
   * @param _A_a Arguments to be passed on to the slots.
   * @return The accumulated return values of the slot invocations as processed by the accumulator.
   */
  static decltype(auto) emit(signal_impl* impl, type_trait_take_t<T_arg>... _A_a)
  {
    T_accumulator accumulator;

    if (!impl)
      return accumulator(slot_iterator_buf_type(), slot_iterator_buf_type());

    signal_exec exec(impl);
    temp_slot_list slots(impl->slots_);

    self_type self(_A_a...);
    return accumulator(
      slot_iterator_buf_type(slots.begin(), &self), slot_iterator_buf_type(slots.end(), &self));
  }

  /** Executes a list of slots using an accumulator of type @e T_accumulator in reverse order.   *
   * The arguments are buffered in a temporary instance of signal_emit.
   * @param _A_a Arguments to be passed on to the slots.
   * @return The accumulated return values of the slot invocations as processed by the accumulator.
   */
  static decltype(auto) emit_reverse(signal_impl* impl, type_trait_take_t<T_arg>... _A_a)
  {
    T_accumulator accumulator;

    if (!impl)
      return accumulator(slot_iterator_buf_type(), slot_iterator_buf_type());

    signal_exec exec(impl);
    temp_slot_list slots(impl->slots_);

    self_type self(_A_a...);
    return accumulator(slot_reverse_iterator_buf_type(slots.end(), &self),
      slot_reverse_iterator_buf_type(slots.begin(), &self));
  }

  std::tuple<type_trait_take_t<T_arg>...> _A_a_;

private:
  // TODO_variadic: Replace this with std::experimental::apply() if that becomes standard
  // C++, or add our own implementation, to avoid code duplication.
  template <std::size_t... Is>
  decltype(auto) call_call_type_operator_parentheses_with_tuple(
    const slot_type& _A_slot, const std::tuple<T_arg...>& tuple, std::index_sequence<Is...>) const
  {
    return (_A_slot)(std::get<Is>(tuple)...);
  }
};

/** Abstracts signal emission.
 * This template specialization implements an optimized emit()
 * function for the case that no accumulator is used.
 */
template <typename T_return, typename... T_arg>
struct signal_emit<T_return, void, T_arg...>
{
private:
  using slot_type = slot<T_return(T_arg...)>;
  using call_type = typename slot_type::call_type;

public:

  /** Executes a list of slots.
   * The arguments are passed directly on to the slots.
   * The return value of the last slot invoked is returned.
   * @param first An iterator pointing to the first slot in the list.
   * @param last An iterator pointing to the last slot in the list.   * @param _A_a Arguments to be
   * passed on to the slots.
   * @return The return value of the last slot invoked.
   */
  static decltype(auto) emit(signal_impl* impl, type_trait_take_t<T_arg>... _A_a)
  {
    if (!impl || impl->slots_.empty())
      return T_return();

    signal_exec exec(impl);
    T_return r_ = T_return();

    // Use this scope to make sure that "slots" is destroyed before "exec" is destroyed.
    // This avoids a leak on MSVC++ - see http://bugzilla.gnome.org/show_bug.cgi?id=306249
    {
      temp_slot_list slots(impl->slots_);
      auto it = slots.begin();
      for (; it != slots.end(); ++it)
      {
        if (!it->empty() && !it->blocked())
          break;
      }

      if (it == slots.end())
      {
        // note that 'T_return r_();' doesn't work => define 'r_' after this line
        // and initialize as follows:
        return T_return();
      }

      r_ = (reinterpret_cast<call_type>(it->rep_->call_))(it->rep_, _A_a...);
      for (++it; it != slots.end(); ++it)
      {
        if (it->empty() || it->blocked())
          continue;
        r_ = (reinterpret_cast<call_type>(it->rep_->call_))(it->rep_, _A_a...);
      }
    }

    return r_;
  }

  /** Executes a list of slots using an accumulator of type @e T_accumulator in reverse order.
   * The arguments are passed directly on to the slots.
   * @param _A_a%1 Argument to be passed on to the slots.
   * @return The return value of the last slot invoked.
   */
  static decltype(auto) emit_reverse(signal_impl* impl, type_trait_take_t<T_arg>... _A_a)
  {
    if (!impl || impl->slots_.empty())
      return T_return();

    signal_exec exec(impl);
    T_return r_ = T_return();

    // Use this scope to make sure that "slots" is destroyed before "exec" is destroyed.
    // This avoids a leak on MSVC++ - see http://bugzilla.gnome.org/show_bug.cgi?id=306249
    {
      using reverse_iterator_type = std::reverse_iterator<signal_impl::iterator_type>;

      temp_slot_list slots(impl->slots_);
      reverse_iterator_type it(slots.end());
      for (; it != reverse_iterator_type(slots.begin()); ++it)
      {
        if (!it->empty() && !it->blocked())
          break;
      }

      if (it == reverse_iterator_type(slots.begin()))
      {
        // note that 'T_return r_();' doesn't work => define 'r_' after this line
        // and initialize as follows:
        return T_return();
      }

      r_ = (reinterpret_cast<call_type>(it->rep_->call_))(it->rep_, _A_a...);
      for (++it; it != reverse_iterator_type(slots.begin()); ++it)
      {
        if (it->empty() || it->blocked())
          continue;
        r_ = (reinterpret_cast<call_type>(it->rep_->call_))(it->rep_, _A_a...);
      }
    }

    return r_;
  }
};

/** Abstracts signal emission.
 * This template specialization implements an optimized emit()
 * function for the case that no accumulator is used and the
 * return type is @p void.
 */
template <typename... T_arg>
struct signal_emit<void, void, T_arg...>
{
private:
  using slot_type = slot<void(T_arg...)>;
  using call_type = typename slot_type::call_type;

public:

  /** Executes a list of slots using an accumulator of type @e T_accumulator.   * The arguments are
   * passed directly on to the slots.
   * @param _A_a Arguments to be passed on to the slots.
   */
  static decltype(auto) emit(signal_impl* impl, type_trait_take_t<T_arg>... _A_a)
  {
    if (!impl || impl->slots_.empty())
      return;
    signal_exec exec(impl);
    temp_slot_list slots(impl->slots_);

    for (const auto& slot : slots)
    {
      if (slot.empty() || slot.blocked())
        continue;

      (reinterpret_cast<call_type>(slot.rep_->call_))(slot.rep_, _A_a...);
    }
  }

  /** Executes a list of slots using an accumulator of type @e T_accumulator in reverse order.   *
   * The arguments are passed directly on to the slots.
   * @param first An iterator pointing to the first slot in the list.
   * @param last An iterator pointing to the last slot in the list.   * @param _A_a Arguments to be
   * passed on to the slots.
   */
  static decltype(auto) emit_reverse(signal_impl* impl, type_trait_take_t<T_arg>... _A_a)
  {
    if (!impl || impl->slots_.empty())
      return;
    signal_exec exec(impl);
    temp_slot_list slots(impl->slots_);

    using reverse_iterator_type = std::reverse_iterator<signal_impl::iterator_type>;

    for (auto it = reverse_iterator_type(slots.end());
         it != reverse_iterator_type(slots.begin()); ++it)
    {
      if (it->empty() || it->blocked())
        continue;
      (reinterpret_cast<call_type>(it->rep_->call_))(it->rep_, _A_a...);
    }
  }
};

} /* namespace internal */

/** Signal declaration.
 * signal_with_accumulator can be used to connect() slots that are invoked
 * during subsequent calls to emit(). Any functor or slot
 * can be passed into connect(). It is converted into a slot
 * implicitly.
 *
 * If you want to connect one signal to another, use make_slot()
 * to retrieve a functor that emits the signal when invoked.
 *
 * Be careful if you directly pass one signal into the connect()
 * method of another: a shallow copy of the signal is made and
 * the signal's slots are not disconnected until both the signal
 * and its clone are destroyed, which is probably not what you want!
 *
 * An STL-style list interface for the signal's list of slots
 * can be retrieved with slots(). This interface supports
 * iteration, insertion and removal of slots.
 *
 * The following template arguments are used:
 * - @e T_return The desired return type for the emit() function (may be overridden by the
 * accumulator). * - @e T_arg Argument types used in the definition of emit().
 * - @e T_accumulator The accumulator type used for emission. The default
 * @p void means that no accumulator should be used, for example if signal
 * emission returns the return value of the last slot invoked.
 *
 * @ingroup signal
 */
template <typename T_return, typename T_accumulator, typename... T_arg>
class signal_with_accumulator : public signal_base
{
public:
  using emitter_type = internal::signal_emit<T_return, T_accumulator, T_arg...>;
  using slot_type = slot<T_return(T_arg...)>;
  using slot_list_type = slot_list<slot_type>;
  using iterator = typename slot_list_type::iterator;
  //TODO: Test these? These type aliases are currently unused in libsigc++ or its tests:
  using const_iterator = typename slot_list_type::const_iterator;
  using reverse_iterator = typename slot_list_type::reverse_iterator;
  using const_reverse_iterator = typename slot_list_type::const_reverse_iterator;

  /** Add a slot to the list of slots.
   * Any functor or slot may be passed into connect().
   * It will be converted into a slot implicitly.
   * The returned iterator may be stored for disconnection
   * of the slot at some later point. It stays valid until
   * the slot is removed from the list of slots. The iterator
   * can also be implicitly converted into a sigc::connection object
   * that may be used safely beyond the life time of the slot.
   *
   * std::function<> and C++11 lambda expressions are functors.
   * These are examples of functors that can be connected to a signal.
   *
   * %std::bind() creates a functor, but this functor typically has an
   * %operator()() which is a variadic template.
   * Our functor_trait can't deduce the result type
   * of such a functor. If you first assign the return value of %std::bind()
   * to a std::function, you can connect the std::function to a signal.
   *
   * @param slot_ The slot to add to the list of slots.
   * @return An iterator pointing to the new slot in the list.
   */
  iterator connect(const slot_type& slot_)
  {
    return iterator(signal_base::connect(static_cast<const slot_base&>(slot_)));
  }

  /** Add a slot to the list of slots.
   * @see connect(const slot_type& slot_).
   *
   * @newin{2,8}
   */
  iterator connect(slot_type&& slot_)
  {
    return iterator(signal_base::connect(std::move(static_cast<slot_base&>(slot_))));
  }

  /** Triggers the emission of the signal.
   * During signal emission all slots that have been connected
   * to the signal are invoked unless they are manually set into
   * a blocking state. The parameters are passed on to the slots.
   * If @e T_accumulated is not @p void, an accumulator of this type
   * is used to process the return values of the slot invocations.
   * Otherwise, the return value of the last slot invoked is returned.
   * @param _A_a Arguments to be passed on to the slots.
   * @return The accumulated return values of the slot invocations.
   */
  decltype(auto) emit(type_trait_take_t<T_arg>... _A_a) const
  {
    return emitter_type::emit(impl_, _A_a...);
  }

  /** Triggers the emission of the signal in reverse order (see emit()). */
  decltype(auto) emit_reverse(type_trait_take_t<T_arg>... _A_a) const
  {
    return emitter_type::emit_reverse(impl_, _A_a...);
  }

  /** Triggers the emission of the signal (see emit()). */
  decltype(auto) operator()(type_trait_take_t<T_arg>... _A_a) const { return emit(_A_a...); }

  /** Creates a functor that calls emit() on this signal.
   * @code
   * sigc::mem_fun(mysignal, &sigc::signal_with_accumulator::emit)
   * @endcode
   * yields the same result.
   * @return A functor that calls emit() on this signal.
   */
  decltype(auto) make_slot() const
  {
    //TODO: Instead use std::result_of<> on the static emitter_type::emit()
    using result_type = typename internal::member_method_result<decltype(&signal_with_accumulator::emit)>::type;
    return bound_mem_functor<result_type (signal_with_accumulator::*)(type_trait_take_t<T_arg>...)
                               const,
      type_trait_take_t<T_arg>...>(*this, &signal_with_accumulator::emit);
  }

  /** Creates an STL-style interface for the signal's list of slots.
   * This interface supports iteration, insertion and removal of slots.
   * @return An STL-style interface for the signal's list of slots.
   */
  slot_list_type slots() { return slot_list_type(impl()); }

  /** Creates an STL-style interface for the signal's list of slots.
   * This interface supports iteration, insertion and removal of slots.
   * @return An STL-style interface for the signal's list of slots.
   */
  const slot_list_type slots() const
  {
    return slot_list_type(const_cast<signal_with_accumulator*>(this)->impl());
  }

  signal_with_accumulator() = default;

  signal_with_accumulator(const signal_with_accumulator& src) : signal_base(src) {}

  signal_with_accumulator(signal_with_accumulator&& src) : signal_base(std::move(src)) {}

  signal_with_accumulator& operator=(const signal_with_accumulator& src)
  {
    signal_base::operator=(src);
    return *this;
  }

  signal_with_accumulator& operator=(signal_with_accumulator&& src)
  {
    signal_base::operator=(std::move(src));
    return *this;
  }
};

/** signal can be used to connect() slots that are invoked
 * during subsequent calls to emit(). Any functor or slot
 * can be passed into connect(). It is converted into a slot
 * implicitly.
 *
 * If you want to connect one signal to another, use make_slot()
 * to retrieve a functor that emits the signal when invoked.
 *
 * Be careful if you directly pass one signal into the connect()
 * method of another: a shallow copy of the signal is made and
 * the signal's slots are not disconnected until both the signal
 * and its clone are destroyed, which is probably not what you want!
 *
 * An STL-style list interface for the signal's list of slots
 * can be retrieved with slots(). This interface supports
 * iteration, insertion and removal of slots.
 *
 * The template arguments determine the function signature of
 * the emit() function:
 * - @e T_return The desired return type of the emit() function. * - @e T_arg Argument types used in
 * the definition of emit().
 *
 * For instance, to declare a signal whose connected slot returns void and takes
 * two parameters of bool and int:
 * @code
 * sigc::signal<void(bool, int)> some_signal;
 * @endcode
 *
 * To specify an accumulator type the nested class signal::accumulated can be used.
 *
 * @par Example:
 * @code
 * void foo(int) {}
 * sigc::signal<void, long> sig;
 * sig.connect(sigc::ptr_fun(&foo));
 * sig.emit(19);
 * @endcode
 *
 * @ingroup signal
 */
template <typename T_return, typename... T_arg>
class signal;

template <typename T_return, typename... T_arg>
class signal<T_return(T_arg...)> : public signal_with_accumulator<T_return, void, T_arg...>
{
public:
  using accumulator_type = void;

  /** Like sigc::signal but the additional template parameter @e T_accumulator
   * defines the accumulator type that should be used.
   *
   * An accumulator is a functor that uses a pair of special iterators
   * to step through a list of slots and calculate a return value
   * from the results of the slot invokations. The iterators' operator*()
   * executes the slot. The return value is buffered, so that in an expression
   * like @code a = (*i) * (*i); @endcode the slot is executed only once.
   *
   * @par Example 1:
   * This accumulator calculates the arithmetic mean value:
   * @code
   * struct arithmetic_mean_accumulator
   * {
   *   template<typename T_iterator>
   *   double operator()(T_iterator first, T_iterator last) const
   *   {
   *     double value_ = 0;
   *     int n_ = 0;
   *     for (; first != last; ++first, ++n_)
   *       value_ += *first;
   *     return value_ / n_;
   *   }
   * };
   * @endcode
   *
   * @par Example 2:
   * This accumulator stops signal emission when a slot returns zero:
   * @code
   * struct interruptable_accumulator
   * {
   *   template<typename T_iterator>
   *   bool operator()(T_iterator first, T_iterator last) const
   *   {
   *     for (; first != last; ++first, ++n_)
   *       if (!*first) return false;
   *     return true;
   *   }
   * };
   * @endcode
   *
   * @ingroup signal
   */
  template <typename T_accumulator>
  class accumulated : public signal_with_accumulator<T_return, T_accumulator, T_arg...>
  {
  public:
    accumulated() = default;
    accumulated(const accumulated& src)
    : signal_with_accumulator<T_return, T_accumulator, T_arg...>(src)
    {
    }
  };

  signal() = default;

  signal(const signal& src) : signal_with_accumulator<T_return, accumulator_type, T_arg...>(src) {}

  signal(signal&& src)
  : signal_with_accumulator<T_return, accumulator_type, T_arg...>(std::move(src))
  {
  }

  signal& operator=(const signal& src)
  {
    signal_with_accumulator<T_return, accumulator_type, T_arg...>::operator=(src);
    return *this;
  }

  signal& operator=(signal&& src)
  {
    signal_with_accumulator<T_return, accumulator_type, T_arg...>::operator=(std::move(src));
    return *this;
  }
};

} /* namespace sigc */

#endif /* _SIGC_SIGNAL_H_ */
