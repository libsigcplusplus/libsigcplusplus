#!/usr/bin/env python3

# External command, intended to be called with run_command(), custom_target(),
# meson.add_install_script() and meson.add_dist_script().

#                         argv[1]   argv[2:]
# handle-built-files.py <subcommand> <xxx>...

import os
import sys
import shutil
import subprocess
from pathlib import Path

subcommand = sys.argv[1]

# Invoked from custom_target() in meson.build.
def build_from_m4():
  #     argv[2]      argv[3]      argv[4]
  # <include_dir> <input_file> <output_file>

  include_dir = sys.argv[2]
  input_file = sys.argv[3]
  output_file = sys.argv[4]

  # Create the destination directory, if it does not exist.
  output_dir = os.path.dirname(output_file)
  os.makedirs(output_dir, exist_ok=True)

  cmd = [
    'm4',
    '-I', include_dir,
    input_file,
  ]
  with open(output_file, mode='w') as output_file_obj:
    return subprocess.run(cmd, stdout=output_file_obj).returncode

# Invoked from meson.add_install_script().
def install_built_h_files():
  #    argv[2]       argv[3]          argv[4:]
  # <built_h_dir> <install_subdir> <built_h_files>...

  # <built_h_dir> is an absolute path in the build directory or source directory.
  # <install_subdir> is an installation directory, relative to {prefix}.
  built_h_dir = sys.argv[2]
  install_dir_root = os.path.join(os.getenv('MESON_INSTALL_DESTDIR_PREFIX'), sys.argv[3])

  quiet = bool(os.getenv('MESON_INSTALL_QUIET'))
  for file in sys.argv[4:]:
    path_h = os.path.join(built_h_dir, file)
    rel_dir = os.path.dirname(file)
    if rel_dir:
      install_dir = os.path.join(install_dir_root, rel_dir)
    else:
      install_dir = install_dir_root
    if not quiet:
      print('Installing ', path_h, ' to ', install_dir)

    # Create the installation directory, if it does not exist.
    os.makedirs(install_dir, exist_ok=True)

    # shutil.copy2() copies timestamps and some other file metadata.
    shutil.copy2(path_h, install_dir)
  return 0

# Invoked from meson.add_dist_script().
def dist_built_files(is_msvc_files=False):
  #     argv[2]        argv[3]     argv[4:]
  # <built_h_cc_dir> <dist_dir> <built_files>...

  # <built_h_cc_dir> is an absolute path in the build directory or source directory.
  # <dist_dir> is a distribution directory, relative to MESON_PROJECT_DIST_ROOT.

  # MESON_PROJECT_DIST_ROOT is set only if meson.version() >= 0.58.0.
  project_dist_root = os.getenv('MESON_PROJECT_DIST_ROOT', os.getenv('MESON_DIST_ROOT'))
  built_h_cc_dir = sys.argv[2]
  dist_dir_root = os.path.join(project_dist_root, sys.argv[3])
  dist_dir = dist_dir_root

  # Distribute .h and .cc files built from .m4 files, or generated MSVC files.
  for file in sys.argv[4:]:
    if not is_msvc_files:
      dist_dir = os.path.join(dist_dir_root, os.path.dirname(file))

    # Create the distribution directory, if it does not exist.
    os.makedirs(dist_dir, exist_ok=True)

    shutil.copy(os.path.join(built_h_cc_dir, file), dist_dir)
  return 0

# Invoked from run_command() in meson.build.
def copy_built_files():
  #  argv[2]    argv[3]    argv[4:]
  # <from_dir> <to_dir> <file_names>...

  # <from_dir> is an absolute or relative path of the directory to copy from.
  # <to_dir> is an absolute or relative path of the directory to copy to.
  from_dir_root = sys.argv[2]
  to_dir_root = sys.argv[3]

  # Copy some built files if they exist in from_dir, but not in the destination
  # directory, or if they are not up to date in the destination directory.
  # (The term "source directory" is avoided here, because from_dir might not
  # be what Meson calls a source directory as opposed to a build directory.)

  # Copy .h and .cc files built from .m4 files.
  for file in sys.argv[4:]:
    from_file = os.path.join(from_dir_root, file)
    to_file = os.path.join(to_dir_root, file)
    if os.path.isfile(from_file) and ((not os.path.isfile(to_file))
       or (os.stat(from_file).st_mtime > os.stat(to_file).st_mtime)):

      # Create the destination directory, if it does not exist.
      os.makedirs(os.path.dirname(to_file), exist_ok=True)

      shutil.copy(from_file, to_file)
  return 0

# ----- Main -----
if subcommand == 'build_from_m4':
  sys.exit(build_from_m4())
if subcommand == 'install_built_h_files':
  sys.exit(install_built_h_files())
if subcommand == 'dist_built_files':
  sys.exit(dist_built_files())
if subcommand == 'copy_built_files':
  sys.exit(copy_built_files())
if subcommand == 'dist_gen_msvc_files':
  sys.exit(dist_built_files(True))
print(sys.argv[0], ': illegal subcommand,', subcommand)
sys.exit(1)
