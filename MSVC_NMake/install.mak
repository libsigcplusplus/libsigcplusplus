# NMake Makefile snippet for copying the built libraries, utilities and headers to
# a path under $(PREFIX).

install: all
	@if not exist $(PREFIX)\bin\ md $(PREFIX)\bin
	@if not exist $(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\ md $(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\lambda\ @md $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\lambda
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors\ @md $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\tuple-utils\ @md $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\tuple-utils
	@copy /b vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).dll "$(PREFIX)\bin"
	@copy /b vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).pdb "$(PREFIX)\bin"
	@copy /b vs$(VSVER)\$(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).lib "$(PREFIX)\lib"
	@copy "..\sigc++\sigc++.h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\"
	@for %h in ($(LIBSIGC_INT_HDRS)) do @copy "..\sigc++\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\%h"
	@for %d in (..\sigc++ ..\untracked\sigc++ vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++) do @(for %h in ($(base_built_h)) do @if exist %d\%h copy "%d\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\%h")
	@for %d in (..\sigc++ ..\untracked\sigc++ vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++) do @(for %h in ($(functors_built_h)) do @if exist %d\functors\%h copy "%d\functors\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors\%h")
	@for %d in (..\sigc++ ..\untracked\sigc++ vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++) do @(for %h in ($(adaptors_built_h)) do @if exist %d\adaptors\%h copy "%d\adaptors\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\%h")
	@for %d in (..\sigc++ ..\untracked\sigc++ vs$(VSVER)\$(CFG)\$(PLAT)\sigc\sigc++) do @(for %h in ($(lambda_built_h)) do @if exist %d\adaptors\lambda\%h copy "%d\adaptors\lambda\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\lambda\%h")
	@if exist sigc++config.h copy "sigc++config.h" "$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\"
	@if exist ..\untracked\MSVC_NMake\sigc++config.h copy "..\untracked\MSVC_NMake\sigc++config.h" "$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\"
