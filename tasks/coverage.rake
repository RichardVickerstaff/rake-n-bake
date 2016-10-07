begin
  require "simplecov"

  def set_coverage_dir coverage_dir
    report = File.join(coverage_dir, 'index.html')
    if File.exists?(report)
      SimpleCov.coverage_dir coverage_dir
    else
      RakeNBake::Baker.log_warn "SimpleCov report could not be found at #{report}"
      fail
    end
  end

  def check_coverage_level_above level
    coverage = SimpleCov.result.covered_percent
    if coverage >= level
      RakeNBake::Baker.log_passed "Feature coverage is at #{coverage}%"
    else
      RakeNBake::Baker.log_warn "Spec coverage was only #{coverage}%"
      fail
    end
  end

  namespace :bake do
    namespace :coverage do
      COVERAGE_PERCENT = ENV['COVERAGE_PERCENT'] || 100.0

      desc 'Check coverage from RSpec'
      task :check_specs do
        RakeNBake::Baker.log_step 'Checking spec coverage'
        coverage_dir = 'log/coverage/spec'
        set_coverage_dir(coverage_dir)
        check_coverage_level_above COVERAGE_PERCENT
      end

      desc 'Check coverage from Cucumber'
      task :check_cucumber do
        RakeNBake::Baker.log_step 'Checking feature coverage'
        coverage_dir = 'log/coverage/features'
        set_coverage_dir(coverage_dir)
        check_coverage_level_above COVERAGE_PERCENT
      end
    end
  end

rescue LoadError

  namespace :bake do
    namespace :coverage do
      %w[check_specs check_cucumber].map(&:to_sym).each do |t|
        desc 'SimpleCov rake tasks are not available (gem not installed)'
        task t do
          RakeNBake::Baker.log_missing_gem 'simplecov', 'SimpleCov'
          abort
        end
      end
    end
  end

end
