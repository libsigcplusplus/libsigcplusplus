# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building libsigc++.
!ifndef BASE_INCLUDEDIR
BASE_INCLUDEDIR = $(PREFIX)\include
!endif
!ifndef BASE_LIBDIR
BASE_LIBDIR = $(PREFIX)\lib
!endif

# Please do not change anything beneath this line unless maintaining the NMake Makefiles

SIGC_MAJOR_VERSION = 2
SIGC_MINOR_VERSION = 0
SIGC_SERIES = $(SIGC_MAJOR_VERSION).$(SIGC_MINOR_VERSION)
OUTDIR=vs$(VSVER)\$(CFG)\$(PLAT)

DEPS_MKFILE = deps-vs$(VSVER)-$(PLAT)-$(CFG).mak
M4_PATH_MKFILE = find-m4-bindir-vs$(VSVER)-$(PLAT)-$(CFG).mak
UNIX_TOOLS_PATH_MKFILE = check-unix-tools-bindir-vs$(VSVER)-$(PLAT)-$(CFG).mak

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

!ifndef M4
!ifdef UNIX_TOOLS_BINDIR
M4 = $(UNIX_TOOLS_BINDIR)\m4.exe
!else
M4 = m4
!endif
!endif

# Try to deduce full path to m4.exe, as needed
!if [if not exist $(M4)\ if exist $(M4) echo M4_FULL_PATH = $(M4)>$(M4_PATH_MKFILE)]
!endif
!if [if exist $(M4).exe echo M4_FULL_PATH = $(M4).exe>$(M4_PATH_MKFILE)]
!endif
!if [if not exist $(M4_PATH_MKFILE) ((echo M4_FULL_PATH = \>$(M4_PATH_MKFILE)) & where $(M4)>>$(M4_PATH_MKFILE) 2>NUL)]
!endif

!include $(M4_PATH_MKFILE)

!if [del /f/q $(M4_PATH_MKFILE)]
!endif

!if [if not "$(UNIX_TOOLS_BINDIR)" == "" if not "$(M4_FULL_PATH)" == "" echo UNIX_TOOLS_BINDIR_CHECKED = $(UNIX_TOOLS_BINDIR)>$(UNIX_TOOLS_PATH_MKFILE)]
!endif

!if [if "$(UNIX_TOOLS_BINDIR)" == "" if not "$(M4_FULL_PATH)" == "" (for %f in ($(M4_FULL_PATH)) do @echo UNIX_TOOLS_BINDIR_CHECKED = %~dpf>$(UNIX_TOOLS_PATH_MKFILE))]
!endif

!if [if not exist $(UNIX_TOOLS_PATH_MKFILE) (echo UNIX_TOOLS_BINDIR_CHECKED = >$(UNIX_TOOLS_PATH_MKFILE))]
!endif

!include $(UNIX_TOOLS_PATH_MKFILE)

!if [del /f/q $(UNIX_TOOLS_PATH_MKFILE)]
!endif

SIGC_DEFINES = /DSIGC_BUILD

SIGC_INCLUDES =	\
	/I$(OUTDIR)\$(SIGC_INTDIR)	\
	/I..\untracked /I.. /I..\untracked\MSVC_NMake /I.

# Define LIBSIGCXX_STATIC everywhere for static builds
!ifdef STATIC
SIGC_DEFINES = $(SIGC_DEFINES) /DLIBSIGCXX_STATIC
!endif
SIGC_PROGRAMS_DEFINES = $(SIGC_DEFINES:/DSIGC_BUILD=)

SIGC_INT_SOURCES = $(sigc_sources_cc:/=\)
SIGC_INT_HDRS = $(sigc_public_h:/=\)

SIGC_CXXFLAGS = $(SIGC_BASE_CFLAGS)
SIGC_CXXFLAGS = $(SIGC_CXXFLAGS) $(SIGC_DEFINES)

# We build sigc-vc$(PDBVER)0-$(SIGC_MAJOR_VERSION)_$(SIGC_MINOR_VERSION).dll or
#          sigc-vc$(PDBVER)0d-$(SIGC_MAJOR_VERSION)_$(SIGC_MINOR_VERSION).dll at least

!ifdef USE_MESON_LIBS
SIGC_LIBNAME = sigc-$(SIGC_SERIES)
SIGC_DLLNAME = $(SIGC_LIBNAME)-0
!else
SIGC_LIBNAME = sigc-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(SIGC_SERIES:.=_)
SIGC_DLLNAME = $(SIGC_LIBNAME)
!endif

!ifdef STATIC
SIGC_LIB = $(OUTDIR)\$(SIGC_LIBNAME)-static.lib
!else
SIGC_DLL = $(OUTDIR)\$(SIGC_DLLNAME).dll
SIGC_LIB = $(OUTDIR)\$(SIGC_LIBNAME).lib
!endif

# Note that building the benchmark requires Boost!
libsigc_bench = $(OUTDIR)\libsigc++-benchmark.exe

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
