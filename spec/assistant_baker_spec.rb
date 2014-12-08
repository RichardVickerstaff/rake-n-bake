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
end
