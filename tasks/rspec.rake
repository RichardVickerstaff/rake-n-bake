begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(:rspec_test_prepare => :"test:prepare") do |t|
    t.verbose = false
  end
rescue LoadError
  $stderr.puts 'Warning: RSpec not available.'
end
