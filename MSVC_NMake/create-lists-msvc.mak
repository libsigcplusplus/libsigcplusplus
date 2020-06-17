# Convert the source listing to object (.obj) listing in
# another NMake Makefile module, include it, and clean it up.
# This is a "fact-of-life" regarding NMake Makefiles...
# This file does not need to be changed unless one is maintaining the NMake Makefiles

# For those wanting to add things here:
# To add a list, do the following:
# # $(description_of_list)
# if [call create-lists.bat header $(makefile_snippet_file) $(variable_name)]
# endif
#
# if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]
# endif
#
# if [call create-lists.bat footer $(makefile_snippet_file)]
# endif
# ... (repeat the if [call ...] lines in the above order if needed)
# !include $(makefile_snippet_file)
#
# (add the following after checking the entries in $(makefile_snippet_file) is correct)
# (the batch script appends to $(makefile_snippet_file), you will need to clear the file unless the following line is added)
#!if [del /f /q $(makefile_snippet_file)]
#!endif

# In order to obtain the .obj filename that is needed for NMake Makefiles to build DLLs/static LIBs or EXEs, do the following
# instead when doing 'if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]'
# (repeat if there are multiple $(srcext)'s in $(source_list), ignore any headers):
# !if [for %c in ($(source_list)) do @if "%~xc" == ".$(srcext)" @call create-lists.bat file $(makefile_snippet_file) $(intdir)\%~nc.obj]
#
# $(intdir)\%~nc.obj needs to correspond to the rules added in build-rules-msvc.mak
# %~xc gives the file extension of a given file, %c in this case, so if %c is a.cc, %~xc means .cc
# %~nc gives the file name of a given file without extension, %c in this case, so if %c is a.cc, %~nc means a

NULL=

# For libsigc++

!if [call create-lists.bat header sigc.mak sigc_dll_OBJS]
!endif

!if [for %c in ($(sigc_sources_cc)) do @if "%~xc" == ".cc" @call create-lists.bat file sigc.mak vs^$(VSVER)\^$(CFG)\^$(PLAT)\sigc\%~nc.obj]
!endif

!if [@call create-lists.bat file sigc.mak vs^$(VSVER)\^$(CFG)\^$(PLAT)\sigc\sigc.res]
!endif

!if [call create-lists.bat footer sigc.mak]
!endif

!if [call create-lists.bat header sigc.mak sigc_m4_srcdirs]
!endif

!if [for %d in (adaptors\lambda adaptors functors) do @call create-lists.bat file sigc.mak %d]
!endif

!if [call create-lists.bat footer sigc.mak]
!endif

!if [for %d in (examples tests) do @call create-lists.bat header sigc.mak libsigc_%d & @(for %s in (..\%d\*.cc) do @if not "%~ns" == "testutilities" if not "%~ns" == "benchmark" call create-lists.bat file sigc.mak vs$(VSVER)\$(CFG)\$(PLAT)\%~ns.exe) & @call create-lists.bat footer sigc.mak]
!endif

!if [call create-lists.bat header sigc.mak libsigc_benchmark & @for %s in (..\tests\benchmark.cc) do @(call create-lists.bat file sigc.mak vs$(VSVER)\$(CFG)\$(PLAT)\%~ns.exe) & @call create-lists.bat footer sigc.mak]
!endif

!if [for %d in (examples tests) do @for %s in (..\%d\*.cc) do @if not "%~ns" == "benchmark" echo vs^$(VSVER)\^$(CFG)\^$(PLAT)\sigc-%d\%~ns.obj: %s>>sigc.mak & @echo. @if not exist ^$(@D)\ md ^$(@D)>>sigc.mak & @echo. ^$(CXX) ^$(SIGCPP_CFLAGS) /Fo^$(@D)\ /Fd^$(@D)\ ^$** /c>>sigc.mak & @echo.>>sigc.mak]
!endif

!if [for %s in (..\tests\benchmark.cc) do @echo vs^$(VSVER)\^$(CFG)\^$(PLAT)\sigc-tests\%~ns.obj: %s>>sigc.mak & @echo. @if not exist ^$(@D)\ md ^$(@D)>>sigc.mak & @echo. ^$(CXX) ^$(SIGCPP_BENCHMARK_CFLAGS) /Fo^$(@D)\ /Fd^$(@D)\ ^$** /c>>sigc.mak & @echo.>>sigc.mak]
!endif

!if [for %s in (..\examples\*.cc) do @echo vs^$(VSVER)\^$(CFG)\^$(PLAT)\%~ns.exe: ^$(LIBSIGC_LIB) vs^$(VSVER)\^$(CFG)\^$(PLAT)\sigc-examples\%~ns.obj>>sigc.mak & @echo. link ^$(LDFLAGS) ^$** /out:^$@>>sigc.mak & @echo.>>sigc.mak]
!endif

!if [for %s in (..\tests\*.cc) do @if not "%~ns" == "testutilities" echo vs^$(VSVER)\^$(CFG)\^$(PLAT)\%~ns.exe: ^$(LIBSIGC_LIB) vs^$(VSVER)\^$(CFG)\^$(PLAT)\sigc-tests\%~ns.obj vs^$(VSVER)\^$(CFG)\^$(PLAT)\sigc-tests\testutilities.obj>>sigc.mak & @echo. link ^$(LDFLAGS) ^$** /out:^$@>>sigc.mak & @echo.>>sigc.mak]
!endif

!include sigc.mak

!if [del /f /q sigc.mak]
!endif
