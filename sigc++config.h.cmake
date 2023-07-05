
/* Define to omit deprecated API from the library. */
#cmakedefine SIGCXX_DISABLE_DEPRECATED

/* Major version number of sigc++. */
#cmakedefine SIGCXX_MAJOR_VERSION @SIGCXX_MAJOR_VERSION@

/* Micro version number of sigc++. */
#cmakedefine SIGCXX_MICRO_VERSION @SIGCXX_MICRO_VERSION@

/* Minor version number of sigc++. */
#cmakedefine SIGCXX_MINOR_VERSION @SIGCXX_MINOR_VERSION@

/* Detect Win32 platform */
#ifdef _WIN32
# if defined(_MSC_VER)
#  define SIGC_MSC 1
#  define SIGC_WIN32 1
#  ifndef LIBSIGCXX_STATIC
#   define SIGC_DLL 1
#  endif
# elif defined(__CYGWIN__)
#  define SIGC_CONFIGURE 1
# elif defined(__MINGW32__)
#  define SIGC_WIN32 1
#  define SIGC_CONFIGURE 1
# else
#  error "libsigc++ config: Unknown win32 architecture (send me gcc --dumpspecs or equiv)"
# endif
#else /* !_WIN32 */
# define SIGC_CONFIGURE 1
#endif /* !_WIN32 */

#ifdef SIGC_MSC
/*
 * Visual C++ Warning C4251 says that the classes to any member objects in an
 * exported class must also be exported.  Some of the libsigc++
 * template classes contain std::list members.  MS KB article 168958 says
 * that it's not possible to export a std::list instantiation due to some
 * wacky class nesting issues, so our only options are to ignore the
 * warning or to modify libsigc++ to remove the std::list dependency.
 * AFAICT, the std::list members are used internally by the library code
 * and don't need to be used from the outside, and ignoring the warning
 * seems to have no adverse effects, so that seems like a good enough
 * solution for now.
 */
# pragma warning(disable:4251)

#else /* SIGC_MSC */

#endif /* !SIGC_MSC */

#ifdef SIGC_DLL
# ifdef SIGC_BUILD
#  define SIGC_API __declspec(dllexport)
# elif !defined(SIGC_BUILD)
#  define SIGC_API __declspec(dllimport)
# else
#  define SIGC_API
# endif
#else /* !SIGC_DLL */
# define SIGC_API
#endif /* !SIGC_DLL */
