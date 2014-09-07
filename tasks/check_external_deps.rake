require 'term/ansicolor'

namespace :rake_rack do
  task :check_external_dependencies do
    include Term::ANSIColor
    checker = RakeRack::DependencyChecker.new

    puts 'Checking external dependencies...'
    results = checker.check_list @external_dependencies
    puts

    missing = results.select{|_exe, present| present == false}
    fail("The following dependencies are missing: \n#{missing.keys.join(%Q[\n])}") unless missing.empty?
    puts
  end
end
