# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building gjs.
BASE_INCLUDES =	/I$(PREFIX)\include

# Please do not change anything beneath this line unless maintaining the NMake Makefiles

LIBSIGC_MAJOR_VERSION = 3
LIBSIGC_MINOR_VERSION = 0

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
LIBSIGC_DEBUG_SUFFIX = -d
!else
LIBSIGC_DEBUG_SUFFIX =
!endif

LIBSIGCPP_DEFINES = /DSIGC_BUILD /D_WINDLL

SIGCPP_BASE_CFLAGS = /I.. /I. /wd4530 /std:c++17

LIBSIGC_INT_SOURCES = $(sigc_sources_cc:/=\)
LIBSIGC_INT_HDRS = $(sigc_public_h:/=\)

SIGCPP_CFLAGS = $(SIGCPP_BASE_CFLAGS) $(CFLAGS)
LIBSIGCPP_CFLAGS = $(SIGCPP_CFLAGS) $(LIBSIGCPP_DEFINES)

# We build sigc-vc$(VSVER)0-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION).dll or
#          sigc-vc$(VSVER)0d-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION).dll at least

LIBSIGC_LIBNAME = sigc-vc$(VSVER)0$(LIBSIGC_DEBUG_SUFFIX)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION)

LIBSIGC_DLL = $(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).dll
LIBSIGC_LIB = $(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).lib
