# sigc++/functors

# Input: maintainer_mode, python3, handle_built_files, m4_template, m4_include_dir
# Input and output: built_h_files, built_h_file_targets

# .m4 files to build .h files from.
functors_h_m4_files = [
  'functor_trait.h',
  'mem_fun.h',
  'ptr_fun.h',
  'slot.h',
]
foreach file : functors_h_m4_files
  built_h_files += 'functors' / file
endforeach

if maintainer_mode
  # Maintainer mode. Generate .h files from .m4 files in macros/ directory.
  foreach file : functors_h_m4_files
    built_h_file_targets += custom_target('functors_' + file,
      input: 'macros' / file + '.m4',
      output: file,
      command: [
        python3, handle_built_files, 'build_from_m4',
        m4_include_dir,
        '@INPUT@',
        '@OUTPUT@',
      ],
      depend_files: m4_template,
      build_by_default: maintainer_mode,
      install: false,
    )
  endforeach
endif
