begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:"bake:rspec") do |t|
    t.verbose = false
  end

  RSpec::Core::RakeTask.new(:"bake:rspec_test_prepare" => :"test:prepare") do |t|
    t.verbose = false
  end

rescue LoadError

  namespace :bake do
    %i[rspec rspec_test_prepare].each do |t|
      desc 'RSpec rake tasks are not available (gem not installed)'
      task t do
        $stdout.puts "This task is not available because the RSpec gem is not installed."
        $stderr.puts "Try adding \"gem 'rspec'\" to your Gemfile or run `gem install rspec` and try again."
        abort
      end
    end
  end

end
