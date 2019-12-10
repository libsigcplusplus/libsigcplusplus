#!/usr/bin/env python3

# External command, intended to be called with meson.add_dist_script() in meson.build.
# meson.add_dist_script() can't call a script that's not committed to git.
# This script shall be committed. It can be used for calling other non-committed scripts.

# dist-cmd.py <cmd> <args>...

import sys
import subprocess

sys.exit(subprocess.run(sys.argv[1:]).returncode)
