begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:rspec => :"test:prepare") do |t|
    t.verbose = false
  end
rescue LoadError
  $stderr.puts 'Warning: RSpec not available.'
end
