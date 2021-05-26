#!/bin/bash

# Run all libsigc++ tests with valgrind, searching for memory leaks.
# Execute this script in the tests directory.
#  valgrind --leak-check=full .libs/lt-test_*

for testprog in  test_accum_iter test_accumulated test_bind test_bind_as_slot \
  test_bind_ref test_bind_refptr test_bind_return test_compose test_connection \
  test_copy_invalid_slot test_cpp11_lambda test_custom test_disconnect \
  test_disconnect_during_emit test_exception_catch test_hide \
  test_limit_reference test_member_method_trait test_mem_fun test_ptr_fun \
  test_retype test_retype_return test_rvalue_ref test_signal test_signal_move \
  test_size test_slot test_slot_disconnect test_slot_move test_trackable \
  test_trackable_move test_track_obj test_tuple_cdr test_tuple_end \
  test_tuple_for_each test_tuple_start test_tuple_transform_each \
  test_visit_each test_visit_each_trackable test_weak_raw_ptr
do
  echo ================
  echo === $testprog
  echo ================
  valgrind --leak-check=full .libs/lt-$testprog
done

