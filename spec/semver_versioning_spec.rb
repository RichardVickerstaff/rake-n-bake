require 'spec_helper'
require production_code
require 'yaml'

describe RakeNBake::SemverVersioning do
  def project_root_file name
    File.join(File.dirname(__FILE__), '..', name)
  end

  def backup_file name
    file = project_root_file(name)
    @backups ||= {}
    @backups[name] = File.read(file) if File.exist?(file)
  end

  def restore_file name
    file = project_root_file(name)
    File.write(file, @backups[name]) unless @backups[name].nil?
  end

  def remove_file name
    file = project_root_file name
    FileUtils.rm file, force: true
  end

  before(:all) do
    backup_file '.semver'
    backup_file 'history.rdoc'
  end

  after(:all) do
    restore_file '.semver'
    restore_file 'history.rdoc'
  end

  before(:each) do
    remove_file '.semver'
    remove_file 'history.rdoc'
  end

  after(:each) do
    remove_file '.semver'
    remove_file 'history.rdoc'
  end

  let(:version) do
    {
      major: '1',
      minor: '2',
      patch: '3',
      special: '',
      metadata: ''
    }
  end

  describe '#current_version' do
    context 'when there is no .semver file' do
      it 'returns the current version' do
        expect(described_class.current_version.to_s).to eq 'v0.0.0'
      end
    end

    context 'when there is a .semver file' do
      before do
        File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
      end

      it 'returns the current version' do
        expect(described_class.current_version.to_s).to eq 'v1.2.3'
      end
    end
  end

  describe 'inc_major' do
    before do
      File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
    end
    it 'increases major and resets minor and patch' do
      described_class.inc_major
      expect(described_class.current_version.to_s).to eq 'v2.0.0'
    end
  end

  describe 'inc_minor' do
    before do
      File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
    end
    it 'increases minor and resets patch' do
      described_class.inc_minor
      expect(described_class.current_version.to_s).to eq 'v1.3.0'
    end
  end

  describe 'inc_patch' do
    before do
      File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
    end
    it 'increases minor and resets patch' do
      described_class.inc_patch
      expect(described_class.current_version.to_s).to eq 'v1.2.4'
    end
  end

  describe 'prerelease' do
    before do
      File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
    end
    it 'sets the prerelease to the supplied string' do
      described_class.prerelease 'something'
      expect(described_class.current_version.to_s).to eq 'v1.2.3-something'
    end
  end

  describe 'inc_prerelease' do
    before do
      File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
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
      File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(v))
    end
    it 'removes the prerelease' do
      described_class.release
      expect(described_class.current_version.to_s).to eq 'v1.2.3'
    end
  end

  describe '#update_history_file' do
    context 'when there is no history file' do
      it 'does nothing' do
        described_class.update_history_file
        expect(File.exist? '../history.rdoc').to eq false
        expect(File.exist? '../CHANGELOG.md').to eq false
      end
    end

    context 'when there is a history.rdoc file' do
      before do
        File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
        File.write(File.join(File.dirname(__FILE__), '../history.rdoc'), '* Some changes')
      end

      after { File.unlink(File.join(File.dirname(__FILE__), '../history.rdoc')) }

      it 'Adds the version number and date to the top of the file and adds it to git' do
        expect(Object).to receive(:`).with('git add history.rdoc')
        described_class.update_history_file
        expect(File.read(File.join(File.dirname(__FILE__), '../history.rdoc')).lines.first).to eq "== v1.2.3 (#{Time.now.strftime "%d %B %Y"})\n"
      end
    end

    context 'when there is a CHANGELOG.md file' do
      before do
        File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
        File.write(File.join(File.dirname(__FILE__), '../CHANGELOG.md'), '* Some changes')
      end

      after { File.unlink(File.join(File.dirname(__FILE__), '../CHANGELOG.md')) }

      it 'Adds the version number and date to the top of the file and adds it to git' do
        expect(Object).to receive(:`).with('git add CHANGELOG.md')
        described_class.update_history_file
        expect(File.read(File.join(File.dirname(__FILE__), '../CHANGELOG.md')).lines.first).to eq "== v1.2.3 (#{Time.now.strftime "%d %B %Y"})\n"
      end
    end
  end

  describe 'tag' do
    before do
      File.write(File.join(File.dirname(__FILE__), '../.semver'), YAML.dump(version))
    end
    it 'tags with the curren semver release and outputs push instructions' do
      expect(Object).to receive(:`).with("git add .semver && git commit -m 'Increment version to v1.2.3' && git tag v1.2.3 -a -m '#{Time.now}'")
      expect(Object).to receive(:`).with('git symbolic-ref HEAD').and_return 'refs/heads/master'
      expect(Object).to receive(:puts).with("To push the new tag, use 'git push origin master --tags'")
      described_class.tag
    end
  end
end

