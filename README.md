# libsigc++
Typesafe Callback Framework for C++

# Introduction

libsigc++ (a.k.a. libsigcplusplus) implements a typesafe callback system for
standard C++. It allows you to define signals and to connect those signals
to any callback function, either global or a member function, regardless of
whether it is static or virtual.

libsigc++ is used by gtkmm to wrap the GTK signal system. It does not
depend on GTK or gtkmm.

sigc++-2.0 and sigc++-3.0 are different parallel-installable ABIs.
This file describes sigc++-3.0.

## License

Distribution of library and components is under the LGPL as listed in the
file COPYING. Examples and tests are Public Domain.

## Compatibility

Compatible compilers must support C++17, such as the decltype(auto) specifier
(from C++14) and std::invoke().

# General information

Web site
 - https://libsigcplusplus.github.io/libsigcplusplus/

Download location
 - https://download.gnome.org/sources/libsigc++/
 - https://github.com/libsigcplusplus/libsigcplusplus/releases/

Reference documentation
 - https://libsigcplusplus.github.io/libsigcplusplus/reference/html/

Tarballs contain reference documentation. In tarballs generated with Meson,
see the untracked/docs/docs/reference/html directory.

Discussion on GNOME's discourse forum
 - https://discourse.gnome.org/tag/cplusplus
 - https://discourse.gnome.org/c/platform

Git repository
 - https://github.com/libsigcplusplus/libsigcplusplus

Bugs can be reported to
 - https://github.com/libsigcplusplus/libsigcplusplus/issues

Patches can be submitted to
 - https://github.com/libsigcplusplus/libsigcplusplus/pulls

# Building

Whenever possible, you should use the official binary packages approved by the
supplier of your operating system, such as your Linux distribution. For
instance, Ubuntu Linux, Debian Linux and Fedora Linux have official libsigc++
packages.

## Building the documentation

The reference documentaion is built with Doxygen.

The manual is a DocBook 5.0 document. These packages are recommended when building
the manual (can have other names in other distros):
 - docbook5-xml (Ubuntu and Debian) or docbook5-schemas (Fedora)
 - docbook-xsl (Ubuntu and Debian) or docbook-style-xsl (Fedora)

It may be possible to build without these packages, but it will be slow and error prone.
The `xmllint` command is told to read files from http://docbook.org.
The `xsltproc` command is told to read files from http://docbook.sourceforge.net.
The commands first search for local copies of those files. If local copies exist
and are installed at expected locations, the commands make no network accesses.

## Building from a release tarball

Building from a release tarball is easier than building from git.

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
# If the tarball was made with Autotools, and you want to rebuild the reference
# documentation, you must enable maintainer-mode:
$ meson setup --prefix=/some_directory --libdir=lib -Dmaintainer-mode=true your_builddir .

# If the tarball was made with Meson, or you don't want to rebuild the docs:
$ meson setup --prefix=/some_directory --libdir=lib your_builddir .

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
$ meson setup --prefix=/some_directory --libdir=lib your_builddir .
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

## Building with Microsoft Visual C++

See [MSVC-Builds.md](MSVC_NMake/MSVC-Builds.md)
