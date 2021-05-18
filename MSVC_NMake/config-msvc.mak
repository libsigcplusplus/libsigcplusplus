# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building gjs.
BASE_INCLUDES =	/I$(PREFIX)\include

# Please do not change anything beneath this line unless maintaining the NMake Makefiles

LIBSIGC_MAJOR_VERSION = 3
LIBSIGC_MINOR_VERSION = 0

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

LIBSIGCPP_DEFINES = /DSIGC_BUILD /D_WINDLL

SIGCPP_BASE_CFLAGS = /I.. /I. /I..\untracked\MSVC_NMake /std:c++17 /EHsc $(CFLAGS)

LIBSIGC_INT_SOURCES = $(sigc_sources_cc:/=\)
LIBSIGC_INT_HDRS = $(sigc_public_h:/=\)

SIGCPP_CFLAGS = $(SIGCPP_BASE_CFLAGS) $(CFLAGS)
LIBSIGCPP_CFLAGS = $(SIGCPP_CFLAGS) $(LIBSIGCPP_DEFINES)

# We build sigc-vc$(VSVER_LIB)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION).dll or
#          sigc-vc$(VSVER_LIB)d-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION).dll at least

!ifdef USE_MESON_LIBS
LIBSIGC_LIBNAME = sigc-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)
LIBSIGC_DLLNAME = $(LIBSIGC_LIBNAME)-0
!else
LIBSIGC_LIBNAME = sigc-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION)
LIBSIGC_DLLNAME = $(LIBSIGC_LIBNAME)
!endif

LIBSIGC_DLL = vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_DLLNAME).dll
LIBSIGC_LIB = vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).lib

# If your Boost libraries are built as DLLs, use BOOST_DLL=1 in your NMake command line
!ifdef BOOST_DLL
SIGCPP_BENCHMARK_CFLAGS = $(SIGCPP_BASE_CFLAGS) /DBOOST_ALL_DYN_LINK
!else
SIGCPP_BENCHMARK_CFLAGS = $(SIGCPP_BASE_CFLAGS)
!endif
