# sigc++/adaptors

# Input: maintainer_mode, python3, handle_built_files, m4_template, m4_include_dir
# Input and output: built_h_files, built_h_file_targets

# .m4 files to build .h files from.
adaptors_h_m4_files = [
  'adaptor_trait.h',
  'bind.h',
  'bind_return.h',
  'compose.h',
  'deduce_result_type.h',
  'exception_catch.h',
  'hide.h',
  'retype.h',
  'retype_return.h',
  'track_obj.h',
]
foreach file : adaptors_h_m4_files
  built_h_files += 'adaptors' / file
endforeach

if maintainer_mode
  # Maintainer mode. Generate .h files from .m4 files in macros/ directory.
  foreach file : adaptors_h_m4_files
    built_h_file_targets += custom_target('adaptors_' + file,
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
