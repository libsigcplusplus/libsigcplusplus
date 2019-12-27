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
{..\sigc++\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp\}.obj:
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\ /c @<<
$<
<<

{..\sigc++\functors\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp\}.obj:
	$(CXX) $(LIBSIGCPP_CFLAGS) /Fo$(@D)\ /Fd$(@D)\  /c @<<
$<
<<

vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\testutilities.obj: vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests ..\tests\testutilities.cc
	$(CXX) $(SIGCPP_CFLAGS) /Fo$@ /Fd$(@D)\ /c ..\tests\testutilities.cc
# Rules for building .lib files
$(LIBSIGC_LIB): $(LIBSIGC_DLL)

{.}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp\}.res:
	rc /fo$@ $<

{..\untracked\MSVC_NMake\}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp\}.res:
	rc /fo$@ $<

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
$(LIBSIGC_DLL): vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp $(libsigcpp_dll_OBJS)
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

{..\examples\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\}.exe:
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-ex $(MAKE) -f Makefile.vc CFG=$(CFG) vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-ex
	@if not exist $(LIBSIGC_LIB) $(MAKE) -f Makefile.vc CFG=$(CFG) $(LIBSIGC_LIB)
	$(CXX) $(SIGCPP_CFLAGS) /Fo$(@D)\libsigcpp-ex\ /Fd$(@D)\libsigcpp-ex\ $< /Fe$@ /link $(LDFLAGS) $(LIBSIGC_LIB)
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

{..\tests\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\}.exe:
	@if not exist $(LIBSIGC_LIB) $(MAKE) -f Makefile.vc CFG=$(CFG) $(LIBSIGC_LIB)
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\testutilities.obj $(MAKE) -f Makefile.vc CFG=$(CFG) vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\testutilities.obj
	$(CXX) $(SIGCPP_CFLAGS) /Fo$(@D)\libsigcpp-tests\ /Fd$(@D)\libsigcpp-tests\ $< /Fe$@ /link $(LDFLAGS) $(LIBSIGC_LIB) vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\testutilities.obj
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

vs$(VSVER)\$(CFG)\$(PLAT)\libsigc++-benchmark.exe: ..\tests\benchmark.cc
	@if not exist $(LIBSIGC_LIB) $(MAKE) -f Makefile.vc CFG=$(CFG) $(LIBSIGC_LIB)
	@if not exist vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\testutilities.obj $(MAKE) -f Makefile.vc CFG=$(CFG) vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\testutilities.obj
	$(CXX) $(SIGCPP_BENCHMARK_CFLAGS) /Fo$(@D)\libsigcpp-tests\ /Fd$(@D)\libsigcpp-tests\ ..\tests\benchmark.cc /Fe$@ /link $(LDFLAGS) $(LIBSIGC_LIB) vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\testutilities.obj
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

clean:
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.exe
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.dll
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.ilk
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.exp
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.lib
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\*.obj
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-ex\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-ex\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp\*.res
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp\*.pdb
	@-if exist vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests rd vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-tests
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp-ex
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\libsigcpp
