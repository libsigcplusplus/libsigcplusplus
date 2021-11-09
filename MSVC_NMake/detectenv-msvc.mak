# Change this (or specify PREFIX= when invoking this NMake Makefile) if
# necessary, so that the libs and headers of the dependent third-party
# libraries can be located.  For instance, if building from GLib's
# included Visual Studio projects, this should be able to locate the GLib
# build out-of-the-box if they were not moved.  GLib's headers will be
# found in $(GLIB_PREFIX)\include\glib-2.0 and
# $(GLIB_PREFIX)\lib\glib-2.0\include and its import library will be found
# in $(GLIB_PREFIX)\lib.

!if "$(PREFIX)" == ""
PREFIX = ..\..\vs$(VSVER)\$(PLAT)
!endif

# Location of the PERL interpreter, for running glib-mkenums.  glib-mkenums
# needs to be found in $(PREFIX)\bin.  Using either a 32-bit or x64 PERL
# interpreter are supported for either a 32-bit or x64 build.

!if "$(PERL)" == ""
PERL = perl
!endif

# Location of the Python interpreter, for building introspection.  The complete set
# of Python Modules for introspection (the giscanner Python scripts and the _giscanner.pyd
# compiled module) needs to be found in $(PREFIX)\lib\gobject-introspection\giscanner, and
# the g-ir-scanner Python script and g-ir-compiler utility program needs to be found
# in $(PREFIX)\bin, together with any DLLs they will depend on, if those DLLs are not already
# in your PATH.
# Note that the Python interpreter and the introspection modules and utility progam must
# correspond to the build type (i.e. 32-bit Release for 32-bit Release builds, and so on).
#
# For introspection, currently only Python 2.7.x is supported.  This may change when Python 3.x
# support is added upstream in gobject-introspection--when this happens, the _giscanner.pyd must
# be the one that is built against the release series of Python that is used here.

!if "$(PYTHON)" == ""
PYTHON = python
!endif

# Location of the pkg-config utility program, for building introspection.  It needs to be able
# to find the pkg-config (.pc) files so that the correct libraries and headers for the needed libraries
# can be located, using PKG_CONFIG_PATH.  Using either a 32-bit or x64 pkg-config are supported for
# either a 32-bit or x64 build.

!if "$(PKG_CONFIG)" == ""
PKG_CONFIG = pkg-config
!endif

# The items below this line should not be changed, unless one is maintaining
# the NMake Makefiles.  The exception is for the CFLAGS_ADD line(s) where one
# could use his/her desired compiler optimization flags, if he/she knows what is
# being done.

# Check to see we are configured to build with MSVC (MSDEVDIR, MSVCDIR or
# VCINSTALLDIR) or with the MS Platform SDK (MSSDK or WindowsSDKDir)
!if !defined(VCINSTALLDIR) && !defined(WINDOWSSDKDIR)
MSG = ^
This Makefile is only for Visual Studio 2008 and later.^
You need to ensure that the Visual Studio Environment is properly set up^
before running this Makefile.
!error $(MSG)
!endif

ERRNUL  = 2>NUL
_HASH=^#

!if ![echo VCVERSION=_MSC_VER > vercl.x] \
    && ![echo $(_HASH)if defined(_M_IX86) >> vercl.x] \
    && ![echo PLAT=Win32 >> vercl.x] \
    && ![echo $(_HASH)elif defined(_M_AMD64) >> vercl.x] \
    && ![echo PLAT=x64 >> vercl.x] \
    && ![echo $(_HASH)elif defined(_M_ARM64) >> vercl.x] \
    && ![echo PLAT=arm64 >> vercl.x] \
    && ![echo $(_HASH)endif >> vercl.x] \
    && ![cl -nologo -TC -P vercl.x $(ERRNUL)]
!include vercl.i
!if ![echo VCVER= ^\> vercl.vc] \
    && ![set /a $(VCVERSION) / 100 - 6 >> vercl.vc]
!include vercl.vc
!endif
!endif
!if ![del $(ERRNUL) /q/f vercl.x vercl.i vercl.vc]
!endif

VSVER = 0
PDBVER = 0
VSVER_SUFFIX = 0

!if $(VCVERSION) > 1499 && $(VCVERSION) < 1600
PDBVER = 9
!elseif $(VCVERSION) > 1599 && $(VCVERSION) < 1700
PDBVER = 10
!elseif $(VCVERSION) > 1699 && $(VCVERSION) < 1800
PDBVER = 11
!elseif $(VCVERSION) > 1799 && $(VCVERSION) < 1900
PDBVER = 12
!elseif $(VCVERSION) > 1899 && $(VCVERSION) < 2000
PDBVER = 14
!if $(VCVERSION) > 1909 && $(VCVERSION) < 1920
VSVER_SUFFIX = 1
VSVER = 15
!elseif $(VCVERSION) > 1919 && $(VCVERSION) < 1930
VSVER_SUFFIX = 2
VSVER = 16
!elseif $(VCVERSION) > 1929 && $(VCVERSION) < 2000
VSVER_SUFFIX = 3
VSVER = 17
!else
VSVER = $(PDBVER)
!endif
!else
VSVER = $(PDBVER)
!endif

!if "$(USE_COMPAT_LIBS)" != ""
!if $(VSVER) > 15
VSVER_LIB = 150
!else
VSVER_LIB = $(VSVER)0
!endif
!else
VSVER_LIB = $(PDBVER)$(VSVER_SUFFIX)
!endif

!if "$(VSVER)" == "0"
MSG = ^
This NMake Makefile set supports Visual Studio^
9 (2008) through 16 (2019).  Your Visual Studio^
version is not supported.
!error $(MSG)
!endif

VALID_CFGSET = FALSE
!if "$(CFG)" == "release" || "$(CFG)" == "Release" || "$(CFG)" == "debug" || "$(CFG)" == "Debug"
VALID_CFGSET = TRUE
!endif

# One may change these items, but be sure to test
# the resulting binaries
!if "$(CFG)" == "release" || "$(CFG)" == "Release"
CFLAGS_ADD = /MD /O2 /GL /MP
!if "$(VSVER)" != "9"
CFLAGS_ADD = $(CFLAGS_ADD) /d2Zi+
!endif
!if $(VSVER) >= 14
CFLAGS_ADD = $(CFLAGS_ADD) /utf-8
!endif
!else
CFLAGS_ADD = /MDd /Od
!endif

!if "$(PLAT)" == "x64"
LDFLAGS_ARCH = /machine:x64
!elseif "$(PLAT)" == "arm64"
LDFLAGS_ARCH = /machine:arm64
!else
LDFLAGS_ARCH = /machine:x86
!endif

!if "$(VALID_CFGSET)" == "TRUE"
CFLAGS = $(CFLAGS_ADD) /W3 /Zi

LDFLAGS_BASE = $(LDFLAGS_ARCH) /libpath:$(PREFIX)\lib /DEBUG

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
ARFLAGS = $(LDFLAGS_ARCH)
LDFLAGS = $(LDFLAGS_BASE)
!else
ARFLAGS = $(LDFLAGS_ARCH) /LTCG
LDFLAGS = $(LDFLAGS_BASE) /LTCG /opt:ref
!endif
!endif
