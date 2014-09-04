namespace :rake_rack do
  task :check_external_deps, [:exes] do |task, args|
    puts 'Checking external dependencies...'
    green = `tput setaf 2`
    red = `tput setaf 1`
    reset = `tput sgr0`

    external_commands = args[:exes]
    results = external_commands.each_with_object({}) do |exe, status|
        system "which #{exe} > /dev/null"
        status[exe] = if($? == 0)
          print "#{green}.#{reset}"
          true
        else
          print "#{red}F#{reset}"
          false
        end
      end
    puts
    missing = results.select{|k,v| v == false}
    fail "The following dependencies are missing: \n#{missing.keys.join(%Q[\n])}" unless missing.empty?
    2.times{puts}
  end
end
