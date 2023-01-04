# MSVC_NMake

# Input: pkg_conf_data, sigcxxconfig_h_meson, project_build_root, python3,
#        can_add_dist_script
# Output: sigc_rc

sigc_rc = configure_file(
  input: 'sigc.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Make a copy of the generated configuration header in the MSVC project directory.
configure_file(
  input: sigcxxconfig_h_meson,
  output: 'sigc++config.h',
  configuration: pkg_conf_data,
)

untracked_msvc_nmake = 'untracked' / 'MSVC_NMake'
handle_built_files = project_source_root / 'tools' / 'handle-built-files.py'

if can_add_dist_script
  # Distribute built files.
  meson.add_dist_script(
    python3, handle_built_files, 'dist_gen_msvc_files',
    meson.current_build_dir(),
    untracked_msvc_nmake,
    project_build_root / 'sigc++config.h',
    meson.current_build_dir() / 'sigc.rc',
  )
endif
