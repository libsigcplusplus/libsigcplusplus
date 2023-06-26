# NMake Makefile snippet for copying the built libraries, utilities and headers to
# a path under $(PREFIX).

install: all
	@if not exist $(PREFIX)\bin\ md $(PREFIX)\bin
	@if not exist $(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\ md $(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors\ @md $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\adaptors
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors\ @md $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\functors
	@if not exist $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\tuple-utils\ @md $(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\tuple-utils
	@if "$(STATIC)" == "" copy /b $(LIBSIGC_DLL) $(PREFIX)\bin
	@if "$(STATIC)" == "" copy /b $(LIBSIGC_DLL:.dll=.pdb) $(PREFIX)\bin
	@copy /b $(LIBSIGC_LIB) $(PREFIX)\lib
	@copy "..\sigc++\sigc++.h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\"
	@for %h in ($(LIBSIGC_INT_HDRS)) do @copy "..\sigc++\%h" "$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\sigc++\%h"
	@if exist sigc++config.h copy "sigc++config.h" "$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\"
	@if exist ..\untracked\MSVC_NMake\sigc++config.h copy "..\untracked\MSVC_NMake\sigc++config.h" "$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include\"
