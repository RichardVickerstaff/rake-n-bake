require 'spec_helper'
require production_code
require 'yaml'

describe RakeNBake::SemverVersioning do
  before(:example) { SEMVER_FILES.map{|f| remove_file f} }

  let(:changelog)    { project_root_file 'CHANGELOG.md' }
  let(:history_rdoc) { project_root_file 'history.rdoc' }
  let(:semver)       { project_root_file '.semver' }

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
      before { File.write(semver, YAML.dump(version)) }

      it 'returns the current version' do
        expect(described_class.current_version.to_s).to eq 'v1.2.3'
      end
    end
  end

  describe 'inc_major' do
    before { File.write(semver, YAML.dump(version)) }

    it 'increases major and resets minor and patch' do
      described_class.inc_major
      expect(described_class.current_version.to_s).to eq 'v2.0.0'
    end
  end

  describe 'inc_minor' do
    before { File.write(semver, YAML.dump(version)) }

    it 'increases minor and resets patch' do
      described_class.inc_minor
      expect(described_class.current_version.to_s).to eq 'v1.3.0'
    end
  end

  describe 'inc_patch' do
    before { File.write(semver, YAML.dump(version)) }

    it 'increases minor and resets patch' do
      described_class.inc_patch
      expect(described_class.current_version.to_s).to eq 'v1.2.4'
    end
  end

  describe 'prerelease' do
    before { File.write(semver, YAML.dump(version)) }

    it 'sets the prerelease to the supplied string' do
      described_class.prerelease 'something'
      expect(described_class.current_version.to_s).to eq 'v1.2.3-something'
    end
  end

  describe 'inc_prerelease' do
    before { File.write(semver, YAML.dump(version)) }

    it 'increments major version and sets the prerelease to the supplied string' do
      described_class.inc_prerelease 'something'
      expect(described_class.current_version.to_s).to eq 'v2.0.0-something'
    end
  end

  describe 'release' do
    before { File.write(semver, YAML.dump( version.merge(special: "rc5") )) }

    it 'removes the prerelease' do
      expect{ described_class.release }
        .to change{ described_class.current_version.to_s}
        .from('v1.2.3-rc5')
        .to('v1.2.3')
    end
  end

  describe '#update_history_file' do
    context 'when there is no history file' do
      it 'does nothing' do
        expect{ described_class.update_history_file }
          .to_not change{ [history_rdoc, changelog].any?{|file| File.exists? file} }
          .from(false)
      end
    end

    context 'when there is a history.rdoc file' do
      before do
        File.write(semver, YAML.dump(version))
        File.write(history_rdoc, '* Some changes')
      end

      after { File.unlink(File.join(File.dirname(__FILE__), '../history.rdoc')) }

      it 'Adds the version number and date to the top of the file and adds it to git' do
        expect(Object).to receive(:`).with('git add history.rdoc')
        described_class.update_history_file
        expect(File.read(history_rdoc).lines.first).to eq "== v1.2.3 (#{Time.now.strftime "%d %B %Y"})\n"
      end
    end

    context 'when there is a CHANGELOG.md file' do
      before do
        File.write(semver, YAML.dump(version))
        File.write(changelog, '* Some changes')
      end

      after { File.unlink(changelog) }

      it 'Adds the version number and date to the top of the file and adds it to git' do
        expect(Object).to receive(:`).with('git add CHANGELOG.md')
        described_class.update_history_file
        expect(File.read(changelog).lines.first).to eq "== v1.2.3 (#{Time.now.strftime "%d %B %Y"})\n"
      end
    end
  end

  describe 'tag' do
    before { File.write(project_root_file('.semver'), YAML.dump(version)) }

    it 'tags with the curren semver release and outputs push instructions' do
      expect(Object).to receive(:`).with("git add .semver && git commit -m 'Increment version to v1.2.3' && git tag v1.2.3 -a -m '#{Time.now}'")
      expect(Object).to receive(:`).with('git symbolic-ref HEAD').and_return 'refs/heads/master'
      expect(Object).to receive(:puts).with("To push the new tag, use 'git push origin master --tags'")
      described_class.tag
    end
  end

end

