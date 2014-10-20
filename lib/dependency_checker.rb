require 'term/ansicolor'

module RakeNBake
  class DependencyChecker

    C = Term::ANSIColor

    def initialize dependencies
      @dependencies = Array(dependencies)
    end

    def check silent = false
      @results = @dependencies.each_with_object({}) do |dep, results|
        results[dep] = system "which #{dep} >/dev/null"
        unless silent
          results[dep] ? print(C.green, ".", C.clear) : print(C.red, "F", C.clear)
        end
      end
    end

    def missing
      @results ||= check(true)
      @results.select{|_, present| present == false}.keys
    end

  end
end
