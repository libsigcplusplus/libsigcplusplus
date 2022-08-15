# examples

# input: sigcxx_own_dep, build_examples

examples = [
# [[dir-name], exe-name, [sources]]
  [[], 'hello_world', ['hello_world.cc']],
  [[], 'member_method', ['member_method.cc']],
]

foreach ex : examples
  dir = ''
  foreach dir_part : ex[0]
    dir = dir / dir_part
  endforeach
  ex_name = (dir / ex[1]).underscorify()
  ex_sources = []
  foreach src : ex[2]
    ex_sources += dir / src
  endforeach

  exe_file = executable(ex_name, ex_sources,
    cpp_args: '-DSIGCXX_DISABLE_DEPRECATED=1',
    dependencies: sigcxx_own_dep,
    implicit_include_directories: false,
    build_by_default: build_examples
  )
endforeach
