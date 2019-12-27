# MSVC_NMake

# Input: pkg_conf_data, project_build_root, python3
# Output: -

sigc_rc = configure_file(
  input: 'sigc.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Copy the generated configuration header into the MSVC project directory.
cmd_py = '''
import shutil
shutil.copy2("@0@", "@1@")
'''.format(project_build_root / 'sigc++config.h', project_build_root / 'MSVC_NMake')
meson.add_postconf_script(python3.path(), '-c', cmd_py)
