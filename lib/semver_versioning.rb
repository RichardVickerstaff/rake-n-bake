require 'semver'

module RakeNBake
  class SemverVersioning
    def self.current_version
      if File.exist? SemVer.file_name
        SemVer.find
      else
        version = SemVer.new
        version.save SemVer.file_name
        SemVer.find
      end
    end

    def self.inc_major
      v = current_version
      v.major = v.major.to_i + 1
      v.minor = 0
      v.patch = 0
      v.save
    end

    def self.inc_minor
      v = current_version
      v.minor = v.minor.to_i + 1
      v.patch = 0
      v.save
    end

    def self.inc_patch
      v = current_version
      v.patch = v.patch.to_i + 1
      v.save
    end

    def self.prerelease s
      v = current_version
      v.special = s
      v.save
    end

    def self.inc_prerelease s
      inc_major
      v = current_version
      v.special = s
      v.save
    end

    def self.release
      v = current_version
      v.special = ''
      v.save
    end

    def self.update_history_file
      %w[ history.rdoc CHANGELOG.md ]
        .select {|file| File.exist? file}
        .each do |file|
          add_version_to_top(file)
          `git add #{file}`
        end
    end

    def self.update_version_rb
      return unless File.exists?('lib/version.rb')
      version = current_version.to_s.sub(/^v/,'')
      version_string = "VERSION = '#{version}'"
      version_file_content = File.read('lib/version.rb').sub(/VERSION = .*$/, version_string)
      File.write('lib/version.rb', version_file_content)
      `git add lib/version.rb`
    end

    def self.tag
      v = current_version.to_s
      `git add .semver && git commit -m 'Increment version to #{v}' && git tag #{v} -a -m '#{Time.now}'`
      branch = `git symbolic-ref HEAD`[%r{.*/(.*)}, 1]
      puts "To push the new tag, use 'git push origin #{branch} --tags'"
    end

    def self.add_version_to_top file
      current_history = File.read file
      File.open file, 'w' do |f|
        f.puts "== #{current_version} (#{Time.now.strftime "%d %B %Y"})"
        f.puts
        f.print current_history
      end
    end
  end
end
