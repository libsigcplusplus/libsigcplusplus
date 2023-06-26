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
{..\sigc++\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\}.obj:
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{..\sigc++\functors\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\}.obj:
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\  /c @<<
$<
<<

{.}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\}.res:
	@if not exist $(@D)\ md $(@D)
	rc /fo$@ $<

{..\untracked\MSVC_NMake\}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\}.res:
	@if not exist $(@D)\ md $(@D)
	rc /fo$@ $<

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
!ifdef STATIC
$(LIBSIGC_LIB): $(libsigc_OBJS)
	lib $(ARFLAGS) -out:$@ @<<
$(libsigc_OBJS)
<<
!else
$(LIBSIGC_LIB): $(LIBSIGC_DLL)

$(LIBSIGC_DLL): $(libsigc_OBJS)
	link /DLL $(LDFLAGS) /implib:$(LIBSIGC_LIB) -out:$@ @<<
$(libsigc_OBJS)
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
!endif

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
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_TESTS_INTDIR) del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_TESTS_INTDIR)\*.obj
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_TESTS_INTDIR) del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_TESTS_INTDIR)\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_EX_INTDIR)\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_EX_INTDIR)\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\*.res
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)\*.pdb
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_TESTS_INTDIR) rd vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_TESTS_INTDIR)
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\$(SIGC_EX_INTDIR)
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_INTDIR)
