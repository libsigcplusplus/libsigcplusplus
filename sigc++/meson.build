# sigc++

# Input: sigcxx_build_dep, sigcxx_pcname, sigcxx_libversion, install_includedir
# Output: source_h_files, sigcxx_dep

# There are no built source files in libsigc++-3.0.

source_cc_files = [
  'connection.cc',
  'signal_base.cc',
  'trackable.cc',
  'functors' / 'slot_base.cc',
]

sigc_h_files = [
  'bind.h',
  'bind_return.h',
  'connection.h',
  'limit_reference.h',
  'member_method_trait.h',
  'reference_wrapper.h',
  'retype_return.h',
  'signal.h',
  'signal_base.h',
  'slot.h',
  'trackable.h',
  'type_traits.h',
  'visit_each.h',
  'weak_raw_ptr.h',
]
adaptors_h_files = [
  'adaptors' / 'adaptor_base.h',
  'adaptors' / 'adaptors.h',
  'adaptors' / 'adaptor_trait.h',
  'adaptors' / 'adapts.h',
  'adaptors' / 'bind.h',
  'adaptors' / 'bind_return.h',
  'adaptors' / 'bound_argument.h',
  'adaptors' / 'compose.h',
  'adaptors' / 'exception_catch.h',
  'adaptors' / 'hide.h',
  'adaptors' / 'retype.h',
  'adaptors' / 'retype_return.h',
  'adaptors' / 'track_obj.h',
  'adaptors' / 'tuple_visitor_visit_each.h',
]
functors_h_files = [
  'functors' / 'functor_trait.h',
  'functors' / 'functors.h',
  'functors' / 'mem_fun.h',
  'functors' / 'ptr_fun.h',
  'functors' / 'slot.h',
  'functors' / 'slot_base.h',
]
tuple_utils_h_files = [
  'tuple-utils' / 'tuple_cdr.h',
  'tuple-utils' / 'tuple_end.h',
  'tuple-utils' / 'tuple_for_each.h',
  'tuple-utils' / 'tuple_start.h',
  'tuple-utils' / 'tuple_transform_each.h',
]

source_h_files = sigc_h_files + adaptors_h_files + functors_h_files + tuple_utils_h_files

install_headers('sigc++.h', subdir: sigcxx_pcname / 'sigc++')
install_headers(sigc_h_files, subdir: sigcxx_pcname / 'sigc++')
install_headers(adaptors_h_files, subdir: sigcxx_pcname / 'sigc++' / 'adaptors')
install_headers(functors_h_files, subdir: sigcxx_pcname / 'sigc++' / 'functors')
install_headers(tuple_utils_h_files, subdir: sigcxx_pcname / 'sigc++' / 'tuple-utils')

extra_sigc_cppflags = []

# Make sure we are exporting the symbols from the DLL
if is_msvc
  extra_sigc_cppflags += ['-DSIGC_BUILD', '-D_WINDLL']
endif

extra_include_dirs = ['..']
sigcxx_library = library(sigcxx_pcname,
  source_cc_files,
  version: sigcxx_libversion,
  include_directories: extra_include_dirs,
  cpp_args: extra_sigc_cppflags,
  dependencies: sigcxx_build_dep,
  install: true,
)

# This is useful in the main project when libsigc++ is used as a subproject.
# It's also used when building example programs and test programs.
sigcxx_dep = declare_dependency(
  link_with: sigcxx_library,
  include_directories: extra_include_dirs,
  dependencies: sigcxx_build_dep
)