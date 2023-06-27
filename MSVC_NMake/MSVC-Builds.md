Instructions for building libsigc++ on Visual Studio
=

Building libsigc++ on Windows is now supported using Visual Studio
versions 2017 or later in both 32-bit and 64-bit (x64 and ARM64) flavors,
via NMake Makefiles, Meson or CMake.  Due to `C++17` usage, Visual Studio 2015 or
earlier is not supported, and any use of the headers installed with
this package will require the use of the `/std:c++17` compiler flag.

libsigc++ itself has no external dependencies, but building the
benchmark test program will require an installation of the Boost
C++ libraries.

Building with NMake
-
The following describes what items are built with the following
targets:

* `all`, `examples`: (or no target specified): The libsigc++ DLL and the example programs.
* `tests`: The libsigc++ DLL and the test programs.
* `benchmark`: The libsigc++ DLL and the benchmark program, the Boost C++ headers should be found in one of the paths that are in`%INCLUDE%`.

Building directly from a GIT checkout is now supported, provided that a `PERL`
installation is present (pass the `PERL` interpreter executable in your NMake
command line by using `nmake /f Makefile.vc ... PERL=<path_to_PERL_interpreter_executable>` by using
the `prep-git-build` target.

The following are instructions for performing such a build.  A `clean` target is
provided-it is recommended that one cleans the build and redo the build if any
configuration option changed.  An `install` target is also provided to copy the built
items in their appropriate
locations under `$(PREFIX)`, which is described below.

Invoke the build by issuing the command:
`nmake /f Makefile.vc CFG=[release|debug] [PREFIX=...] <option1=1 option2=1 ...>`
where:

* `CFG`: Required.  Choose from a `release` or `debug` build.  Note that
 all builds generate a `.pdb` file for each `.dll` and `.exe` built.

* `PREFIX`: Optional.  Base directory of where the third-party headers, libraries
and needed tools can be found, i.e. headers in `$(PREFIX)\include`,
libraries in `$(PREFIX)\lib` and tools and DLLs in `$(PREFIX)\bin`.  If not
specified, `$(PREFIX)` is set as `$(srcroot)\..\vs$(X)\$(platform)`, where
`$(platform)` is `win32` for 32-bit builds or `x64` for 64-bit (Intel/AMD)
builds or `arm64` for 64-bit (ARM) builds, and `$(X)` is the short version of the
Visual Studio used, as follows:
  * 2017: `15`
  * 2019: `16`
  * 2022: `17`

* `USE_COMPAT_LIBS`: Build the libsigc++ DLL and .lib with the filename
`sigc-vc150(d)-3_0` for all builds.  This is for compatibility reasons,
if re-building dependent code is not convenient, for instance

* Options, set by `<option>=1`:

   * `BOOST_DLL`: When building the benchmark, link to a DLL build of the Boost
libraries.  Required if your installation of the Boost libraries are built as DLLs.
Note that debug builds must link to debug builds of Boost and release builds must
link to release builds of Boost.

  *  `STATIC`: Optional.  Set if building libsigc++ as a static library. Note that
for building items that use this static build, `/DLIBSIGCXX_STATIC`
must be passed into the compiler flags.

## Building using Meson or CMake

Please also see the items in `$(srcroot)/README.md` for further info.

For Meson builds, if building with `maintainer-mode` (such as explicitly requested or
building from a GIT checkout), you will need to also install Doxygen, LLVM (likely needed by
Doxygen) and GraphViz unless you pass in `-Dbuild-documentation=false` in your Meson
configure command line.  You will still need to have `mm-common` installed with its `bin`
directory in your `%PATH%`.

If building without enabling `maintainer-mode` from a release tarball, it is sufficient to
build with Visual Studio 2017 or later, just as in the NMake builds.
