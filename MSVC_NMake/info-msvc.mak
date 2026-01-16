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
	@echo found, default is $$(srcrootdir)\..\vs$$(short_vs_ver)\$$(platform),
	@echo where $$(short_vs_ver) is 14 for VS 2015 and so on;
	@echo and $$(platform) is Win32 for 32-bit builds and x64 for x64 builds.
	@echo.
	@echo BASE_INCLUDEDIR: Optional, base directory of where headers of dependencies
	@echo can be found, default is $$(PREFIX)\include. Can be overridden with
	@echo BOOST_INCLUDEDIR as needed.
	@echo.
	@echo BASE_LIBDIR: Optional, base directory of where .lib's of dependencies
	@echo can be found, default is $$(PREFIX)\lib. Can be overridden with
	@echo BOOST_LIBDIR as needed.
	@echo.
	@echo BOOST_INCLUDEDIR: Optional, directory of where where Boost C++ headers
	@echo can be found, default is $(BASE_INCLUDEDIR)\include. You need to include,
	@echo if any, the subdirectory for your Boost headers for your installation,
	@echo so for Boost-1_89 for instance, you need to say
	@echo BOOST_INCLUDEDIR=^<some_dir^>\boost-1_89.
	@echo.
	@echo BOOST_LIBDIR: Optional, directory of where where Boost C++ .lib's can
	@echo be found, default is $$(BASE_LIBDIR).
	@echo.
	@echo BOOST_DLL: Optional, set to 1 if building against a DLL build of Boost.
	@echo.
	@echo STATIC: Optional, enable to build static libsigc++.  Define
	@echo LIBSIGCXX_STATIC in the compiler flags to use the static build of
	@echo libsigc++.
	@echo.
	@echo PERL, M4: Path to the PERL intepreter and the m4 utility program, if not in ^%PATH^%.
	@echo PERL is needed for all builds and m4 is needed if building from a GIT checkout. As
	@echo an alternative to using M4, one can use UNIX_TOOLS_BINDIR instead to point to the
	@echo directory where m4.exe is located, such as Cygwin's or MSYS2/MSYS64's 'bin' directory,
	@echo as other UNIXy tools may be used during code generation for a build from a GIT checkout.
	@echo.
	@echo ======
	@echo A 'clean' target is supported to remove all generated files, intermediate
	@echo object files and binaries for the specified configuration.
	@echo.
	@echo An 'install' target is supported to copy the build (DLLs, LIBs, along with
	@echo the header files) to appropriate locations under $$(PREFIX).
	@echo.
	@echo A 'tests' target is supported to build the test programs, and a 'benchmark'
	@echo target is supported to build the benchmarking program.  Note that the
	@echo benchmarking program requires the Boost C++ libraries to build, and you need
	@echo to pass in BOOST_DLL=1 to the NMake command line if your Boost libraries are
	@echo built as DLLs.
	@echo ======
	@echo.
