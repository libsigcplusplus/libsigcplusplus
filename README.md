# libsigc++ : The Typesafe Callback Framework for C++

## Introduction

libsigc++ implements a typesafe callback system for standard C++. It
allows you to define signals and to connect those signals to any
callback function, either global or a member function, regardless of
whether it is static or virtual.

libsigc++ is used by gtkmm to wrap the GTK signal system. It does not
depend on GTK or gtkmm.

sigc++-2.0 and sigc++-3.0 are different parallel-installable ABIs.
This file describes sigc++-2.0.

See the [libsigc++ web site](https://libsigcplusplus.github.io/libsigcplusplus/)

## License

Distribution of library and components is under the LGPL as listed in the
file COPYING. Examples and tests are Public Domain.

## Compatibility

Compatible compilers must support C++11, such as the decltype() specifier.

## Build

Whenever possible, you should use the official binary packages approved by the
supplier of your operating system, such as your Linux distribution. For
instance, Ubuntu Linux, Debian Linux and Fedora Linux have official libsigc++
packages.

## Building from a release tarball

Building from the [libsigc++ release tarball](https://github.com/libsigcplusplus/libsigcplusplus/releases)
is easier than building from git.

It's easiest to build with Meson, if the tarball was made with Meson,
and to build with Autotools, if the tarball was made with Autotools.
Then you don't have to use maintainer-mode.

How do you know how the tarball was made? If it was made with Meson,
it contains files in untracked/build_scripts/, untracked/docs/ and possibly
other subdirectories of untracked/.

### Building from a tarball with Meson

Don't call the builddir 'build'. There is a directory called 'build' with
files used by Autotools.

For instance:
```sh
# If the tarball was made with Autotools, you must enable maintainer-mode:
$ meson --prefix=/some_directory --libdir=lib -Dmaintainer-mode=true your_builddir .

# If the tarball was made with Meson:
$ meson --prefix=/some_directory --libdir=lib your_builddir .

# then:
$ cd your_builddir
$ ninja
$ ninja install
# You can run the tests like so:
$ ninja test
```

### Building from a tarball with Autotools

For instance:
```sh
# If the tarball was made with Autotools:
$ ./configure --prefix=/some_directory

# If the tarball was made with Meson, you must enable maintainer-mode:
$ ./autogen.sh --prefix=/some_directory

# then:
$ make
$ make install
# You can build the examples and tests, and run the tests, like so:
$ make check
```

## Building from git

Building from git can be difficult so you should prefer building from a release
tarball unless you need to work on the libsigc++ code itself.

jhbuild can be a good help. See the [jhbuild repo](https://gitlab.gnome.org/GNOME/jhbuild),
the [jhbuild wiki](https://wiki.gnome.org/Projects/Jhbuild) and
the [jhbuild manual](https://gnome.pages.gitlab.gnome.org/jhbuild).

### Building from git with Meson

You must have Meson properly installed (meson, ninja, etc) and you
will also need [mm-common](https://gitlab.gnome.org/GNOME/mm-common/)
version 1.0.0 or higher.

Maintainer-mode is enabled by default when you build from a git clone.

Don't call the builddir 'build'. There is a directory called 'build' with
files used by Autotools.

```sh
$ meson --prefix=/some_directory --libdir=lib your_builddir .
$ cd your_builddir
$ ninja
$ ninja install
# You can run the tests like so:
$ ninja test
# You can create a tarball like so:
$ ninja dist
```

### Building from git with Autotools

You must have Autotools properly installed (autoconf, automake, etc) and you
will also need [mm-common](https://gitlab.gnome.org/GNOME/mm-common/).

```sh
$ ./autogen.sh --prefix=/some_directory
$ make
$ make install
# You can build the examples and tests, and run the tests, like so:
$ make check
# You can create a tarball like so:
$ make distcheck
# or
$ make dist
```

## Building with Microsoft Visual C++

See MSVC_NMake/README.txt.
