# encoding: utf-8
require 'term/ansicolor'

module RakeNBake
  class Baker
    def self.log_step message
      puts "\n" +
        Term::ANSIColor.blue +
        Term::ANSIColor.underline +
        '● ' +
        message +
        Term::ANSIColor.reset
    end

    def self.log_warn message
      puts Term::ANSIColor.red +
        Term::ANSIColor.bold +
        '! ' +
        message +
        Term::ANSIColor.reset
    end

    def self.log_passed message
      puts Term::ANSIColor.green +
        message +
        Term::ANSIColor.reset
    end

    def self.log_missing_gem gem_name, tool_name = gem_name
      $stderr.puts \
        Term::ANSIColor.yellow +
        Term::ANSIColor.underline +
        "! This task is not available because '#{tool_name}' is not available." +
        Term::ANSIColor.reset

      $stderr.puts \
        "Try adding \"gem '#{gem_name}'\" to your Gemfile or run `gem install #{gem_name}` and try again." +
        Term::ANSIColor.reset
    end
  end
end
