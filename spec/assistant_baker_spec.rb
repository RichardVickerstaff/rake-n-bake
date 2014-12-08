require 'spec_helper'
require production_code

describe RakeNBake::AssistantBaker do
  describe '#log_step' do
    it 'puts the given message' do
      expect{described_class.log_step 'Foo'}.to output(/Foo/).to_stdout
    end

    it 'prints an attractive dot before the message' do
      expect{described_class.log_step 'Foo'}.to output(/● Foo/).to_stdout
    end
  end

  describe '#log_passed' do
    it 'puts the given message' do
      expect{described_class.log_passed 'Foo'}.to output(/Foo/).to_stdout
    end

    it 'prints the message in green' do
      expect{described_class.log_passed 'Foo'}.to output("#{Term::ANSIColor.green}Foo#{Term::ANSIColor.reset}\n").to_stdout
    end
  end
end
