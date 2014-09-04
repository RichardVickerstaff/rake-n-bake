require 'rake/clean'
require './lib/rake_rack'

task :default => [
  :clean,
  :check_external_dependencies,
  :"rake_rack:code_quality:all",
  :"rake_rack:rspec",
  :"rake_rack:coverage:check_specs",
  :"rake_rack:ok",
]

task :check_external_dependencies do
  dependencies = %w[ruby rake tput]
  Rake::Task["rake_rack:check_external_deps"].invoke dependencies
end
