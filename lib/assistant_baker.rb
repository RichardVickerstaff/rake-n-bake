require 'term/ansicolor'

module RakeNBake
  class AssistantBaker
    def self.log_step message
      puts Term::ANSIColor.blue +
        Term::ANSIColor.underline +
        '● ' +
        message +
        Term::ANSIColor.reset
    end
  end
end
