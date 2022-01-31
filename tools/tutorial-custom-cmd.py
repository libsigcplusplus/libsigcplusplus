#!/usr/bin/env python3

# External command, intended to be called with custom_target() in meson.build

#                           argv[1]   argv[2:]
# tutorial-custom-cmd.py <subcommand> <xxx>...

import os
import sys
import subprocess
import shutil

subcommand = sys.argv[1]

def html():
  #      argv[2]          argv[3]
  # <input_xml_file> <output_html_dir>

  input_xml_file = sys.argv[2]
  output_html_dir = sys.argv[3]

  # Set the use.id.as.filename param so that we don't use the chapter / section
  # number as the filename, otherwise the url will change every time anything is
  # re-ordered or inserted in the documentation.
  # For a list of available parameters, see http://docbook.sourceforge.net/release/xsl/current/doc/html/
  xslt_params = [
    '--param', 'toc.section.depth', '1',
    '--stringparam', 'chunker.output.indent', 'yes',
    '--stringparam', 'chunker.output.encoding', 'UTF-8',
    '--stringparam', 'toc.list.type', 'ul',
    '--param', 'use.id.as.filename', '1',
  ]

  # The recommended stylesheet for DocBook V5.0 is .../xsl-ns/...
  # It's not used here because the docbook-xsl-ns package is not available
  # when building with gnome-build-meta.
  xslt_stylesheet = 'http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl'

  # Remove old files and create the destination directory.
  shutil.rmtree(output_html_dir, ignore_errors=True)
  os.makedirs(output_html_dir, exist_ok=True)

  cmd = [
    'xsltproc',
  ] + xslt_params + [
    '-o', output_html_dir + '/',
    '--xinclude',
    xslt_stylesheet,
    input_xml_file,
  ]
  result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                          universal_newlines=True)
  # xsltproc prints the names of all written files. Don't print those lines.
  for line in result.stdout.splitlines():
    if not line.startswith('Writing '):
      print(line)

  return result.returncode

def xmllint():
  from pathlib import Path

  #  argv[2]       argv[3]          argv[4]
  # <validate> <input_xml_file> <stamp_file_path>

  validate = sys.argv[2]
  input_xml_file = sys.argv[3]
  stamp_file_path = sys.argv[4]

  relax_ng_schema = 'http://docbook.org/xml/5.0/rng/docbook.rng'
  # schematron_schema = 'http://docbook.org/xml/5.0/sch/docbook.sch'

  # Validation against the Schematron schema does not work on Ubuntu 21.04:
  # file:///usr/share/xml/docbook/schema/schematron/5.0/docbook.sch:6: element rule:
  #   Schemas parser error : Failed to compile context expression db:firstterm[@linkend]
  # .....
  # Schematron schema http://docbook.org/xml/5.0/sch/docbook.sch failed to compile

  cmd = [
    'xmllint',
    '--noout',
    '--noent',
    '--xinclude',
  ]
  if validate == 'true':
    cmd += [
      '--relaxng', relax_ng_schema,
      #'--schematron', schematron_schema,
    ]
  cmd += [input_xml_file]
  result = subprocess.run(cmd)
  if result.returncode:
    return result.returncode

  Path(stamp_file_path).touch(exist_ok=True)
  return 0

# dblatex and xsltproc+fop generate a PDF file.
# docbook2pdf can generate PDF files from DocBook4 files, but not from DocBook5 files.
# xsltproc+xmlroff (version 0.6.3) does not seem to work acceptably.
def dblatex():
  #      argv[2]         argv[3]
  # <input_xml_file> <output_pdf_file>
  # Create a PDF file, using dblatex.

  input_xml_file = sys.argv[2]
  output_pdf_file = sys.argv[3]

  # For a list of available parameters, see http://dblatex.sourceforge.net/doc/manual/
  dblatex_params = [
    '-P', 'toc.section.depth=1',
    '-P', 'paper.type=a4paper',
    '-P', 'doc.collab.show=1',
    '-P', 'latex.output.revhistory=0',
  ]

  cmd = [
    'dblatex',
  ] + dblatex_params + [
    '-o', output_pdf_file,
    '--pdf',
    input_xml_file,
  ]
  return subprocess.run(cmd).returncode

def fop():
  #      argv[2]         argv[3]
  # <input_xml_file> <output_pdf_file>
  # Create a PDF file, using fop.

  input_xml_file = sys.argv[2]
  output_pdf_file = sys.argv[3]

  fo_file = os.path.splitext(output_pdf_file)[0] + '.fo'

  # For a list of available parameters, see http://docbook.sourceforge.net/release/xsl/current/doc/fo/
  # For a list of available paper types, see the description of the page.width.portrait parameter.
  xslt_params = [
    '--param', 'toc.section.depth', '1',
    '--stringparam', 'fop1.extensions', '1',
    '--stringparam', 'page.orientation', 'portrait',
    '--stringparam', 'paper.type', 'A4',
  ]

  xslt_stylesheet = 'http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl'

  # Generate a .fo (formatting object) file.
  # fop can take an xslt stylesheet parameter, but it can only read local files.
  # xsltproc is necessary if you want to read the stylesheet from the internet.
  cmd = [
    'xsltproc',
  ] + xslt_params + [
    '-o', fo_file,
    '--xinclude',
    xslt_stylesheet,
    input_xml_file,
  ]
  result = subprocess.run(cmd)
  if result.returncode:
    return result.returncode

  cmd = [
    'fop',
    '-fo', fo_file,
    '-pdf', output_pdf_file,
  ]
  return subprocess.run(cmd).returncode

# Invoked from meson.add_dist_script().
def dist_doc():
  #    argv[2]        argv[3]        argv[4]    argv[5]
  # <doc_dist_dir> <doc_build_dir> <xml_file> <pdf_file>

  # <doc_dist_dir> is a distribution directory, relative to MESON_PROJECT_DIST_ROOT.
  # <doc_build_dir> is a relative or absolute path in the build directory.
  # <xml_file> is a relative or absolute path in the source directory.
  # <pdf_file> is a relative or absolute path in the build directory.

  # MESON_PROJECT_DIST_ROOT is set only if meson.version() >= 0.58.0.
  project_dist_root = os.getenv('MESON_PROJECT_DIST_ROOT', os.getenv('MESON_DIST_ROOT'))
  doc_dist_dir = os.path.join(project_dist_root, sys.argv[2])
  doc_build_dir = sys.argv[3]
  xml_file = sys.argv[4]
  pdf_file = sys.argv[5]

  # Create the distribution directory, if it does not exist.
  os.makedirs(doc_dist_dir, exist_ok=True)

  # Distribute built html files.
  shutil.copytree(os.path.join(doc_build_dir, 'html'),
                  os.path.join(doc_dist_dir, 'html'),
                  copy_function=shutil.copy)

  # If there is an updated PDF file, distribute it.
  if os.path.isfile(pdf_file) and \
     os.stat(pdf_file).st_mtime > os.stat(xml_file).st_mtime:
    shutil.copy(pdf_file, doc_dist_dir)
  else:
    print('--- Info: No updated PDF file found.')

  return 0

# ----- Main -----
if subcommand == 'html':
  sys.exit(html())
if subcommand == 'xmllint':
  sys.exit(xmllint())
if subcommand == 'dblatex':
  sys.exit(dblatex())
if subcommand == 'fop':
  sys.exit(fop())
if subcommand == 'dist_doc':
  sys.exit(dist_doc())
print(sys.argv[0], ': illegal subcommand,', subcommand)
sys.exit(1)
