require_relative '../lib/dependency_checker'

namespace :bake do
  task :check_external_dependencies do
    next if @external_dependencies.nil? || @external_dependencies.size == 0

    checker = RakeNBake::DependencyChecker.new(@external_dependencies)

    RakeNBake::Baker.log_step 'Checking external dependencies'
    checker.check
    puts

    missing = checker.missing
    fail("The following dependencies are missing: \n#{missing.join(%Q[\n])}") unless missing.empty?
    puts
  end
end
