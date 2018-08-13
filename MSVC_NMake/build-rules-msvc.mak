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
{..\sigc++\}.cc{$(CFG)\$(PLAT)\libsigcpp\}.obj::
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(CFG)\$(PLAT)\libsigcpp\ /c @<<
$<
<<

{..\sigc++\functors\}.cc{$(CFG)\$(PLAT)\libsigcpp\}.obj::
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(CFG)\$(PLAT)\libsigcpp\ /c @<<
$<
<<

# Rules for building .lib files
$(LIBSIGC_LIB): $(LIBSIGC_DLL)

{.}.rc{$(CFG)\$(PLAT)\libsigcpp\}.res:
	rc /fo$@ $<

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
$(LIBSIGC_DLL): $(CFG)\$(PLAT)\libsigcpp $(libsigcpp_dll_OBJS)
	link /DLL $(LDFLAGS) /implib:$(LIBSIGC_LIB) -out:$@ @<<
$(libsigcpp_dll_OBJS)
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2

# Rules for linking Executables
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link [$(linker_flags)] [$(dependent_libs)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

$(CFG)\$(PLAT)\gjs-console.exe: $(CFG)\$(PLAT)\gjs.lib $(CFG)\$(PLAT)\gjs-console $(gjs_OBJS)
	link $(LDFLAGS) $(CFG)\$(PLAT)\gjs.lib $(GJS_BASE_LIBS) -out:$@ $(gjs_OBJS)
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

clean:
	@-del /f /q $(CFG)\$(PLAT)\*.pdb
	@-del /f /q $(CFG)\$(PLAT)\*.dll
	@-del /f /q $(CFG)\$(PLAT)\*.ilk
	@-del /f /q $(CFG)\$(PLAT)\*.exp
	@-del /f /q $(CFG)\$(PLAT)\*.lib
	@-del /f /q $(CFG)\$(PLAT)\libsigcpp\*.res
	@-del /f /q $(CFG)\$(PLAT)\libsigcpp\*.obj
	@-rd $(CFG)\$(PLAT)\libsigcpp
	@-del /f /q vc$(PDBVER)0.pdb
