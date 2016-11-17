# encoding: utf-8
require 'spec_helper'
require production_code

describe RakeNBake::Baker do
  describe '#log_step' do
    it 'puts the given message' do
      expect { described_class.log_step 'Foo' }.to output(/Foo/).to_stdout
    end

    it 'prints an attractive dot before the message' do
      expect { described_class.log_step 'Foo' }.to output(/● Foo/).to_stdout
    end
  end

  describe '#log_warn' do
    it 'puts the given message' do
      expect { described_class.log_warn 'Foo' }.to output(/Foo/).to_stdout
    end

    it 'prints an attractive dot before the message' do
      expect { described_class.log_warn 'Foo' }.to output(/! Foo/).to_stdout
    end
  end

  describe '#log_passed' do
    it 'puts the given message' do
      expect { described_class.log_passed 'Foo' }.to output(/Foo/).to_stdout
    end

    it 'prints the message in green' do
      expect { described_class.log_passed 'Foo' }.to output("#{Term::ANSIColor.green}Foo#{Term::ANSIColor.reset}\n").to_stdout
    end
  end

  describe '#log_missing_gem' do
    it 'puts a message asking for the gem to be installed' do
      expect { described_class.log_missing_gem 'foo' }.to output(/Try adding "gem 'foo'"/).to_stderr
    end

    it 'can optionally take a different name for the tool' do
      expect { described_class.log_missing_gem 'foo', 'Bar' }.to output(/'Bar' is not available/).to_stderr
      expect { described_class.log_missing_gem 'foo', 'Bar' }.to output(/Try adding "gem 'foo'"/).to_stderr
    end
  end
end
