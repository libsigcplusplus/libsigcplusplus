/* sigc++config.h for MSVC  */

#ifndef SIGCXX_CONFIG_H
#define SIGCXX_CONFIG_H

// MS VC7 Warning 4251 says that the classes to any member objects in an
// exported class must be also be exported.  Some of the libsigc++
// template classes contain std::list members.  MS KB article 168958 says
// that it's not possible to export a std::list instantiation due to some
// wacky class nesting issues, so our only options are to ignore the
// warning or to modify libsigc++ to remove the std::list dependency.
// AFAICT, the std::list members are used internally by the library code
// and don't need to be used from the outside, and ignoring the warning
// seems to have no adverse effects, so that seems like a good enough
// solution for now.
//
#pragma warning(disable:4251)

/* configure checks */
// #undef SIGC_GCC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD
#define SIGC_MSVC_TEMPLATE_SPECIALIZATION_OPERATOR_OVERLOAD 1

/* platform specific macros */
// #define LIBSIGC_DISABLE_DEPRECATED
#define SIGC_NEW_DELETE_IN_LIBRARY_ONLY // only defined for MSVC to keep ABI compatibility
#if defined(_WINDLL)
 #define SIGC_API __declspec(dllexport)
#else
 #define SIGC_API __declspec(dllimport)
#endif
#define

#endif // SIGCXX_CONFIG_H
