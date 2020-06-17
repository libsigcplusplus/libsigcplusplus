# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the build directories
vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp	\
vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-ex	\
vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests:
	@-md $@

# Create the versioned files

prep-git-build: pkg-ver.mak

sigc.rc: pkg-ver.mak sigc.rc.in
	@echo Generating $@...
	@copy $@.in $@
	@$(PERL) -pi.bak -e "s/\@SIGCXX_MAJOR_VERSION\@/$(PKG_MAJOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@SIGCXX_MINOR_VERSION\@/$(PKG_MINOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@SIGCXX_MICRO_VERSION\@/$(PKG_MICRO_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@PACKAGE_VERSION\@/$(PKG_MAJOR_VERSION).$(PKG_MINOR_VERSION).$(PKG_MICRO_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@SIGCXX_API_VERSION\@/$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)/g" $@
	@del $@.bak

# You may change SIGCXX_DISABLE_DEPRECATED if you know what you are doing
sigc++config.h: pkg-ver.mak ..\sigc++config.h.in
	@echo Generating $@...
	@copy "..\$(@F).in" "$@"
	@$(PERL) -pi.bak -e "s/\#undef SIGCXX_DISABLE_DEPRECATED/\/\* \#undef SIGCXX_DISABLE_DEPRECATED \*\//g" $@
	@$(PERL) -pi.bak -e "s/\#undef SIGCXX_MAJOR_VERSION/\#define SIGCXX_MAJOR_VERSION $(PKG_MAJOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\#undef SIGCXX_MINOR_VERSION/\#define SIGCXX_MINOR_VERSION $(PKG_MINOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\#undef SIGCXX_MICRO_VERSION/\#define SIGCXX_MICRO_VERSION $(PKG_MICRO_VERSION)/g" $@
	@del $@.bak

pkg-ver.mak: ..\configure.ac
	@echo Generating version info Makefile Snippet...
	@$(PERL) -00 -ne "print if /AC_INIT\(/" $** |	\
	$(PERL) -pe "tr/, /\n/s" |	\
	$(PERL) -ne "print if 2 .. 2" |	\
	$(PERL) -ne "print /\[(.*)\]/" > ver.txt
	@echo @echo off>pkg-ver.bat
	@echo.>>pkg-ver.bat
	@echo set /p sigc_ver=^<ver.txt>>pkg-ver.bat
	@echo for /f "tokens=1,2,3 delims=." %%%%a IN ("%%sigc_ver%%") do (echo PKG_MAJOR_VERSION=%%%%a^& echo PKG_MINOR_VERSION=%%%%b^& echo PKG_MICRO_VERSION=%%%%c)^>$@>>pkg-ver.bat
	@pkg-ver.bat
	@del ver.txt pkg-ver.bat
	$(MAKE) /f Makefile.vc CFG=$(CFG) GENERATE_VERSIONED_FILES=1 sigc.rc sigc++config.h
