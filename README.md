# libsigc++ -- The Typesafe Callback Framework for C++


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

# Compatibility

Compatible compilers must support C++17, such as the decltype(auto) specifier
(from C++14) and std::invoke().
