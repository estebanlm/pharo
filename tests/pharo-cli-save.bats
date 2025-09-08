#!/usr/bin/env bats

load test_helper.bash

setup() {
  setup-workdir
}

teardown() {
  teardown-workdir
}

@test "save --help prints help" {
  run_pharo save --help
  assert_output --partial "Usage: save [--help] [--production] [--release]"
  assert_success
}

@test "test can save to a new image name" {
  local changes_file="${IMAGE%.image}.changes"

  run_pharo save newname

  assert_success
  assert_file_exists newname.image
  assert_file_exists newname.changes
  assert_file_exists "$IMAGE"
  assert_file_exists "$changes_file"
}

@test "test can save to a new image name and delete old image" {
  local changes_file="${IMAGE%.image}.changes"

  run_pharo save newname

  assert_success
  assert_file_exists newname.image
  assert_file_exists newname.changes
  refute_file_exists "$IMAGE"
  refute_file_exists "$changes_file"
}