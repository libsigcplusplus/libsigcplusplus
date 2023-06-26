# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the versioned files

prep-git-build: pkg-ver.mak generate-sources

sigc.rc: ..\configure.ac sigc.rc.in
	@if not "$(DO_REAL_GEN)" == "1" if exist pkg-ver.mak del pkg-ver.mak
	@if not exist pkg-ver.mak $(MAKE) /f Makefile.vc CFG=$(CFG) pkg-ver.mak
	@if "$(DO_REAL_GEN)" == "1" echo Generating $@...
	@if "$(DO_REAL_GEN)" == "1" copy $@.in $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@SIGCXX_MAJOR_VERSION\@/$(PKG_MAJOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@SIGCXX_MINOR_VERSION\@/$(PKG_MINOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@SIGCXX_MICRO_VERSION\@/$(PKG_MICRO_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@PACKAGE_VERSION\@/$(PKG_MAJOR_VERSION).$(PKG_MINOR_VERSION).$(PKG_MICRO_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\@SIGCXX_API_VERSION\@/$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" del $@.bak

# You may change SIGCXX_DISABLE_DEPRECATED if you know what you are doing
sigc++config.h: ..\configure.ac ..\sigc++config.h.in
	@if not "$(DO_REAL_GEN)" == "1" if exist pkg-ver.mak del pkg-ver.mak
	@if not exist pkg-ver.mak $(MAKE) /f Makefile.vc CFG=$(CFG) pkg-ver.mak
	@if "$(DO_REAL_GEN)" == "1" echo Generating $@...
	@if "$(DO_REAL_GEN)" == "1" copy "..\$(@F).in" "$@"
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef SIGCXX_DISABLE_DEPRECATED/\/\* \#undef SIGCXX_DISABLE_DEPRECATED \*\//g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef SIGCXX_MAJOR_VERSION/\#define SIGCXX_MAJOR_VERSION $(PKG_MAJOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef SIGCXX_MINOR_VERSION/\#define SIGCXX_MINOR_VERSION $(PKG_MINOR_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" $(PERL) -pi.bak -e "s/\#undef SIGCXX_MICRO_VERSION/\#define SIGCXX_MICRO_VERSION $(PKG_MICRO_VERSION)/g" $@
	@if "$(DO_REAL_GEN)" == "1" del $@.bak

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

generate-sources:
	@for %f in ($(base_built_cc) $(base_built_h)) do @if not exist ..\sigc++\%f if not exist ..\untracked\sigc++\%f if not exist vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\ md vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++
	@for %d in ($(sigc_m4_srcdirs)) do @for %x in (cc h) do @for %f in (..\sigc++\%d\macros\*.%x.m4) do @if not exist ..\sigc++\%d\%~nf if not exist ..\untracked\sigc++\%d\%~nf if not exist vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%d\ md vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%d
	@for %f in ($(base_built_cc) $(base_built_h)) do @if not exist ..\sigc++\%f if not exist ..\untracked\sigc++\%f if not exist vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%f @echo Generating vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%f... & $(M4) -I ../sigc++/macros ../sigc++/macros/%f.m4 >vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%f
	@for %d in ($(sigc_m4_srcdirs:adaptors\lambda=)) do @for %x in (cc h) do @for %f in (..\sigc++\%d\macros\*.%x.m4) do @if not exist ..\sigc++\%d\%~nf if not exist ..\untracked\sigc++\%d\%~nf if not exist vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%d\%~nf @echo Generating vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%d\%~nf... & $(M4) -I ../sigc++/%d/macros -I ../sigc++/macros ../sigc++/%d/macros/%~nxf >vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\%d\%~nf
	@for %x in (cc h) do @for %f in (..\sigc++\adaptors\lambda\macros\*.%x.m4) do @if not exist ..\sigc++\adaptors\lambda\%~nf if not exist ..\untracked\sigc++\adaptors\lambda\%~nf if not exist vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\adaptors\lambda\%~nf @echo Generating vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\adaptors\lambda\%~nf... & $(M4) -I ../sigc++/adaptors/lambda/macros -I ../sigc++/macros ../sigc++/adaptors/lambda/macros/%~nxf >vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\sigc++\adaptors\lambda\%~nf
