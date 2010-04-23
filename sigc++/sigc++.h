/*
 * Copyright 2003, The libsigc++ Development Team
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

#ifndef SIGCXX_SIGCXX_H
#define SIGCXX_SIGCXX_H

/** @mainpage libsigc++ Reference Manual
 *
 * @section description Description
 *
 * libsigc++ implements a typesafe callback system for standard C++. It allows
 * you to define signals and to connect those signals to any callback function,
 * either a global or a member function, regardless of whether it is static or
 * virtual. It also contains adaptor classes for connection of dissimilar
 * callbacks and has an ease of use unmatched by other C++ callback libraries.
 *
 * For instance, see @ref adaptors "Adaptors", @ref sigcfunctors "Functors",
 * @ref lambdas "Lambdas", @ref signal "Signals" and @ref slot "Slots".
 *
 * See also the libsigc++ website: http://libsigc.sourceforge.net/
 *
 * @section features Features
 *
 * - Compile time typesafe callbacks (faster than run time checks)
 * - Typesafety violations report line number correctly with template names (no
 *   tracing template failures into headers)
 * - No compiler extensions or meta compilers required
 * - Proper handling of dynamic objects and signals (deleted objects will not
 *   cause seg faults)
 * - Extendable API at any level: signal, slot, connection and trackable
 * - Extensions do not require alteration of basic components
 * - User definable accumulators
 * - A variety of adaptors to change the callback signature: bind, hide,
 *   retype, compose and lambda call groups
 *
 * @section basics Basic usage
 *
 * Include the libsigc++ header:
 * @code
 * #include <sigc++/sigc++.h>
 * @endcode
 * This includes every header installed by libsigc++, so can slow down
 * compilation, but suffices for this simple example. Assuming that your
 * program source file is @c program.cc, compile it with:
 * @code
 * g++ program.cc -o program `pkg-config --cflags --libs sigc++-2.0`
 * @endcode
 * Alternatively, if using autoconf, use the following in @c configure.ac:
 * @code
 * PKG_CHECK_MODULES([LIBSIGCXX], [sigc++-2.0])
 * @endcode
 * Then use the generated @c LIBSIGCXX_CFLAGS and @c LIBSIGCXX_LIBS variables
 * in the project @c Makefile.am files. For example:
 * @code
 * program_CPPFLAGS = $(LIBSIGCXX_CFLAGS)
 * program_LDADD = $(LIBSIGCXX_LIBS)
 * @endcode
 */

#include <sigc++/signal.h>
#include <sigc++/connection.h>
#include <sigc++/trackable.h>
#include <sigc++/adaptors/adaptors.h>
#include <sigc++/functors/functors.h>

#endif /* SIGCXX_SIGCXX_H */
