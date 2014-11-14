begin
  require "simplecov"

  namespace :bake do
    namespace :coverage do
      desc 'Check coverage from RSpec'
      task :check_specs do
        SimpleCov.coverage_dir 'log/coverage/spec'
        coverage = SimpleCov.result.covered_percent
        fail "Spec coverage was only #{coverage}%" if coverage < 100.0
      end

      desc 'Check coverage from Cucumber'
      task :check_cucumber do
        SimpleCov.coverage_dir 'log/coverage/features'
        coverage = SimpleCov.result.covered_percent
        fail "Feature coverage was only #{coverage}%" if coverage < 100.0
      end
    end
  end
rescue LoadError

  namespace :bake do
    namespace :coverage do
      %w[check_specs check_cucumber].map(&:to_sym).each do |t|
        desc 'SimpleCov rake tasks are not available (gem not installed)'
        task t do
          $stdout.puts "This task is not available because the SimpleCov gem is not installed."
          $stderr.puts "Try adding \"gem 'simplecov'\" to your Gemfile or run `gem install simplecov` and try again."
          abort
        end
      end
    end
  end

end
