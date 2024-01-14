# This file is part of libsigc++.

project('libsigc++', 'cpp',
  version: '3.6.0',
  license: 'LGPLv2.1+',
  default_options: [
    'cpp_std=c++17',
    'warning_level=1',
  ],
  meson_version: '>= 0.55.0', # required for meson.add_dist_script(python3, ...)
                              # and meson.add_install_script(python3, ...)
)

sigcxx_api_version = '3.0'
sigcxx_pcname = 'sigc++-' + sigcxx_api_version

sigcxx_version_array = meson.project_version().split('.')
sigcxx_major_version = sigcxx_version_array[0].to_int()
sigcxx_minor_version = sigcxx_version_array[1].to_int()
sigcxx_micro_version = sigcxx_version_array[2].to_int()

# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
# The relation between libtool's current:revison:age interface versioning
# and the .so filename, .so.x.y.z, is
# x = current - age
# y = age
# z = revision
# If libtool_soversion is updated as described in libtool's documentation,
# x.y.z will usually *not* be equal to meson.project_version().
libtool_soversion = [0, 0, 0]
sigcxx_libversion = '@0@.@1@.@2@'.format(
  libtool_soversion[0] - libtool_soversion[2],
  libtool_soversion[2],
  libtool_soversion[1])
darwin_versions = [libtool_soversion[0] + 1, '@0@.@1@'.format(libtool_soversion[0] + 1, libtool_soversion[1])]

# Use these instead of meson.source_root() and meson.build_root() in subdirectories.
# source_root() and build_root() are not useful, if this is a subproject.
project_source_root = meson.current_source_dir()
project_build_root = meson.current_build_dir()

cpp_compiler = meson.get_compiler('cpp')
is_msvc = cpp_compiler.get_id() == 'msvc'
python3 = find_program('python3', version: '>=3.5')

# MSVC: We currently do not support shared and static builds at the,
#       same time, since we need different defines/cflags for proper
#       linking.
if is_msvc
  if get_option('default_library') == 'both'
    error('-Ddefault_library=both is currently not supported for Visual Studio')
  endif
  is_msvc_static = get_option('default_library') == 'static'
else
  is_msvc_static = false
endif

# Do we build from a git repository?
# Suppose we do if and only if the meson.build file is tracked by git.
cmd_py = '''
import shutil, subprocess, sys
git_exe = shutil.which('git')
if not git_exe:
  sys.exit(1)
cmd = [ git_exe, 'ls-files', '--error-unmatch', 'meson.build' ]
sys.exit(subprocess.run(cmd, cwd=sys.argv[1], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode)
'''
is_git_build = run_command(
  python3, '-c', cmd_py,
  project_source_root,
  check: false,
).returncode() == 0

# Are we testing a dist tarball while it's being built?
# There ought to be a better way. https://github.com/mesonbuild/meson/issues/6866
is_dist_check = project_source_root.contains('dist-unpack') and \
                project_build_root.contains('dist-build')

# Options.
maintainer_mode_opt = get_option('maintainer-mode')
maintainer_mode = maintainer_mode_opt == 'true' or \
                 (maintainer_mode_opt == 'if-git-build' and is_git_build)
if is_dist_check
  message('Looks like a tarball is being tested. ' + \
          'Option "dist-warnings" is used instead of "warnings".')
  cpp_warnings = get_option('dist-warnings')
else
  cpp_warnings = get_option('warnings')
endif
if get_option('warning_level') in ['0','1','2','3','4','5']
  warning_level = get_option('warning_level').to_int()
else
  # For instance get_option('warning_level') == 'everything'
  warning_level = 99
endif
werror = get_option('werror')
build_deprecated_api = get_option('build-deprecated-api')
build_documentation_opt = get_option('build-documentation')
build_documentation = build_documentation_opt == 'true' or \
                     (build_documentation_opt == 'if-maintainer-mode' and maintainer_mode)
build_examples = get_option('build-examples')
build_tests = get_option('build-tests')
do_benchmark = get_option('benchmark')

