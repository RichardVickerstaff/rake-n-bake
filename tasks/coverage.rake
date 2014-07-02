begin
  require "simplecov"

  namespace :rake_rack do
    namespace :coverage do
      task :check_specs do
        SimpleCov.coverage_dir 'log/coverage/spec'
        coverage = SimpleCov.result.covered_percent
        fail "Spec coverage was only #{coverage}%" if coverage < 100.0
      end

      task :check_cucumber do
        SimpleCov.coverage_dir 'log/coverage/features'
        coverage = SimpleCov.result.covered_percent
        fail "Feature coverage was only #{coverage}%" if coverage < 100.0
      end
    end
  end
rescue LoadError
  $stderr.puts 'Warning: SimpleCov not available.'
end
