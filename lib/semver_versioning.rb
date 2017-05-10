require 'semver'

module RakeNBake
  class SemverVersioning

    def initialize
      @version = current_version
    end

    def current_version
      unless File.exist? SemVer.file_name
        version = SemVer.new
        version.save SemVer.file_name
      end
      SemVer.find
    end

    def inc_major
      @version.major = @version.major.to_i + 1
      @version.minor = 0
      @version.patch = 0
      @version.save
    end

    def inc_minor
      @version.minor = @version.minor.to_i + 1
      @version.patch = 0
      @version.save
    end

    def inc_patch
      @version.patch = @version.patch.to_i + 1
      @version.save
    end

    def prerelease s
      @version.special = s
      @version.save
    end

    def inc_prerelease s
      inc_major
      @version.special = s
      @version.save
    end

    def release
      @version.special = ''
      @version.save
    end

    def update_history_file
      %w[history.rdoc CHANGELOG.md]
        .select { |file| File.exist? file }
        .each do |file|
          add_version_to_top(file)
          `git add #{file}`
        end
    end

    def update_version_rb
      version_files = Dir.glob('lib{,/*}/version.rb').uniq
      return unless version_files.size == 1
      version_file = version_files[0]

      version = current_version.to_s.sub(/^v/, '')
      version_string = "VERSION = '#{version}'"
      version_file_content = File.read(version_file).sub(/VERSION = .*$/, version_string)

      File.write(version_file, version_file_content)
      `git add #{version_file}`
    end

    def tag
      v = current_version.to_s
      `git add .semver && git commit -m 'Increment version to #{v}' && git tag #{v} -a -m '#{Time.now}'`
      branch = `git symbolic-ref HEAD`[%r[.*/(.*)], 1]
      puts "To push the new tag, use 'git push origin #{branch} --tags'"
    end

    def add_version_to_top filepath
      heading_marker = (filepath =~ /rdoc$/) ? '==' : '##'
      current_history = File.read filepath
      File.open filepath, 'w' do |f|
        f.puts "#{heading_marker} #{current_version} (#{Time.now.strftime '%d %B %Y'})"
        f.puts
        f.print current_history
      end
    end

  end
end