# Installation directories are relative to {prefix}.
install_prefix = get_option('prefix')
install_includedir = get_option('includedir')
install_libdir = get_option('libdir')
install_datadir = get_option('datadir')
install_pkgconfigdir = install_libdir / 'pkgconfig'

# Dependencies.
# sigcxx_build_dep: Dependencies when building the libsigc++ library.
# sigcxx_dep (created in sigc++/meson.build):
#   Dependencies when using the libsigc++ library.
sigcxx_build_dep = [] # No dependencies

benchmark_dep = dependency('boost', modules: ['system', 'timer'],
                           version: '>=1.20.0', required: do_benchmark)
can_benchmark = benchmark_dep.found()

if is_msvc
  # We must have Visual Studio 2017 15.7 or later...
  assert(cpp_compiler.version().split('.')[0].to_int() >= 19 and \
         cpp_compiler.version().split('.')[1].to_int() >= 15,
         'Visual Studio 2017 15.7 or later is required')
endif

# Some dependencies are required only in maintainer mode and/or
# if documentation shall be built.
mm_common_get = find_program('mm-common-get', required: false)

if maintainer_mode and not mm_common_get.found()
  message('Maintainer mode requires the \'mm-common-get\' command. If it is not found,\n' +
          'use \'-Dmaintainer-mode=false\' or install the \'mm-common\' package, version 1.0.0 or higher.')
  # If meson --wrap-mode != forcefallback, Meson falls back to the mm-common
  # subproject only if mm-common-get is required.
  mm_common_get = find_program('mm-common-get', required: true)
endif

doxygen = find_program('doxygen', required: build_documentation)
dot = find_program('dot', required: false) # Used by Doxygen, if found
xsltproc = find_program('xsltproc', required: build_documentation)

if build_documentation and not dot.found()
  message('The \'dot\' command is not found.\n  ' + \
          'This will affect the look of the inheritance diagrams in the documentation.')
endif

script_dir = project_source_root / 'untracked' / 'build_scripts'
doc_reference = script_dir / 'doc-reference.py'
dist_changelog = script_dir / 'dist-changelog.py'
dist_build_scripts = script_dir / 'dist-build-scripts.py'
tutorial_custom_cmd = project_source_root / 'tools' / 'tutorial-custom-cmd.py'

if maintainer_mode
  # Copy files to untracked/build_scripts and untracked/docs/docs.
  run_command(mm_common_get, '--force', script_dir,
    project_source_root / 'untracked' / 'docs' / 'docs',
    check: true,
  )
elif not import('fs').is_file(doc_reference)
  warning('Missing files in untracked/.\n  ' + \
  'Enable maintainer-mode if you want to build documentation or create a dist tarball.')
endif

# Check if perl is required and available.
doc_perl_prop = run_command(
  python3, doc_reference, 'get_script_property',
  '', # MMDOCTOOLDIR is not used
  'requires_perl',
  check: false,
)
if not (doc_perl_prop.returncode() == 0 and doc_perl_prop.stdout() == 'false')
  # Perl is required, if documentation shall be built.
  perl = find_program('perl', required: build_documentation)
endif

# Set compiler warnings.
# Meson warns if any of the /W1, /W2, /W3, /W4, /Wall, -Wall, -Wextra, -Werror
# compiler options are added with add_project_arguments().
# Avoid such warnings, when possible.
# See _warn_about_builtin_args() in meson/mesonbuild/interpreter/interpreter.py.
warning_flags = []
if cpp_warnings == 'min'
  if warning_level == 0
    warning_flags = is_msvc ? ['/W2'] : ['-Wall']
   endif
elif cpp_warnings == 'max' or cpp_warnings == 'fatal'
  if warning_level < 3
    warning_flags = is_msvc ? ['/W4'] : ['-pedantic', '-Wall', '-Wextra']
  endif
  if not is_msvc
    warning_flags += '-Wsuggest-override -Wshadow -Wzero-as-null-pointer-constant -Wformat-security'.split()
  endif
  if cpp_warnings == 'fatal' and not werror
      warning_flags += is_msvc ? ['/WX'] : ['-Werror']
  endif
