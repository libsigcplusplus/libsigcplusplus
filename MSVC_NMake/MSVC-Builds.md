Instructions for building libsigc++ on Visual Studio
=

Building libsigc++ on Windows is now supported using Visual Studio
versions 2015 or later in both 32-bit and 64-bit (x64 and ARM64) flavors,
via NMake Makefiles.  Due to `C++11` usage, Visual Studio 2013 or
earlier is not supported.

libsigc++ itself has no external dependencies, but building the
benchmark test program will require an installation of the Boost
C++ libraries.

## Building with NMake

The following describes what items are built with the following
targets:

* `all`, `examples`: (or no target specified): The libsigc++ DLL and the example programs.
* `tests`: The libsigc++ DLL and the test programs.
* `benchmark`: The libsigc++ DLL and the benchmark program, the Boost C++ libraries are
needed. The Boost C++ headers and .lib's should be found in one of the paths that are in
`%INCLUDE%` and `%LIB%` respectively, or use BOOST_INCLUDEDIR and/or BOOST_LIBDIR to
point to the paths where the Boost headers and .lib's can be found.

The following are instructions for performing such a build.  A `clean` target is
provided-it is recommended that one cleans the build and redo the build if any
configuration option changed.  An `install` target is also provided to copy the
built items in their appropriate locations under `$(PREFIX)`, which is described
below.

A 'forceclean' target is also provided to cover the actions under the target
'clean', but also to remove any traces of the headers and sources that were
generated.  This may be useful if one wants to re-generate the sources and headers
from the m4 templates.

Invoke the build by issuing the command:
`nmake /f Makefile.vc CFG=[release|debug] <option1=1 option2=1 ...>`
where:

* `CFG`: Required.  Choose from a `release` or `debug` build.  Note that
 all builds generate a `.pdb` file for each `.dll` and `.exe` built.

Options that are supported for the build are as follows (all are optional unless
noted):
* PREFIX: Base directory of where the third-party headers, libraries
and needed tools can be found, i.e. headers in `$(PREFIX)\include`,
libraries in `$(PREFIX)\lib` and tools and DLLs in `$(PREFIX)\bin`.  If not
specified, `$(PREFIX)` is set as `$(srcroot)\..\vs$(X)\$(platform)`, where
`$(platform)` is `win32` for 32-bit builds or `x64` for 64-bit (Intel/AMD)
builds or `arm64` for 64-bit (ARM) builds, and `$(X)` is the short version of the
Visual Studio used, as follows:
  * 2015: `14`
  * 2017: `15`
  * 2019: `16`
  * 2022: `17`
  * 2026: `18`

* BASE_INCLUDEDIR: Base directory where needed headers can be found; default
is `$(PREFIX)\include`. Also see BOOST_INCLUDEDIR for more details on this.
* BASE_LIBDIR: Base directory where needed .lib's are found; default is
`$(PREFIX)\lib`. Also see BOOST_LIBDIR for more details on this.
* BOOST_INCLUDEDIR: Directory where the Boost C++ headers, needed for the
benchmark program, can be found, default is `$(BASE_INCLUDEDIR)`.
You need to include the subdirectory for the Boost version you are using,
if it is there. i.e. If you are using Boost-1.89, you need to set this to
`BOOST_INCLUDEDIR=<some_include_dir>\boost-1_89`.
* BOOST_LIBDIR: Directory where the needed .lib's for Boost can be found.
Also note BOOST_DLL if you are building against Boost that are built as DLLs.
* BOOST_DLL: Set to `1` when building the benchmark program, link to a DLL
build of the Boost libraries.  Required if your installation of the Boost.
libraries are built as DLLs. Note that debug builds must link to debug builds
of Boost and release builds must link to release builds of Boost.
* PERL, M4: Path to the PERL interpreter and `m4` tool if not already in `%PATH%`,
PERL is needed for all builds, and m4 is needed for builds from a GIT checkout.
Alternatively, for `m4`, use UNIX_TOOLS_BINDIR to point to the directory where the
`m4` executable may be found, such as the `bin` directory of your Cygwin or
MSYS2/MSYS64 installation.
*  STATIC: Set to `1` if building libsigc++ as a static library. Note that
for building items that use this static build, `/DLIBSIGCXX_STATIC`
must be passed into the compiler flags.

## Building using Meson or CMake

Please also see the items in `$(srcroot)/README.md` for further info.

For Meson builds, if building with `maintainer-mode` (such as explicitly requested or
building from a GIT checkout), you will need to also install Doxygen, LLVM (likely needed by
Doxygen) and GraphViz unless you pass in `-Dbuild-documentation=false` in your Meson
configure command line.  You will still need to have `mm-common` installed with its `bin`
directory in your `%PATH%`, in addition to the PERL interpreter and `m4`
executable as noted in the [NMake builds](#Building-with-NMake) section.

If building without enabling `maintainer-mode` from a release tarball, it is sufficient to
build with Visual Studio 2015 or later, just as in the NMake builds.
