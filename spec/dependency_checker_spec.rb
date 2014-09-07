require 'spec_helper'
require 'term/ansicolor'
include Term::ANSIColor

describe RakeRack::DependencyChecker do

  # Note that this test will fail if you, somehow, have this insane string define on your path
  let(:missing) {'jajfjfjosojfnbje3nknq'}
  let(:present) {'rspec'}
  let(:list){ [present, missing] }

  subject{RakeRack::DependencyChecker.new list}

  describe '#check' do
    before { $stdout = StringIO.new }

    it 'returns a hash of dependencies => presence' do
      result = subject.check
      expect(result).to eq({present => true, missing => false})
    end

    it 'prints a dot for dependencies which are present' do
      expect{subject.check}.to output(/\./).to_stdout
    end

    it 'prints a F for missing dependencies' do
      expect{subject.check}.to output(/F/).to_stdout
    end

    it 'can be run without printing anything out' do
      expect{subject.check silent: true}.to_not output.to_stdout
    end
  end

  describe '#missing_from' do
    it 'returns only missing dependencies' do
      expect(subject.missing).to eq [missing]
    end
  end

end
