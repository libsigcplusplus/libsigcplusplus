# tests

# input: sigcxx_own_dep, do_benchmark, can_benchmark, benchmark_dep

benchmark_timeout = 100

test_programs = [
# [[dir-name], exe-name, [sources]]
  [[], 'test_accum_iter', ['test_accum_iter.cc', 'testutilities.cc']],
  [[], 'test_accumulated', ['test_accumulated.cc', 'testutilities.cc']],
  [[], 'test_bind', ['test_bind.cc', 'testutilities.cc']],
  [[], 'test_bind_as_slot', ['test_bind_as_slot.cc', 'testutilities.cc']],
  [[], 'test_bind_ref', ['test_bind_ref.cc', 'testutilities.cc']],
  [[], 'test_bind_refptr', ['test_bind_refptr.cc', 'testutilities.cc']],
  [[], 'test_bind_return', ['test_bind_return.cc', 'testutilities.cc']],
  [[], 'test_compose', ['test_compose.cc', 'testutilities.cc']],
  [[], 'test_copy_invalid_slot', ['test_copy_invalid_slot.cc', 'testutilities.cc']],
  [[], 'test_cpp11_lambda', ['test_cpp11_lambda.cc', 'testutilities.cc']],
  [[], 'test_custom', ['test_custom.cc', 'testutilities.cc']],
  [[], 'test_deduce_result_type', ['test_deduce_result_type.cc', 'testutilities.cc']],
  [[], 'test_disconnect', ['test_disconnect.cc', 'testutilities.cc']],
  [[], 'test_disconnect_during_emit', ['test_disconnect_during_emit.cc', 'testutilities.cc']],
  [[], 'test_exception_catch', ['test_exception_catch.cc', 'testutilities.cc']],
  [[], 'test_functor_trait', ['test_functor_trait.cc', 'testutilities.cc']],
  [[], 'test_hide', ['test_hide.cc', 'testutilities.cc']],
  [[], 'test_limit_reference', ['test_limit_reference.cc', 'testutilities.cc']],
  [[], 'test_mem_fun', ['test_mem_fun.cc', 'testutilities.cc']],
  [[], 'test_ptr_fun', ['test_ptr_fun.cc', 'testutilities.cc']],
  [[], 'test_retype', ['test_retype.cc', 'testutilities.cc']],
  [[], 'test_retype_return', ['test_retype_return.cc', 'testutilities.cc']],
  [[], 'test_signal', ['test_signal.cc', 'testutilities.cc']],
  [[], 'test_signal_move', ['test_signal_move.cc', 'testutilities.cc']],
  [[], 'test_size', ['test_size.cc', 'testutilities.cc']],
  [[], 'test_slot', ['test_slot.cc', 'testutilities.cc']],
  [[], 'test_slot_disconnect', ['test_slot_disconnect.cc', 'testutilities.cc']],
  [[], 'test_slot_move', ['test_slot_move.cc', 'testutilities.cc']],
  [[], 'test_trackable', ['test_trackable.cc', 'testutilities.cc']],
  [[], 'test_trackable_move', ['test_trackable_move.cc', 'testutilities.cc']],
  [[], 'test_track_obj', ['test_track_obj.cc', 'testutilities.cc']],
  [[], 'test_visit_each', ['test_visit_each.cc', 'testutilities.cc']],
]

benchmark_programs = [
# [[dir-name], exe-name, [sources]]
  [[], 'benchmark1', ['benchmark.cc']],
]

foreach ex : test_programs
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
    dependencies: sigcxx_own_dep,
    implicit_include_directories: false,
    build_by_default: true
  )

  test(ex_name, exe_file)
endforeach

if can_benchmark
  foreach ex : benchmark_programs
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
      dependencies: [sigcxx_own_dep, benchmark_dep],
      implicit_include_directories: false,
      build_by_default: do_benchmark
    )

    if do_benchmark
      test(ex_name, exe_file,
        timeout: benchmark_timeout,
      )
    endif
  endforeach
endif
