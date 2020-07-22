Instructions for building libsigc++ on Visual Studio
====================================================
Building the libsigc++ on Windows is now supported using Visual Studio
versions 2013 or later in both 32-bit and 64-bit (x64) flavors,
via NMake Makefiles.  Due to C++-11 usage, Visual Studio 2012 or
earlier is not supported.

libsigc++ itself has no external dependencies, but building the
benchmark test program will require an installation of the Boost
C++ libraries.

The following describes what items are built with the following
targets:

-all (or no target specified): The libsigc++ DLL and the example programs.
-test: The libsigc++ DLL and the test programs.
-benchmark: The libsigc++ DLL and the benchmark program.
-prep-git-build: Prepare to build directly from a GIT checkout.  You
                 will at least need PERL for this, and m4 if building from a
                 GIT checkout or when building after running the 'forceclean'
                 target.

The following are instructions for performing such a build.  A 'clean' target is
provided-it is recommended that one cleans the build and redo the build if any
configuration option changed.  An 'install' target is provided to copy the
built items in their appropriate locations under $(PREFIX), which is described below.

A 'forceclean' target is also provided to cover the actions under the target 'clean',
but also to remove any traces of the headers and sources that were generated.  This
may be useful if one wants to re-generate the sources and headers from the m4 templates.

Invoke the build by issuing the command:
nmake /f Makefile.vc CFG=[release|debug] [PREFIX=...] <option1=1 option2=1 ...>
where:

CFG: Required.  Choose from a release or debug build.  Note that
     all builds generate a .pdb file for each .dll and .exe built--this refers
     to the C/C++ runtime that the build uses.

PREFIX: Optional.  Base directory of where the third-party headers, libraries
        and needed tools can be found, i.e. headers in $(PREFIX)\include,
        libraries in $(PREFIX)\lib and tools in $(PREFIX)\bin.  If not
        specified, $(PREFIX) is set as $(srcroot)\..\vs$(X)\$(platform), where
        $(platform) is win32 for 32-bit builds or x64 for 64-bit builds, and
        $(X) is the short version of the Visual Studio used, as follows:
        2017: 15

Explanation of options, set by <option>=1:
------------------------------------------
BOOST_DLL: When building the benchmark, link to a DLL build of the Boost
           libraries.  Required if your installation of the Boost libraries
           are built as DLLs.  Note that debug builds must link to debug
           builds of Boost and release builds must link to releease builds
           of Boost.
