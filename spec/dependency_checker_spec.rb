require 'spec_helper'
require production_code

describe RakeNBake::DependencyChecker do
  let(:silent) { true }
  let(:list) { %w[present missing] }

  subject { RakeNBake::DependencyChecker.new list }

  before do
    double_cmd('which present', exit: 0)
    double_cmd('which missing', exit: 1)
  end

  describe '#check' do
    it 'returns a hash of dependencies => presence' do
      result = subject.check(silent)
      expect(result).to eq('present' => true, 'missing' => false)
    end

    it 'prints a dot for dependencies which are present' do
      expect { subject.check }.to output(/\./).to_stdout
    end

    it 'prints a F for missing dependencies' do
      expect { subject.check }.to output(/F/).to_stdout
    end

    it 'can be run without printing anything out' do
      expect { subject.check(silent) }.to_not output.to_stdout
    end
  end

  describe '#missing' do
    it 'returns only missing dependencies' do
      expect(subject.missing).to eq ['missing']
    end
  end
end
