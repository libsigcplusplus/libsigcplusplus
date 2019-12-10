# docs/docs/manual

# input: install_datadir, sigcxx_pcname, tutorial_custom_cmd, python3,
#        build_documentation, dist_cmd, book_name
# output: can_parse_and_validate, build_pdf_by_default, can_build_pdf,
#         install_tutorialdir

# xsltproc is required by tutorial_custom_cmd html.
xsltproc = find_program('xsltproc', required: build_documentation)
xmllint = find_program('xmllint', required: false)

can_parse_and_validate = xmllint.found()

validate = get_option('validation') ? 'true' : 'false'

dblatex = find_program('dblatex', required: false)
can_build_pdf = dblatex.found() or (xmllint.found() and \
                find_program('docbook2pdf', required: false).found())
build_pdf_by_default = get_option('build-pdf')

# Installation directories are relative to {prefix}.
install_tutorialdir = install_datadir / 'doc' / book_name / 'tutorial'

if not build_documentation
  # Documentation shall not be built or installed.
  # Return to the calling meson.build file.
  subdir_done()
endif

doc_dist_dir = 'untracked' / 'docs' / 'docs' / 'manual' # Relative to MESON_DIST_ROOT

sigc_manual_xml = 'libsigc_manual.xml'
sigc_manual_pdf = 'libsigc_manual.pdf'

# Create an html version of the DocBook.
custom_target('manual_html',
  input: sigc_manual_xml,
  output: 'html',
  command: [
    python3, tutorial_custom_cmd, 'html',
    '@INPUT@',
    '@OUTPUT@',
  ],
  build_by_default: true,
  install: true,
  install_dir: install_tutorialdir
)

if can_parse_and_validate
  # Parse and possibly validate the DocBook.
  custom_target('manual_xmllint',
    input: sigc_manual_xml,
    output: 'manual_xmllint.stamp',
    command: [
      python3, tutorial_custom_cmd, 'xmllint',
      validate,
      '@INPUT@',
      '@OUTPUT@'
    ],
    build_by_default: true,
  )
endif

if can_build_pdf
  # Create a PDF file of the DocBook.
  # Prefer dblatex, if both dblatex and docbook2pdf are available.
  custom_target('manual_pdf',
    input: sigc_manual_xml,
    output: sigc_manual_pdf,
    command: [
      python3, tutorial_custom_cmd,
      dblatex.found() ? 'dblatex' : 'docbook2pdf',
      '@INPUT@',
      '@OUTPUT@'
    ],
    build_by_default: build_pdf_by_default,
  )
endif

if not meson.is_subproject()
  # Distribute built files.
  # (add_dist_script() is not allowed in a subproject)
  meson.add_dist_script(
    python3.path(), dist_cmd,
    python3.path(), tutorial_custom_cmd, 'dist_doc',
    doc_dist_dir,
    meson.current_build_dir(),
    meson.current_source_dir() / sigc_manual_xml,
    meson.current_build_dir() / sigc_manual_pdf,
  )
endif
