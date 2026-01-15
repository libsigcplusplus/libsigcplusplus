# NMake Makefile snippet for copying the built libraries, utilities and headers to
# a path under $(PREFIX).

install: all
	@if not exist $(PREFIX)\bin\ md $(PREFIX)\bin
	@if not exist $(PREFIX)\lib\sigc++-$(SIGC_SERIES)\include\ md $(PREFIX)\lib\sigc++-$(SIGC_SERIES)\include
	@if not exist $(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\adaptors\ @md $(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\adaptors
	@if not exist $(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\functors\ @md $(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\functors
	@if not exist $(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\tuple-utils\ @md $(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\tuple-utils
	@if "$(STATIC)" == "" copy /b $(LIBSIGC_DLL) $(PREFIX)\bin
	@if "$(STATIC)" == "" copy /b $(LIBSIGC_DLL:.dll=.pdb) $(PREFIX)\bin
	@copy /b $(LIBSIGC_LIB) $(PREFIX)\lib
	@copy "..\sigc++\sigc++.h" "$(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\"
	@for %h in ($(LIBSIGC_INT_HDRS)) do @copy "..\sigc++\%h" "$(PREFIX)\include\sigc++-$(SIGC_SERIES)\sigc++\%h"
	@if exist sigc++config.h copy "sigc++config.h" "$(PREFIX)\lib\sigc++-$(SIGC_SERIES)\include\"
	@if exist ..\untracked\MSVC_NMake\sigc++config.h copy "..\untracked\MSVC_NMake\sigc++config.h" "$(PREFIX)\lib\sigc++-$(SIGC_SERIES)\include\"