endif

warning_flags = cpp_compiler.get_supported_arguments(warning_flags)
add_project_arguments(warning_flags, language: 'cpp')

# MSVC: Ignore warnings that aren't really harmful, but make those
#       that should not be overlooked stand out.
static_cxxflag = '-DLIBSIGCXX_STATIC'
if is_msvc
  disable_warnings_list = [
    '/EHsc',  # avoid warnings caused by exception handling model used
  ]

  # Turn off harmless warnings but make potentially dangerous ones glaring,
  # distributed with GLib, if available
  use_recommended_pragmas =  cpp_compiler.get_supported_arguments('/FImsvc_recommended_pragmas.h')
  if use_recommended_pragmas.length() > 0
    add_project_arguments(use_recommended_pragmas, language: 'cpp')
  else
    disable_warnings_list += '/wd4244' # 'conversion' conversion from
                                       # 'type1' to 'type2', possible loss of data
  endif

  if host_machine.cpu_family() == 'x86_64' or host_machine.cpu_family() == 'aarch64'
    # 'var' : conversion from 'size_t' to 'type', possible loss of data (applies on 64-bit builds)
    disable_warnings_list += '/wd4267'
  endif
  add_project_arguments(
    cpp_compiler.get_supported_arguments(disable_warnings_list),
    language: 'cpp'
  )
  if is_msvc_static
    add_project_arguments(static_cxxflag, language: 'cpp')
  endif
endif

# Configure files
pkg_conf_data = configuration_data()
pkg_conf_data.set('prefix', install_prefix)
pkg_conf_data.set('exec_prefix', '${prefix}')
pkg_conf_data.set('libdir', '${exec_prefix}' / install_libdir)
pkg_conf_data.set('datarootdir', '${prefix}' / install_datadir)
pkg_conf_data.set('datadir', '${datarootdir}')
pkg_conf_data.set('includedir', '${prefix}' / install_includedir)
pkg_conf_data.set('top_srcdir', project_source_root)
pkg_conf_data.set('PACKAGE_VERSION', meson.project_version())
pkg_conf_data.set('SIGCXX_API_VERSION', sigcxx_api_version)

if not build_deprecated_api
  pkg_conf_data.set('SIGCXX_DISABLE_DEPRECATED', 1)
endif
pkg_conf_data.set('SIGCXX_MAJOR_VERSION', sigcxx_major_version)
pkg_conf_data.set('SIGCXX_MINOR_VERSION', sigcxx_minor_version)
pkg_conf_data.set('SIGCXX_MICRO_VERSION', sigcxx_micro_version)
pkg_conf_data.set('MSVC_STATIC_CXXFLAG', is_msvc_static ? static_cxxflag : '')

configure_file(
  input: 'sigc++.pc.in',
  output: sigcxx_pcname + '.pc',
  configuration: pkg_conf_data,
  install_dir: install_pkgconfigdir,
)

configure_file(
  input: 'sigc++-uninstalled.pc.in',
  output: sigcxx_pcname + '-uninstalled.pc',
  configuration: pkg_conf_data,
)

sigcxxconfig_h_meson = files('sigc++config.h.meson')
install_includeconfigdir = install_libdir / sigcxx_pcname / 'include'
configure_file(
  input: sigcxxconfig_h_meson,
  output: 'sigc++config.h',
  configuration: pkg_conf_data,
  install_dir: install_includeconfigdir,
)

# add_dist_script() is not allowed in a subproject if meson.version() < 0.58.0.
can_add_dist_script = not meson.is_subproject() or meson.version().version_compare('>= 0.58.0')

#subdir('cmake')
subdir('MSVC_NMake')
subdir('sigc++')
subdir('examples')
subdir('tests')
subdir('docs/docs/reference')
subdir('docs/docs/manual')

