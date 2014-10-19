require 'rake/clean'
require './lib/rake_n_bake'

@external_dependencies = %w[ruby rake]

task :default => [
  :clean,
  :"bake:check_external_dependencies",
  :"bake:code_quality:all",
  :"bake:rspec",
  :"bake:coverage:check_specs",
  :"bake:bundler_audit",
  :"bake:ok",
]
