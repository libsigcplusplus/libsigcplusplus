# sigc++/adaptors/lambda

# Input: maintainer_mode, python3, handle_built_files, m4_template, m4_include_dir
# Input and output: built_h_files, built_cc_files, built_h_file_targets,
#                   built_cc_file_targets

# .m4 files to build .h and .cc files from.
adaptors_lambda_cc_m4_files = [
  'lambda.cc',
]
adaptors_lambda_h_m4_files = [
  'base.h',
  'select.h',
]
foreach file : adaptors_lambda_h_m4_files
  built_h_files += 'adaptors' / 'lambda' / file
endforeach
foreach file : adaptors_lambda_cc_m4_files
  built_cc_files += 'adaptors' / 'lambda' / file
endforeach

if maintainer_mode
  # Maintainer mode. Generate .h and .cc files from .m4 files in macros/ directory.
  foreach file : adaptors_lambda_cc_m4_files + adaptors_lambda_h_m4_files
    built_file_target = custom_target('adaptors_lambda_' + file,
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
    if file.endswith('.cc')
      built_cc_file_targets += built_file_target
    else
      built_h_file_targets += built_file_target
    endif
  endforeach
endif
