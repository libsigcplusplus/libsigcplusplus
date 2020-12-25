---
layout: default
title: libsigc++
---
## About

libsigc++ implements a typesafe callback system for standard C++. It
allows you to define signals and to connect those signals to any
callback function, either global or a member function, regardless of
whether it is static or virtual.

It also contains adaptor classes for connection of dissimilar
callbacks and has an ease of use unmatched by other
C++ callback libraries.  Libsigc++ is licensed under
the GNU Library General Public License, [LGPL](http://www.gnu.org/copyleft/lgpl.html).

## Features

* Compile time typesafe callbacks (faster than run time checks)
* Typesafety violations report line number correctly with template names (no tracing template failures into headers)
* No compiler extensions or meta compilers required
* Proper handling of dynamic objects and signals (deleted objects will not cause seg faults)
* Extendable API at any level: signal, slot, connection and trackable
* Extensions do not require alteration of basic components
* User definable accumulators
* A variety of adaptors to change the callback signature: bind, hide, retype, compose
* Most C++ compilers can be used. libsigc++ version 2.5.1 and later require a compiler with C++11 support.
libsigc++ version 3.0.0 and later require a compiler with C++17 support

sigc++-2.0 and sigc++-3.0 are different parallel-installable ABIs.

## News

See the [NEWS](https://github.com/libsigcplusplus/libsigcplusplus/blob/master/NEWS) file in git.

## Developers

The original library was composed by Tero Pulkkinen for the
gtkmm system, a C++ wrapper for the Gtk+ widget set. The revised
library was written and mantained by Karl Nelson. Special thanks
to Esa Pulkkinen for development tips.

The 1.2 phase was maintained by Murray Cumming after Karl provided the initial 1.2 code.
A long 1.9 phase led to the major release 2.0, previously maintained by Martin Schulze,
and then maintained by Murray Cumming and Kjell Ahlstedt.

Then libsigc++ was rewritten for C++17 using variadic templates, for major release 3.0,
currently maintained by Murray Cumming and Kjell Ahlstedt.
