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

#include <sigc++/scoped_connection.h>
#include <utility>

namespace sigc
{

// All we are doing is assigning weak_raw_ptr, which is noexcept, so declare it.
// connectionʼs copy operators can be noexcept for that reason, if breaking ABI.
scoped_connection::scoped_connection(connection c) noexcept
: conn_(std::move(c))
{
}

scoped_connection&
scoped_connection::operator=(connection c)
{
  conn_.disconnect();
  conn_ = std::move(c);
  return *this;
}

// We do not implement move-ctor in terms of move-assign, so we can be noexcept,
// as we do not need to call the maybe-throwing disconnect() for obvious reason.
scoped_connection::scoped_connection(scoped_connection&& sc) noexcept
: conn_(std::exchange(sc.conn_, connection()))
{
}

scoped_connection&
scoped_connection::operator=(scoped_connection&& sc)
{
  conn_.disconnect();
  conn_ = std::exchange(sc.conn_, connection());
  return *this;
}

scoped_connection::~scoped_connection()
{
  conn_.disconnect();
}

bool
scoped_connection::empty() const noexcept
{
  return conn_.empty();
}

bool
scoped_connection::connected() const noexcept
{
  return conn_.connected();
}

bool
scoped_connection::blocked() const noexcept
{
  return conn_.blocked();
}

bool
scoped_connection::block(bool should_block) noexcept
{
  return conn_.block(should_block);
}

bool
scoped_connection::unblock() noexcept
{
  return conn_.unblock();
}

void
scoped_connection::disconnect()
{
  conn_.disconnect();
}

scoped_connection::operator bool() const noexcept
{
  return conn_.operator bool();
}

// Swapping can be noexcept, as it does not need to disconnect either connection
// because they will still stay alive, just in opposite instances post-swapping.
void
swap(scoped_connection& sca, scoped_connection& scb) noexcept
{
  using std::swap;
  swap(sca.conn_, scb.conn_);
}

connection
scoped_connection::release() noexcept
{
  return std::exchange(conn_, connection());
}

} /* namespace sigc */
