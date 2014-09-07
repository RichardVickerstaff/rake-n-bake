require 'term/ansicolor'

class RakeRack
  class DependencyChecker
    include Term::ANSIColor

    def check_for dependency
      system "which #{dependency} >/dev/null"
    end

    def check_list dependencies, silent: false
      Array(dependencies).each_with_object({}) do |dep, result|
        result[dep] = check_for dep
        unless silent
          result[dep] ? print(".".green) : print("F".red)
        end
      end
    end

  end
end
