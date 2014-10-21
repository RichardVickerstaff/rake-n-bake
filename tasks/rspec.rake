begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:"bake:rspec") do |t|
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(:"bake:rspec_test_prepare" => :"test:prepare") do |t|
    t.verbose = false
  end
rescue LoadError
  $stderr.puts 'Warning: RSpec not available.'
end
