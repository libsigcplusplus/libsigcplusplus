# sigc++

# Input: sigcxx_build_dep, sigcxx_pcname, sigcxx_libversion, sigcxx_api_version,
#        install_includedir, project_source_root, sigc_res, python3,
#        handle_built_files, maintainer_mode, can_add_dist_script
# Output: source_h_files, built_h_files, sigcxx_own_dep, built_files_root,
#         built_h_file_targets

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
  'reference_wrapper.h',
  'retype_return.h',
  'signal_base.h',
  'slot.h',
  'trackable.h',
  'type_traits.h',
  'visit_each.h',
]
adaptors_h_files = [
  'adaptors' / 'adaptors.h',
  'adaptors' / 'bound_argument.h',
]
functors_h_files = [
  'functors' / 'functors.h',
  'functors' / 'slot_base.h',
]

# .m4 files to build .h files from.
sigc_h_m4_files = [
  'limit_reference.h',
  'signal.h',
]

m4_template = files('macros' / 'template.macros.m4')
m4_include_dir = meson.current_source_dir() / 'macros'

source_h_files = sigc_h_files + adaptors_h_files + functors_h_files

built_h_files = sigc_h_m4_files
built_cc_files = []

# Force meson+ninja to generate source files before anything is compiled.
# Compilation must depend on these targets.
built_cc_file_targets = []
built_h_file_targets = []

subdir('adaptors')
subdir('adaptors/lambda')
subdir('functors')

install_headers('sigc++.h', subdir: sigcxx_pcname / 'sigc++')
install_headers(sigc_h_files, subdir: sigcxx_pcname / 'sigc++')
install_headers(adaptors_h_files, subdir: sigcxx_pcname / 'sigc++' / 'adaptors')
install_headers(functors_h_files, subdir: sigcxx_pcname / 'sigc++' / 'functors')

untracked_sigcxx = 'untracked' / 'sigc++'
src_untracked_sigcxx = project_source_root / untracked_sigcxx

extra_sigc_cppflags = []
extra_sigc_objects = []

# Make sure we are exporting the symbols from the DLL
if is_msvc
  extra_sigc_cppflags += ['-DSIGC_BUILD', '-D_WINDLL']
endif

# Build the .rc file for Windows builds and link to it
if host_machine.system() == 'windows'
  windows = import('windows')
  sigc_res = windows.compile_resources(sigc_rc)
  extra_sigc_objects += sigc_res
endif

if maintainer_mode

  # Maintainer mode. Generate .h and .cc files from .m4 files in macros/ directory.
  # .h and .cc files are also generated in subdirectories.

  # docs/reference/meson.build needs this.
  built_files_root = project_build_root

  foreach file : sigc_h_m4_files
    built_h_file_targets += custom_target(file,
      input: 'macros' / file + '.m4',
      output: file,
      command: [
        python3, handle_built_files, 'build_from_m4',
        m4_include_dir,
        '@INPUT@',
        '@OUTPUT@',
      ],
      depend_files: m4_template,
      build_by_default: maintainer_mode,
      install: false,
    )
  endforeach

  extra_include_dirs = ['..']
  sigcxx_library = library('sigc-' + sigcxx_api_version,
    source_cc_files, built_cc_file_targets, built_h_file_targets,
    extra_sigc_objects,
    version: sigcxx_libversion,
    darwin_versions: darwin_versions,
    cpp_args: extra_sigc_cppflags,
    implicit_include_directories: false,
    include_directories: extra_include_dirs,
    dependencies: sigcxx_build_dep,
    install: true,
  )

  built_h_cc_dir = meson.current_build_dir()

else # not maintainer_mode

  # Not maintainer mode. Compile built source code files in
  # project_source_root/untracked/sigc++.

  # docs/reference/meson.build needs this.
  built_files_root = project_source_root / 'untracked'

  # Two cases:
  # 1. The source code comes from a tarball, where the built files
  #    are stored in project_source_root/untracked.
  #    There are no built files in the build tree.
  # 2. Files have been built in the build tree. Then maintainer_mode has
  #    been changed from true to false. Files that are missing or not up to date
  #    in project_source_root/untracked are copied from the build tree.

  # Try to copy built source code files to the source tree.
  run_command(
    python3, handle_built_files, 'copy_built_files',
    meson.current_build_dir(),
    src_untracked_sigcxx,
    built_h_files + built_cc_files,
    check: true,
  )

  untracked_built_cc_files = []
  foreach file : built_cc_files
    untracked_built_cc_files += '..' / 'untracked' / 'sigc++' / file
  endforeach

  extra_include_dirs = [ '..', '..' / 'untracked' ]
  sigcxx_library = library('sigc-' + sigcxx_api_version,
    source_cc_files, untracked_built_cc_files,
    extra_sigc_objects,
    version: sigcxx_libversion,
    darwin_versions: darwin_versions,
    cpp_args: extra_sigc_cppflags,
    implicit_include_directories: false,
    include_directories: extra_include_dirs,
    dependencies: sigcxx_build_dep,
    install: true,
  )

  built_h_cc_dir = src_untracked_sigcxx

endif

# Install built .h files.
meson.add_install_script(
  python3, handle_built_files, 'install_built_h_files',
  built_h_cc_dir,
  install_includedir / sigcxx_pcname / 'sigc++', # subdir below {prefix}
  built_h_files,
)

if can_add_dist_script
  # Distribute built files.
  meson.add_dist_script(
    python3, handle_built_files, 'dist_built_files',
    built_h_cc_dir,
    untracked_sigcxx,
    built_h_files + built_cc_files,
  )
endif

# This is used when building example programs and test programs.
# It's also a part of sigcxx_dep, when libsigc++ is a subproject.
sigcxx_own_dep = declare_dependency(
  sources: built_h_file_targets,
  link_with: sigcxx_library,
  include_directories: extra_include_dirs,
  dependencies: sigcxx_build_dep
)
