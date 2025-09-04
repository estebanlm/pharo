#!/usr/bin/env bats

load test_helper.bash

setup() {
  setup-workdir
}

teardown() {
  teardown-workdir
}

@test "metacello install --help prints help" {
  run_pharo metacello install --help
  assert_output --partial "metacello install <repository url> (<baseline>|<configuration>) [--version=<version>] [--groups=<group name>,...] [--no-quit] [--no-save]"
  assert_success
}

@test "metacello can install a baseline project" {
  copy_image "test-metacello-load.image"
  run_pharo_with_timeout 200 metacello install github://DuneSt/MaterialColors:master/src BaselineOfMaterialColors
  assert_success

  # Check that the loading is ok
  run_pharo eval "Smalltalk at: #MDLColor"
  assert_success
  assert_line "MDLColor"
}