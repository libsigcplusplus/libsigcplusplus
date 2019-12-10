#!/usr/bin/env python3

# External command, intended to be called with custom_target() in meson.build

#                           argv[1]   argv[2:]
# tutorial-custom-cmd.py <subcommand> <xxx>...

import os
import sys
import subprocess
from pathlib import Path
import shutil

subcommand = sys.argv[1]

def html():
  #      argv[2]          argv[3]
  # <input_xml_file> <output_html_dir>

  input_xml_file = sys.argv[2]
  output_html_dir = sys.argv[3]

  # For a list of available parameters, see http://docbook.sourceforge.net/release/xsl/current/doc/html/
  xslt_params = []

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
  #  argv[2]       argv[3]          argv[4]
  # <validate> <input_xml_file> <stamp_file_path>

  validate = sys.argv[2]
  input_xml_file = sys.argv[3]
  stamp_file_path = sys.argv[4]

  cmd = [
    'xmllint',
    '--noout',
    '--noent',
    '--xinclude',
  ]
  if validate == 'true':
    cmd += ['--postvalid']
  cmd += [input_xml_file]
  result = subprocess.run(cmd)
  if result.returncode:
    return result.returncode

  Path(stamp_file_path).touch(exist_ok=True)
  return 0

def dblatex():
  #      argv[2]         argv[3]
  # <input_xml_file> <output_pdf_file>
  # Create a PDF file, using dblatex.

  input_xml_file = sys.argv[2]
  output_pdf_file = sys.argv[3]

  # For a list of available parameters, see http://dblatex.sourceforge.net/doc/manual/
  dblatex_params = [
    '-P', 'toc.section.depth=2',
    '-P', 'paper.type=a4paper',
  ]

  cmd = [
    'dblatex',
  ] + dblatex_params + [
    '-o', output_pdf_file,
    '--pdf', input_xml_file,
  ]
  return subprocess.run(cmd).returncode

def docbook2pdf():
  #      argv[2]         argv[3]
  # <input_xml_file> <output_pdf_file>
  # Create a PDF file, using docbook2pdf.

  input_xml_file = sys.argv[2]
  output_pdf_file = sys.argv[3]

  output_dir = os.path.dirname(output_pdf_file)
  if not output_dir:
    output_dir = '.'
  output_basename = os.path.basename(output_pdf_file)
  if output_basename.endswith('.pdf'):
    output_basename = output_basename[:-4]
  xml_file = os.path.join(output_dir, output_basename + '.xml')

  # We need to produce an XML file with all of the XIncludes done.
  cmd = [
    'xmllint',
    '--xinclude',
    '--postvalid',
    '--output', xml_file,
    input_xml_file,
  ]
  result = subprocess.run(cmd)
  if result.returncode:
    return result.returncode

  cmd = [
    'docbook2pdf',
    '--output', output_dir,
    xml_file,
  ]
  return subprocess.run(cmd).returncode

# Invoked from meson.add_dist_script().
def dist_doc():
  #    argv[2]        argv[3]        argv[4]    argv[5]
  # <doc_dist_dir> <doc_build_dir> <xml_file> <pdf_file>

  # <doc_dist_dir> is a distribution directory, relative to MESON_DIST_ROOT.
  # <doc_build_dir> is a relative or absolute path in the build directory.
  # <xml_file> is a relative or absolute path in the source directory.
  # <pdf_file> is a relative or absolute path in the build directory.
  doc_dist_dir = os.path.join(os.getenv('MESON_DIST_ROOT'), sys.argv[2])
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
if subcommand == 'docbook2pdf':
  sys.exit(docbook2pdf())
if subcommand == 'dist_doc':
  sys.exit(dist_doc())
print(sys.argv[0], ': illegal subcommand,', subcommand)
sys.exit(1)
