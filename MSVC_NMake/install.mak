# NMake Makefile snippet for copying the built libraries, utilities and headers to
# a path under $(PREFIX).

install: all
	@if not exist $(PREFIX)\bin\ mkdir $(PREFIX)\bin
	@if not exist $(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\ mkdir $(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\lambda\ @mkdir $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\lambda
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors\ @mkdir $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\tuple-utils\ @mkdir $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\tuple-utils
	@copy /b $(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).dll $(PREFIX)\bin
	@copy /b $(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).pdb $(PREFIX)\bin
	@copy /b $(CFG)\$(PLAT)\$(LIBSIGC_LIBNAME).lib $(PREFIX)\lib
	@copy "..\sigc++\sigc++.h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\"
	@for %h in ($(LIBSIGC_INT_HDRS)) do @copy "..\sigc++\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\%h"
	@for %h in ($(base_built_h)) do @copy "..\sigc++\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\%h"
	@for %h in ($(functors_built_h)) do @copy "..\sigc++\functors\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors\%h"
	@for %h in ($(adaptors_built_h)) do @copy "..\sigc++\adaptors\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\%h"
	@for %h in ($(lambda_built_h)) do @copy "..\sigc++\adaptors\lambda\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\lambda\%h"
	@copy "sigc++config.h" "$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\"
