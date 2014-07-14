begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:"rake_rack:rspec") do |t|
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(:"rake_rack:rspec_test_prepare" => :"test:prepare") do |t|
    t.verbose = false
  end
rescue LoadError
  $stderr.puts 'Warning: RSpec not available.'
end
