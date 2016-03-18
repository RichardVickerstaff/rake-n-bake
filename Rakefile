require 'rake/clean'
require './lib/rake-n-bake'

@external_dependencies = %w[ruby rake]

task :default => [
  :clean,
  :"bake:check_external_dependencies",
  :"bake:code_quality:all",
  :"bake:rspec",
  :"bake:ok_rainbow",
]
