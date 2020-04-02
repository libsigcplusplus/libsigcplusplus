# MSVC_NMake

# Input: pkg_conf_data, sigcxxconfig_h, project_build_root, python3
# Output: sigc_rc

sigc_rc = configure_file(
  input: 'sigc.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Copy the generated configuration header into the MSVC project directory.
configure_file(
  input: sigcxxconfig_h,
  output: 'sigc++config.h',
  copy: true,
)

untracked_msvc_nmake = 'untracked' / 'MSVC_NMake'
handle_built_files = project_source_root / 'tools' / 'handle-built-files.py'

if not meson.is_subproject()
  # Distribute built files.
  # (add_dist_script() is not allowed in a subproject)

  meson.add_dist_script(
    python3.path(), handle_built_files, 'dist_gen_msvc_files',
    meson.current_build_dir(),
    untracked_msvc_nmake,
    project_build_root / 'sigc++config.h',
    meson.current_build_dir() / 'sigc.rc',
  )
endif
