/*
 * Copyright 2023, The libsigc++ Development Team
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

#ifndef SIGC_SCOPED_CONNECTION_HPP
#define SIGC_SCOPED_CONNECTION_HPP

#include <sigc++/connection.h>

namespace sigc
{

/** Convenience class for safe disconnection, including automatic disconnection
 * upon destruction.
 *
 * This is a variant of @ref sigc::connection which also disconnect()s the slot
 * automatically when the scoped_connection is destructed or re-assigned. Refer
 * to @ref sigc::connection for full information about the common functionality.
 *
 * You will use sigc::scoped_connection by constructing it from a ‘normal’,
 * unscoped @ref sigc::connection, such as those returned by 
 * @ref sigc::signal_with_accumulator::connect() "sigc::signal::connect()" and
 * @ref sigc::signal_with_accumulator::connect_first() "sigc::signal::connect_first()",
 * thus ‘wrapping’ the connection in a scoped_connection, adding auto-disconnection.
 * It can also be assigned from an unscoped connection, in which case, if there
 * was a previous slot referred to by the scoped connection, it is disconnected.
 *
 * Once a connection is scoped, it canʼt be copied as that would make it unclear
 * which of the copies would hold responsibility to auto-disconnect the slot. It
 * can, however, be moved, so itʼs usable in containers or so ‘ownership’ of the
 * connection/auto-disconnect can be moved to another instance. Moving from the
 * scoped_connection clears its reference to the slot so it wonʼt disconnect it.
 *
 * If you want a reference-counted scoped_connection, wrap in a std::shared_ptr.
 *
 * @code
 * // Automatic disconnection:
 * {
 *   sigc::scoped_connection sconn = sig.connect(&some_function);
 *   // Do stuff that requires the slot to be connected & called.
 * }
 * // The scoped_connection was destroyed, so the slot is no longer connected.
 *
 * // ***
 *
 * // Moving ownership:
 * {
 *   sigc::scoped_connection sconn = sig.connect(&some_function);
 *   // Do stuff that requires the slot to be connected & called.
 *   take_ownership(std::move(sconn)); // Pass by rvalue.
 * }
 * // Now our `sconn` no longer referred to slot, so it did NOT auto-disconnect.
 *
 * // ***
 *
 * // Shared ownership:
 * {
 *   auto shconn = std::make_shared<sigc::scoped_connection>(sig.connect(&some_function));
 *   take_copy(shconn); // Pass by copy/value
 *   // Now we AND take_copy() must destroy our shared_ptr to auto-disconnect().
 * }
 * // take_copy() may still hold a shared_ptr reference, keeping the slot alive.
 * @endcode
 *
 * @ingroup signal
 * @newin{3,6}
 */
struct SIGC_API scoped_connection final
{
  /** Constructs an empty scoped connection object. */
  scoped_connection() noexcept = default;

  /** Constructs a scoped connection object from an unscoped connection object.
   * The source connection still refers to the slot and can manually disconnect.
   * @param c The connection object to make a copy from, whose slot weʼll
   *   automatically disconnect when the scoped_connection object is destroyed.
   */
  scoped_connection(connection c) noexcept;

  /** Overrides this scoped connection object copying an unscoped connection.
   * The current slot, if any, will be disconnect()ed before being replaced.
   * The source connection still refers to the slot and can manually disconnect.
   * @param c The connection object to make a copy from, whose slot weʼll
   *   automatically disconnect when the scoped_connection object is destroyed.
   */
  scoped_connection& operator=(connection c);

  /// scoped_connection canʼt be copied as it would confuse ownership—see intro.
  scoped_connection& operator=(const scoped_connection&) = delete;
  /// scoped_connection canʼt be copied as it would confuse ownership—see intro.
  scoped_connection(const scoped_connection&) = delete;

  /** Constructs a scoped connection object moving an existing one.
   * The source scoped connection will no longer refer to / disconnect the slot.
   * @param sc The scoped connection object to move from.
   */
  scoped_connection(scoped_connection&& sc) noexcept;

  /** Overrides this scoped connection object moving another one.
   * The current slot, if any, will be disconnect()ed before being replaced.
   * The source scoped connection will no longer refer to / disconnect the slot.
   * @param sc The scoped connection object to move from.
   */
  scoped_connection& operator=(scoped_connection&& sc);

  /// Swap two scoped connections.
  friend SIGC_API void swap(scoped_connection& sca, scoped_connection& scb) noexcept;

  /// scoped_connection disconnects the referred slot, if any, upon destruction.
  ~scoped_connection();

  /** Returns whether the connection is still active.
   * @return @p false if the connection is still active.
   */
  bool empty() const noexcept;

  /** Returns whether the connection is still active.
   * @return @p true if the connection is still active.
   */
  bool connected() const noexcept;

  /** Returns whether the connection is blocked.
   * @return @p true if the connection is blocked.
   */
  bool blocked() const noexcept;

  /** Sets or unsets the blocking state of this connection.
   * See slot_base::block() for details.
   * @param should_block Indicates whether the blocking state should be set or unset.
   * @return @p true if the connection has been in blocking state before.
   */
  bool block(bool should_block = true) noexcept;

  /** Unsets the blocking state of this connection.
   * @return @p true if the connection has been in blocking state before.
   */
  bool unblock() noexcept;

  /// Disconnects the referred slot. This will also happen upon destruction.
  void disconnect();

  /** Returns whether the connection is still active.
   * @return @p true if the connection is still active.
   */
  explicit operator bool() const noexcept;

  /** Releases the connection from a scoped connection object.
   * The scoped connection will no longer refer to / disconnect the slot.
   * @return An unscoped connection object referring to the same slot.
   */
  connection release() noexcept;

private:
  sigc::connection conn_;
};

/// Swap two scoped connections.
SIGC_API
void swap(scoped_connection& sca, scoped_connection& scb) noexcept;

} /* namespace sigc */

#endif /* SIGC_SCOPED_CONNECTION_HPP */