if can_add_dist_script
  # Add a ChangeLog file to the distribution directory.
  meson.add_dist_script(
    python3, dist_changelog,
    project_source_root,
  )
  # Don't distribute these files and directories.
  dont_distribute = [
    '.github',
  ]
  # Add build scripts to the distribution directory, and delete .gitignore
  # files and an empty $MESON_PROJECT_DIST_ROOT/build/ directory.
  meson.add_dist_script(
    python3, dist_build_scripts,
    project_source_root,
    'untracked' / 'build_scripts',
    dont_distribute,
  )
endif

if meson.is_subproject()
  pkgconfig_vars = {
    'htmlrefdir': install_prefix / install_docdir / 'reference' / 'html',
    'htmlrefpub': 'https://libsigcplusplus.github.io/libsigcplusplus/reference/html/'
  }
  if build_documentation
    pkgconfig_vars += {'doxytagfile': tag_file.full_path()}
    # May be used in a main project.
    global_tag_file_target = tag_file
  endif
  sigcxx_dep = declare_dependency(
    dependencies: sigcxx_own_dep,
    variables: pkgconfig_vars,
  )

  # A main project that looks for sigcxx_pcname.pc shall find sigcxx_dep.
  meson.override_dependency(sigcxx_pcname, sigcxx_dep)
endif

# Print a summary.
real_maintainer_mode = ''
if maintainer_mode_opt == 'if-git-build'
  real_maintainer_mode = ' (@0@)'.format(maintainer_mode)
endif

real_build_documentation = ''
if build_documentation_opt == 'if-maintainer-mode'
  real_build_documentation = ' (@0@)'.format(build_documentation)
endif

explain_man = ''
if build_manual_opt and not build_manual
  explain_man = ' (requires that documentation is built)'
endif

validate = get_option('validation') and can_parse_and_validate and build_manual
explain_val = ''
if get_option('validation') and not validate
  if not build_manual
    explain_val = ' (requires that the tutorial is built)'
  else
    explain_val = ' (requires xmllint with Relax NG and DocBook V5.0 support)'
  endif
endif

build_pdf = build_pdf_by_default and can_build_pdf and build_manual
explain_pdf = ''
if build_pdf_by_default and not build_pdf
  if not build_manual
    explain_pdf = ' (requires that the tutorial is built)'
  else
    explain_pdf = ' (requires dblatex or (xsltproc and fop))'
  endif
endif

summary = [
  '',
  '------',
  meson.project_name() + ' ' + meson.project_version(),
  '',
  '         Maintainer mode: @0@@1@'.format(maintainer_mode_opt, real_maintainer_mode),
  '       Compiler warnings: @0@ (warning_level: @1@, werror: @2@)'. \
                             format(cpp_warnings, warning_level, werror),
  '    Build deprecated API: @0@'.format(build_deprecated_api),
  'Build HTML documentation: @0@@1@'.format(build_documentation_opt, real_build_documentation),
  '          Build tutorial: @0@@1@'.format(build_manual, explain_man),
  '          XML validation: @0@@1@'.format(validate, explain_val),
  '               Build PDF: @0@@1@'.format(build_pdf, explain_pdf),
  '  Build example programs: @0@'.format(build_examples),
  '     Build test programs: @0@'.format(build_tests),
  '               Benchmark: @0@'.format(do_benchmark),
  'Directories:',
  '                  prefix: @0@'.format(install_prefix),
  '              includedir: @0@'.format(install_prefix / install_includedir),
  '        includesigcxxdir: @0@'.format(install_prefix / install_includedir / sigcxx_pcname),
  '                  libdir: @0@'.format(install_prefix / install_libdir),
  '        includeconfigdir: @0@'.format(install_prefix / install_includeconfigdir),
  '            pkgconfigdir: @0@'.format(install_prefix / install_pkgconfigdir),
  '                 datadir: @0@'.format(install_prefix / install_datadir),
  '                  docdir: @0@'.format(install_prefix / install_docdir),
  '              devhelpdir: @0@'.format(install_prefix / install_devhelpdir),
  '             tutorialdir: @0@'.format(install_prefix / install_tutorialdir),
  '------'
]

message('\n'.join(summary))
