require 'rake/clean'
require './lib/rake_rack'

task :default => [
  :clean,
  :"rake_rack:code_quality:all",
  :"rake_rack:rspec",
  :"rake_rack:coverage:check_specs",
  :"rake_rack:ok",
]

