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
{..\sigc++\}.cc{$(OUTDIR)\$(SIGC_INTDIR)\}.obj:
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(CFLAGS) $(SIGC_DEFINES) $(SIGC_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{..\sigc++\functors\}.cc{$(OUTDIR)\$(SIGC_INTDIR)\}.obj:
	@if not exist .\sigc++config.h if not exist ..\untracked\MSVC_NMake\sigc++config.h $(MAKE) /f Makefile.vc CFG=$(CFG) sigc++config.h
	@if not exist $(@D)\ md $(@D)
	$(CXX) $(CFLAGS) $(SIGC_DEFINES) $(SIGC_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{.}.rc{$(OUTDIR)\$(SIGC_INTDIR)\}.res:
	@if not exist $(@D)\ md $(@D)
	rc /fo$@ $<

{..\untracked\MSVC_NMake\}.rc{$(OUTDIR)\$(SIGC_INTDIR)\}.res:
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
$(SIGC_LIB): $(libsigc_OBJS)
	lib $(ARFLAGS) -out:$@ @<<
$(libsigc_OBJS)
<<
!else
$(SIGC_LIB): $(SIGC_DLL)

$(SIGC_DLL): $(libsigc_OBJS)
	link /DLL $(LDFLAGS) /implib:$(SIGC_LIB) -out:$@ @<<
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
	@-del /f /q $(OUTDIR)\*.exe
	@-del /f /q $(OUTDIR)\*.dll
	@-del /f /q $(OUTDIR)\*.pdb
	@-del /f /q $(OUTDIR)\*.ilk
	@-del /f /q $(OUTDIR)\*.exp
	@-del /f /q $(OUTDIR)\*.lib
	@-if exist $(OUTDIR)\$(SIGC_TESTS_INTDIR) del /f /q $(OUTDIR)\$(SIGC_TESTS_INTDIR)\*.obj
	@-if exist $(OUTDIR)\$(SIGC_TESTS_INTDIR) del /f /q $(OUTDIR)\$(SIGC_TESTS_INTDIR)\*.pdb
	@-del /f /q $(OUTDIR)\$(SIGC_EX_INTDIR)\*.obj
	@-del /f /q $(OUTDIR)\$(SIGC_EX_INTDIR)\*.pdb
	@-del /f /q $(OUTDIR)\$(SIGC_INTDIR)\*.res
	@-del /f /q $(OUTDIR)\$(SIGC_INTDIR)\*.obj
	@-del /f /q $(OUTDIR)\$(SIGC_INTDIR)\*.pdb
	@-if exist $(OUTDIR)\$(SIGC_TESTS_INTDIR) rd $(OUTDIR)\$(SIGC_TESTS_INTDIR)
	@-rd $(OUTDIR)\$(SIGC_EX_INTDIR)
	@-rd $(OUTDIR)\$(SIGC_INTDIR)
