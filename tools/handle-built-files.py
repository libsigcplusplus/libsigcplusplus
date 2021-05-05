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

# ----- Main -----
if subcommand == 'dist_gen_msvc_files':
  sys.exit(dist_built_files(True))
print(sys.argv[0], ': illegal subcommand,', subcommand)
sys.exit(1)
