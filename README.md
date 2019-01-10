# libsigc++ : The Typesafe Callback Framework for C++

## Introduction

libsigc++ implements a typesafe callback system for standard C++. It
allows you to define signals and to connect those signals to any
callback function, either global or a member function, regardless of
whether it is static or virtual.

libsigc++ is used by gtkmm to wrap the GTK+ signal system. It does not
depend on GTK+ or gtkmm.

See the [libsigc++ web site](https://libsigcplusplus.github.io/libsigcplusplus/)

## License

Distribution of library and components is under the LGPL as listed in the
file COPYING. Examples and tests are Public Domain.

## Compatibility

Compatible compilers must support C++17, such as the decltype(auto) specifier
(from C++14) and std::invoke().

## Build

Whenever possible, you should use the official binary packages approved by the
supplier of your operating system, such as your Linux distribution. For
instance, Ubuntu Linux, Debian Linux and Fedora Linux have official libsigc++
packages.

## Building from a release tarball

Building from the [libsigc++ release tarball](https://github.com/libsigcplusplus/libsigcplusplus/releases) is easier than building from git.

For instance:
```sh
$ ./configure --prefix=/usr/local
$ make
$ make install
```

## Building from git

Building from git can be difficult so you should prefer building from a release
tarball unless you need to work on the libsigc++ code itself.

To build from git you may use either the autotools build (used by most
developers) or CMake (should work too).

### Building from git with autotools

You must have autotools properly installed (autoconf, automake, etc) and you
will also need [mm-common](https://gitlab.gnome.org/GNOME/mm-common/).

```sh
$ ./autogen.sh --prefix=/usr/local
$ make
$ make check
```

### Building from git with CMake

The CMake build is not used very often by the libsigc++ developers, but it
should work, and we would welcome improvements.

For instance:

```sh
$ mkdir libsigcplusplus_build
$ cd libsigcplusplus_build
$ cmake path/to/libsigcplusplus
$ make
```

