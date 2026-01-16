# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building libsigc++.
!ifndef BASE_INCLUDEDIR
BASE_INCLUDEDIR = $(PREFIX)\include
!endif
!ifndef BASE_LIBDIR
BASE_LIBDIR = $(PREFIX)\lib
!endif

# Please do not change anything beneath this line unless maintaining the NMake Makefiles

SIGC_MAJOR_VERSION = 3
SIGC_MINOR_VERSION = 0
SIGC_SERIES = $(SIGC_MAJOR_VERSION).$(SIGC_MINOR_VERSION)
OUTDIR=vs$(VSVER)\$(CFG)\$(PLAT)

DEPS_MKFILE = deps-vs$(VSVER)-$(PLAT)-$(CFG).mak
BUILD_MKFILE_SNIPPET = sigc-vs$(VSVER)-$(PLAT)-$(CFG).mak

# Gather up dependencies for their include directories and lib/bin dirs.
!if [for %t in (BOOST) do @(echo !ifndef %t_INCLUDEDIR>>$(DEPS_MKFILE) & echo %t_INCLUDEDIR=^$^(BASE_INCLUDEDIR^)>>$(DEPS_MKFILE) & echo !endif>>$(DEPS_MKFILE))]
!endif
!if [for %t in (BOOST) do @(echo !ifndef %t_LIBDIR>>$(DEPS_MKFILE) & echo %t_LIBDIR=^$^(BASE_LIBDIR^)>>$(DEPS_MKFILE) & echo !endif>>$(DEPS_MKFILE))]
!endif

!include $(DEPS_MKFILE)

!if [del /f/q $(DEPS_MKFILE)]
!endif

!ifdef STATIC
SIGC_INTDIR = sigc-static
SIGC_EX_INTDIR = sigc-examples-static
SIGC_TESTS_INTDIR = sigc-tests-static
!else
SIGC_INTDIR = sigc
SIGC_EX_INTDIR = sigc-examples
SIGC_TESTS_INTDIR = sigc-tests
!endif

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

SIGC_DEFINES = /DSIGC_BUILD
SIGC_INCLUDES =	/I.. /I. /I..\untracked\MSVC_NMake

# Define LIBSIGCXX_STATIC everywhere for static builds
!ifdef STATIC
SIGC_DEFINES = $(SIGC_DEFINES) /DLIBSIGCXX_STATIC
!endif
SIGC_PROGRAMS_DEFINES = $(SIGC_DEFINES:/DSIGC_BUILD=)

SIGC_INT_SOURCES = $(sigc_sources_cc:/=\)
SIGC_INT_HDRS = $(sigc_public_h:/=\)

SIGC_CXXFLAGS = $(SIGC_BASE_CFLAGS)
SIGC_CXXFLAGS = $(SIGC_CXXFLAGS) $(SIGC_DEFINES)

# We build sigc-vc$(VSVER_LIB)-$(SIGC_MAJOR_VERSION)_$(SIGC_MINOR_VERSION).dll or
#          sigc-vc$(VSVER_LIB)d-$(SIGC_MAJOR_VERSION)_$(SIGC_MINOR_VERSION).dll at least

!ifdef USE_MESON_LIBS
SIGC_LIBNAME = sigc-$(SIGC_SERIES)
SIGC_DLLNAME = $(SIGC_LIBNAME)-0
!else
SIGC_LIBNAME = sigc-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(SIGC_SERIES:.=_)
SIGC_DLLNAME = $(SIGC_LIBNAME)
!endif

!ifdef STATIC
SIGC_LIB = $(OUTDIR)\$(SIGC_LIBNAME)-static.lib
!else
SIGC_DLL = $(OUTDIR)\$(SIGC_DLLNAME).dll
SIGC_LIB = $(OUTDIR)\$(SIGC_LIBNAME).lib
!endif

# If your Boost libraries are built as DLLs, use BOOST_DLL=1 in your NMake command line
SIGC_BENCHMARK_INCLUDES = /I$(BOOST_INCLUDEDIR)
SIGC_BENCHMARK_LDFLAGS = /libpath:$(BASE_LIBDIR)
!if "$(BOOST_LIBDIR)" != ""
SIGC_BENCHMARK_LDFLAGS = /libpath:$(BOOST_LIBDIR)
!endif
SIGC_BENCHMARK_CFLAGS = $(SIGC_PROGRAMS_DEFINES)
!ifdef BOOST_DLL
SIGC_BENCHMARK_CFLAGS = $(SIGC_BENCHMARK_CFLAGS) /DBOOST_ALL_DYN_LINK
!endif
