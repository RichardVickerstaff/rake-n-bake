require 'spec_helper'
require 'yaml'

describe RakeRack::SemverVersioning do
  let(:version) {
    {
      major: '1',
      minor: '2',
      patch: '3',
      special: '',
      metadata: ''
    }
  }
  before(:all) do
    if File.exist? File.join(__dir__, '../.semver')
      @current_semver_file = File.read(File.join(__dir__, '../.semver'), force: true)
    end
  end

  after(:all) do
    if @current_semver_file
      File.write(File.join(__dir__, '../.semver'), @current_semver_file, force: true)
    end
  end
  before do
    FileUtils.rm(File.join(__dir__, '../.semver'), force: true)
  end
  after do
    FileUtils.rm(File.join(__dir__, '../.semver'), force: true)
  end
  describe '#current_version' do
    context 'when there is no .semver file' do
      it 'returns the current version' do
        expect(described_class.current_version.to_s).to eq 'v0.0.0'
      end
    end

    context 'when there is a .semver file' do
      before do
        File.write(File.join(__dir__, '../.semver'), YAML.dump(version))
      end

      it 'returns the current version' do
        expect(described_class.current_version.to_s).to eq 'v1.2.3'
      end
    end
  end

  describe 'inc_major' do
    before do
      File.write(File.join(__dir__, '../.semver'), YAML.dump(version))
    end
    it 'increases major and resets minor and patch' do
      described_class.inc_major
      expect(described_class.current_version.to_s).to eq 'v2.0.0'
    end
  end

  describe 'inc_minor' do
    before do
      File.write(File.join(__dir__, '../.semver'), YAML.dump(version))
    end
    it 'increases minor and resets patch' do
      described_class.inc_minor
      expect(described_class.current_version.to_s).to eq 'v1.3.0'
    end
  end

  describe 'inc_patch' do
    before do
      File.write(File.join(__dir__, '../.semver'), YAML.dump(version))
    end
    it 'increases minor and resets patch' do
      described_class.inc_patch
      expect(described_class.current_version.to_s).to eq 'v1.2.4'
    end
  end

  describe 'prerelease' do
    before do
      File.write(File.join(__dir__, '../.semver'), YAML.dump(version))
    end
    it 'sets the prerelease to the supplied string' do
      described_class.prerelease 'something'
      expect(described_class.current_version.to_s).to eq 'v1.2.3-something'
    end
  end

  describe 'inc_prerelease' do
    before do
      File.write(File.join(__dir__, '../.semver'), YAML.dump(version))
    end
    it 'increments major version and sets the prerelease to the supplied string' do
      described_class.inc_prerelease 'something'
      expect(described_class.current_version.to_s).to eq 'v2.0.0-something'
    end
  end

  describe 'release' do
    before do
      v = version
      v[:special] = "a string"
      File.write(File.join(__dir__, '../.semver'), YAML.dump(v))
    end
    it 'removes the prerelease' do
      described_class.release
      expect(described_class.current_version.to_s).to eq 'v1.2.3'
    end
  end

  describe 'tag' do
    before do
      File.write(File.join(__dir__, '../.semver'), YAML.dump(version))
    end
    it 'tags with the curren semver release' do
      expect(Object).to receive(:`).with("git add .semver && git commit -m 'Increment version to v1.2.3' && git tag v1.2.3")
      described_class.tag
    end
  end
end

