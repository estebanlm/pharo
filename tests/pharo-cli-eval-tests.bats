#!/usr/bin/env bats

load test_helper.bash

@test "eval --help prints help" {
  run_pharo eval --help
  assert_success
  assert_line --index 0 "Usage: eval [--help] [--save] [ --no-quit ] <smalltalk expression>"
  assert_line --index 1 --regexp "--help[[:blank:]]+list this help message"
}