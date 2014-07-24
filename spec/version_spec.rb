require 'spec_helper'

describe RakeRack::Version do
  before do
    allow(described_class).to receive(:`)
    allow(described_class).to receive(:puts)
  end

  describe '.current_history' do
    let(:tmp_file) { Tempfile.new(['history','.rdoc']) }

    context 'when there is a history file' do
      before do
        allow(File).to receive(:read).and_return 'history'
        allow(File).to receive(:exists?).and_return true
      end

      it 'returns the current history file' do
        expect(described_class.current_history(tmp_file.path)).to eq 'history'
      end
    end

    context 'when there is no history file' do
      before do
        allow(File).to receive(:exists?).and_return false
      end

      it 'creates a history file at version 0.0.0' do
        expect(described_class.current_history(tmp_file.path)).to match(/\= 0.0.0 /)
      end
    end
  end

  describe '.latest_version' do
    before do
      allow(File).to receive(:read).and_return "== 1.2.3 (16 July 2014)\n * Change version tack so it can update gem version"
    end

    context 'there is no version'do
      it 'returns a version of [0,0,0]' do
        allow(File).to receive(:read).and_return ""
        expect(described_class.latest_version).to eq [1,2,3]
      end
    end

    context 'there is a version' do
      it 'returns the latest version' do
        expect(described_class.latest_version).to eq [1,2,3]
      end
    end

    it 'defines the .to_s of the latest version'do
      expect(described_class.latest_version.to_s).to eq "1.2.3"
    end
  end

  describe '.gem?' do
    context 'the project is a gem' do
      before do
        allow(Dir).to receive(:glob).and_return ['a gem spec']
      end

      it 'returns true' do
        expect(described_class.gem?).to eq true
      end
    end

    context 'the project is not a gem' do
      before do
        allow(Dir).to receive(:glob).and_return []
      end

      it 'returns false' do
        expect(described_class.gem?).to eq false
      end
    end
  end

  describe '.update_gem' do
    let(:tmp_file) { Tempfile.new(['rake_rack','.gemspec']) }

    before do
      gemspec = <<-GEM
        Gem::Specification.new do |spec|
          spec.name          = "rake_rack"
          spec.version       = '0.0.5'
          spec.authors       = ["Richard Vickerstaff"]
        end
      GEM
      tmp_file.write gemspec
      tmp_file.rewind
      allow(Dir).to receive(:glob).and_return [tmp_file.path]
    end

    it 'updates the gem version' do
      t = Time.local(2014, 7, 16)
      Timecop.travel(t) do
        described_class.update_gem 'foo'
        expect(File.read(tmp_file)).to match(/.*version\s*= 'foo'/)
      end
    end

    it 'outputs a message to the user' do
      expect(described_class).to receive(:puts).with 'Added version to .gemfile'
      described_class.update_gem 'foo'
    end
  end

  describe '.update_to' do
    before do
      allow(described_class).to receive(:`).and_return "refs/heads/master"
    end

    it 'updates the version' do
      expect(described_class).to receive(:add_history_header).with 'foo'
      expect(described_class).to receive(:update_gem).with 'foo'
      expect(described_class).to receive(:commit).with 'foo'
      expect(described_class).to receive(:tag).with 'foo'
      expect(described_class).to receive(:`).with 'git symbolic-ref HEAD'
      expect(described_class).to receive(:puts).with "To push the new tag, use 'git push origin master --tags'"
      described_class.update_to 'foo'
    end
  end

  describe '.add_history_header' do
    let(:tmp_file) { Tempfile.new('foo').path }

    it 'adds the new headre to the history.rdoc' do
      t = Time.local(2014, 7, 16)
      Timecop.travel(t) do
        described_class.add_history_header 'foo', tmp_file
        expect(File.read tmp_file).to eq "== foo (16 July 2014)\n\n"
      end
    end

    it 'outputs a message to the user' do
      expect(described_class).to receive(:puts).with 'Added version to history.rdoc'
      described_class.add_history_header 'foo', tmp_file
    end
  end

  describe '.commit' do
    it 'commits all changes' do
      expect(described_class).to receive(:`).with "git add . && git commit -m 'increment version to foo'"
      described_class.commit 'foo'
    end

    it 'outputs a message to the user' do
      expect(described_class).to receive(:puts).with 'Committed change'
      described_class.commit 'foo'
    end
  end

  describe '.tag' do
    it 'it tags the commit with the new version' do
      expect(described_class).to receive(:`).with 'git tag foo'
      described_class.tag 'foo'
    end

    it 'outputs a message to the user' do
      expect(described_class).to receive(:puts).with 'Tagged with foo'
      described_class.tag 'foo'
    end
  end
end
