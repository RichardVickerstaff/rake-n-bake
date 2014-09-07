require 'spec_helper'
require 'term/ansicolor'
include Term::ANSIColor

describe RakeRack::DependencyChecker do

  # Note that this test will fail if you, somehow, have this insane string define on your path
  let(:missing) {'jajfjfjosojfnbje3nknq'}
  let(:present) {'rspec'}
  let(:list){ [present, missing] }

  describe '#check_for' do
    it 'returns true if a program is available' do
      expect(subject.check_for present).to eq true
    end

    it 'returns false if a program is unavailable' do
      expect(subject.check_for missing).to eq false
    end
  end

  describe '#check_list' do
    before { $stdout = StringIO.new }

    it 'returns a hash of dependencies => presence' do
      result = subject.check_list [present, missing]
      expect(result).to eq({present => true, missing => false})
    end

    it 'prints a green dot for dependencies which are present' do
      expect{subject.check_list present}.to output(".".green).to_stdout
    end

    it 'prints a red F for missing dependencies' do
      expect{subject.check_list missing}.to output("F".red).to_stdout
    end

    it 'can be run without printing anything out' do
      expect{subject.check_list present, silent: true}.to_not output.to_stdout
    end
  end

end
