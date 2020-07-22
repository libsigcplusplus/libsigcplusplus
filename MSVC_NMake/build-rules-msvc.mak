# NMake Makefile portion for compilation rules
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.  The format
# of NMake Makefiles here are different from the GNU
# Makefiles.  Please see the comments about these formats.

# Inference rules for compiling the .obj files.
# Used for libs and programs with more than a single source file.
# Format is as follows
# (all dirs must have a trailing '\'):
#
# {$(srcdir)}.$(srcext){$(destdir)}.obj::
# 	$(CC)|$(CXX) $(cflags) /Fo$(destdir) /c @<<
# $<
# <<
{..\sigc++\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\}.obj:
	@for %f in ($(base_built_cc) $(base_built_h)) do @if not exist ..\sigc++\%f if not exist ..\untracked\sigc++\%f if not exist $(@D)\sigc++\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(functors_built_cc) $(functors_built_h)) do @if not exist ..\sigc++\functors\%f if not exist ..\untracked\sigc++\functors\%f if not exist $(@D)\sigc++\functors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(adaptors_built_cc) $(adaptors_built_h)) do @if not exist ..\sigc++\adaptors\%f if not exist ..\untracked\sigc++\adaptors\%f if not exist $(@D)\sigc++\adaptors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(lambda_built_cc) $(lambda_built_h)) do @if not exist ..\sigc++\adaptors\lambda\%f if not exist ..\untracked\sigc++\adaptors\lambda\%f if not exist $(@D)\sigc++\adaptors\lambda\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{..\sigc++\adaptors\lambda\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\}.obj:
	@for %f in ($(base_built_cc) $(base_built_h)) do @if not exist ..\sigc++\%f if not exist ..\untracked\sigc++\%f if not exist $(@D)\sigc++\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(functors_built_cc) $(functors_built_h)) do @if not exist ..\sigc++\functors\%f if not exist ..\untracked\sigc++\functors\%f if not exist $(@D)\sigc++\functors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(adaptors_built_cc) $(adaptors_built_h)) do @if not exist ..\sigc++\adaptors\%f if not exist ..\untracked\sigc++\adaptors\%f if not exist $(@D)\sigc++\adaptors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(lambda_built_cc) $(lambda_built_h)) do @if not exist ..\sigc++\adaptors\lambda\%f if not exist ..\untracked\sigc++\adaptors\lambda\%f if not exist $(@D)\sigc++\adaptors\lambda\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{..\sigc++\functors\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\}.obj:
	@for %f in ($(base_built_cc) $(base_built_h)) do @if not exist ..\sigc++\%f if not exist ..\untracked\sigc++\%f if not exist $(@D)\sigc++\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(functors_built_cc) $(functors_built_h)) do @if not exist ..\sigc++\functors\%f if not exist ..\untracked\sigc++\functors\%f if not exist $(@D)\sigc++\functors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(adaptors_built_cc) $(adaptors_built_h)) do @if not exist ..\sigc++\adaptors\%f if not exist ..\untracked\sigc++\adaptors\%f if not exist $(@D)\sigc++\adaptors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(lambda_built_cc) $(lambda_built_h)) do @if not exist ..\sigc++\adaptors\lambda\%f if not exist ..\untracked\sigc++\adaptors\lambda\%f if not exist $(@D)\sigc++\adaptors\lambda\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{..\untracked\sigc++\adaptors\lambda\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\}.obj:
	@for %f in ($(base_built_cc) $(base_built_h)) do @if not exist ..\sigc++\%f if not exist ..\untracked\sigc++\%f if not exist $(@D)\sigc++\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(functors_built_cc) $(functors_built_h)) do @if not exist ..\sigc++\functors\%f if not exist ..\untracked\sigc++\functors\%f if not exist $(@D)\sigc++\functors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(adaptors_built_cc) $(adaptors_built_h)) do @if not exist ..\sigc++\adaptors\%f if not exist ..\untracked\sigc++\adaptors\%f if not exist $(@D)\sigc++\adaptors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(lambda_built_cc) $(lambda_built_h)) do @if not exist ..\sigc++\adaptors\lambda\%f if not exist ..\untracked\sigc++\adaptors\lambda\%f if not exist $(@D)\sigc++\adaptors\lambda\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++\adaptors\lambda\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\}.obj:
	@for %f in ($(base_built_cc) $(base_built_h)) do @if not exist ..\sigc++\%f if not exist ..\untracked\sigc++\%f if not exist $(@D)\sigc++\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(functors_built_cc) $(functors_built_h)) do @if not exist ..\sigc++\functors\%f if not exist ..\untracked\sigc++\functors\%f if not exist $(@D)\sigc++\functors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(adaptors_built_cc) $(adaptors_built_h)) do @if not exist ..\sigc++\adaptors\%f if not exist ..\untracked\sigc++\adaptors\%f if not exist $(@D)\sigc++\adaptors\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@for %f in ($(lambda_built_cc) $(lambda_built_h)) do @if not exist ..\sigc++\adaptors\lambda\%f if not exist ..\untracked\sigc++\adaptors\lambda\%f if not exist $(@D)\sigc++\adaptors\lambda\%f $(MAKE) /f Makefile.vc CFG=$(CFG) generate-sources
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

# Rules for building .lib files
$(LIBSIGC_LIB): $(LIBSIGC_DLL)

{.}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\}.res:
	rc /fo$@ $<

{..\untracked\MSVC_NMake\}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\sigc\}.res:
	rc /fo$@ $<

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
$(LIBSIGC_DLL): $(sigc_dll_OBJS)
	link /DLL $(LDFLAGS) /implib:$(LIBSIGC_LIB) -out:$@ @<<
$(sigc_dll_OBJS)
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2

# Rules for linking Executables
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link [$(linker_flags)] [$(dependent_libs)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

clean:
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.exe
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.dll
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.ilk
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.exp
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.lib
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\sigc-tests del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc-tests\*.obj
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\sigc-tests del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc-tests\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc-ex\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc-ex\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc\*.res
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc\*.pdb
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\sigc-tests rd vs$(VSVER)\$(CFG)\$(PLAT)\sigc-tests
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\sigc-ex
	@-for %d in ($(sigc_m4_srcdirs)) do @for %x in (cc h) do @if exist vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++\%d\ del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++\%d\*.%x
	@-for %x in (cc h) do @if exist vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++\ del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++\*.%x
	@-for %d in ($(sigc_m4_srcdirs)) do @rd vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++\%d
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\sigc

forceclean: clean
	@-for %d in (. adaptors\lambda adaptors functors) do @for %t in (.. ..\untracked) do @for %x in (cc h) do @for %f in (..\sigc++\%d\macros\*.%x.m4) do @del %t\sigc++\%d\%~nf
