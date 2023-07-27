# docs/docs/reference

# Input: project_build_root, project_source_root, sigcxx_pcname,
#        sigcxx_api_version, build_documentation, source_h_files,
#        hg_ccg_basenames, install_datadir, python3, doc_reference,
#        can_add_dist_script, dot
# Output: install_docdir, install_devhelpdir, book_name,
#         if build_documentation: tag_file

# There are no built source files in libsigc++-3.0.

tag_file_modules = [
  'mm-common-libstdc++',
]
doxygen_tagfiles = ''
doxygen_tag_targets = []
docinstall_flags = []
foreach module : tag_file_modules
  depmod = dependency(module, required: false)
  if depmod.found()
    doxytagfile = depmod.get_variable(pkgconfig: 'doxytagfile', internal: 'doxytagfile', default_value: '')
    if doxytagfile != ''
      if depmod.type_name() == 'internal'
        # Subprojects must build their tag files before doxygen is called.
        if module.startswith('mm-common')
          doxygen_tag_targets += subproject('mm-common').get_variable('global_tag_file_target')
        else
          doxygen_tag_targets += subproject(module).get_variable('global_tag_file_target')
        endif
      endif
      htmlrefpub = depmod.get_variable(pkgconfig: 'htmlrefpub', internal: 'htmlrefpub', default_value: '')
      htmlrefdir = depmod.get_variable(pkgconfig: 'htmlrefdir', internal: 'htmlrefdir', default_value: '')
      if htmlrefpub == ''
        htmlrefpub = htmlrefdir
      elif htmlrefdir == ''
        htmlrefdir = htmlrefpub
      endif
      doxygen_tagfiles += ' "' + doxytagfile + '=' + htmlrefpub + '"'

      # Doxygen <= 1.8.15
      docinstall_flags += ['-l', doxytagfile.split('/')[-1] + '@' + htmlrefdir]
      if htmlrefpub != htmlrefdir
        # Doxygen >= 1.8.16
        docinstall_flags += ['-l', 's@' + htmlrefpub + '@' + htmlrefdir]
      endif
    endif
  endif
endforeach

book_name = 'lib' + sigcxx_pcname
book_title = meson.project_name() + ' Reference Manual'

# Configuration data for Doxyfile.
doc_conf_data = configuration_data()
doc_conf_data.set('configure_input',
  'docs/docs/reference/Doxyfile. Generated from Doxyfile.in by meson.configure_file().')
doc_conf_data.set('PACKAGE_NAME', meson.project_name())
doc_conf_data.set('PACKAGE_VERSION', meson.project_version())
doc_conf_data.set('abs_top_builddir', project_build_root)
doc_conf_data.set('abs_top_srcdir', project_source_root)
doc_conf_data.set('SIGCXX_API_VERSION', sigcxx_api_version)
doc_conf_data.set('DOXYGEN_TAGFILES', doxygen_tagfiles)
doc_conf_data.set('DOXYGEN_HAVE_DOT', dot.found() ? 'YES' : 'NO')

doxyfile = configure_file(
  input: 'Doxyfile.in',
  output: '@BASENAME@',
  configuration: doc_conf_data,
)

# Installation directories relative to {prefix}.
install_docdir = install_datadir / 'doc' / book_name
install_reference_docdir = install_docdir / 'reference'
install_devhelpdir = install_datadir / 'devhelp' / 'books' / book_name

if not build_documentation
  # Documentation shall not be built or installed.
  # Return to the calling meson.build file.
  subdir_done()
endif

# Input .h files to Doxygen.
src_h_files = []
foreach file : source_h_files
  src_h_files += project_source_root / 'sigc++' / file
endforeach
src_h_files += project_source_root / 'sigc++' / 'sigc++.h'

doctool_dir = project_source_root / 'untracked' / 'docs' / 'docs' # MMDOCTOOLDIR
doctool_dist_dir = 'untracked' / 'docs' / 'docs' # Relative to MESON_DIST_ROOT

tag_file = custom_target('html_and_tag',
  input: src_h_files,
  output: book_name + '.tag',
  command: [
    python3, doc_reference, 'doxygen',
    doctool_dir,
    '@OUTPUT@',
    '@INPUT@',
  ],
  depend_files: doxyfile,
  depends: doxygen_tag_targets,
  build_by_default: build_documentation,
  install: true,
  install_dir: install_reference_docdir,
)

devhelp_file = custom_target('devhelp',
  input: tag_file,
  output: book_name + '.devhelp2',
  command: [
    python3, doc_reference, 'devhelp',
    doctool_dir,
    '@INPUT@',
    '@OUTPUT@',
    book_name,
    book_title,
  ],
  build_by_default: build_documentation,
)

# Install Devhelp file and html files.
meson.add_install_script(
  python3, doc_reference, 'install_doc',
  doctool_dir,
  devhelp_file.full_path(),
  install_devhelpdir,
  install_reference_docdir / 'html',
  docinstall_flags
)

if can_add_dist_script
  # Distribute built files and files copied by mm-common-get.
  meson.add_dist_script(
    python3, doc_reference, 'dist_doc',
    doctool_dir,
    doctool_dist_dir,
    meson.current_build_dir(),
    tag_file.full_path(),
    devhelp_file.full_path(),
  )
endif
