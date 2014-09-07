require 'term/ansicolor'

namespace :rake_rack do
  task :check_external_dependencies do
    include Term::ANSIColor

    puts 'Checking external dependencies...'
    results = Array(@external_dependencies).each_with_object({}) do |exe, status|
      status[exe] = system "which #{exe} > /dev/null"
      status[exe] ? print('.'.green) : print('F'.red)
    end
    puts

    missing = results.select{|_exe, present| present == false}
    fail("The following dependencies are missing: \n#{missing.keys.join(%Q[\n])}") unless missing.empty?
    puts
  end
end
