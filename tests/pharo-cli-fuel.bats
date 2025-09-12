#!/usr/bin/env bats

load test_helper.bash

setup() {
  setup-workdir
}

teardown() {
  teardown-workdir
}

@test "fuel --help prints help" {
  run_pharo fuel --help
  assert_success
  assert_output --partial "Usage: fuel [--help] [--save] [--keepAlive] [<FILE>]"
}

@test "fuel can load a fuel file and quit" {
  copy_image "test-fuel.image"
  run_pharo fuel $ROOT_DIR/exported-empty-package.fuel --save
  assert_success

  run_pharo eval Package named: "#empty"
  assert_success
  refute_output --partial "Wednesday"
}

@test "fuel outputs error if no fuel file provided" {
  run_pharo fuel foo.bar
  assert_failure
  assert_line --index 0 --regexp "[[:blank:]]*Missing Hermes file as argument[[:blank:]]*"
}