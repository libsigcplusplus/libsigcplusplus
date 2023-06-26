# NMake Makefile portion for displaying config info

all-build-info:
	@echo.
	@echo ----------
	@echo Build info
	@echo ---------
	@echo Build Type: $(CFG)
	@if not "$(STATIC)" == "" echo Library Build Type: static
	@if "$(STATIC)" == "" echo Library Build Type: DLL

help:
	@echo.
	@echo ==============================
	@echo Building libsigc++ Using NMake
	@echo ==============================
	@echo nmake /f Makefile.vc CFG=[release^|debug] ^<PREFIX=PATH^> ^<STATIC=1^>
	@echo.
	@echo Where:
	@echo ------
	@echo CFG: Required, use CFG=release for an optimized build and CFG=debug
	@echo for a debug build.  PDB files are generated for all builds.
	@echo.
	@echo PREFIX: Optional, the path where dependent libraries and tools may be
	@echo found, default is ^$(srcrootdir)\..\vs^$(short_vs_ver)\^$(platform),
	@echo where ^$(short_vs_ver) is 15 for VS 2017 and so on; and
	@echo ^$(platform) is Win32 for 32-bit builds and x64 for x64 builds.
	@echo.
	@echo STATIC: Optional, enable to build static libsigc++.  Define
	@echo LIBSIGCXX_STATIC in the compiler flags to use the static build of
	@echo libsigc++.
	@echo.
	@echo ======
	@echo A 'clean' target is supported to remove all generated files, intermediate
	@echo object files and binaries for the specified configuration.
	@echo.
	@echo An 'install' target is supported to copy the build (DLLs, LIBs, along with
	@echo the header files) to appropriate locations under ^$(PREFIX).
	@echo.
	@echo A 'tests' target is supported to build the test programs, and a 'benchmark'
	@echo target is supported to build the benchmarking program.  Note that the
	@echo benchmarking program requires the Boost C++ libraries to build, and you need
	@echo to pass in BOOST_DLL=1 to the NMake command line if your Boost libraries are
	@echo built as DLLs.
	@echo ======
	@echo.
