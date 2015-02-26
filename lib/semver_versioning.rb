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
      supported_history_files = %w[ history.rdoc CHANGELOG.md ]
      supported_history_files
        .select {|histf| File.exist? histf}
        .map do |histf|
          current_history = File.read histf
          File.open histf, 'w' do |f|
            f.puts "== #{current_version} (#{Time.now.strftime "%d %B %Y"})"
            f.puts
            f.print current_history
          end
          `git add #{histf}`
        end
    end

    def self.prepare_history_file_from_git
      last_tag = `git describe --abbrev=0 --tags`.chomp
      changes_since_last_tag = `git log --graph --oneline #{last_tag}..HEAD | grep '^*' | grep -vE '[Mm]erge|[Ii]ncrement' | cut -d' ' -f1 -f3-`
      supported_history_files = %w[ history.rdoc CHANGELOG.md ]
      supported_history_files
        .select {|histf| File.exist? histf}
        .map do |histf|
          current_history = File.read histf
          File.open histf, 'w' do |f|
            changes_since_last_tag.each_line do |line|
              f.puts line.chomp
            end
            f.puts
            f.print current_history
          end
        end
      puts "History file updated with changes from git."
    end

    def self.tag
      v = current_version.to_s
      `git add .semver && git commit -m 'Increment version to #{v}' && git tag #{v} -a -m '#{Time.now}'`
      branch = `git symbolic-ref HEAD`[%r{.*/(.*)}, 1]
      puts "To push the new tag, use 'git push origin #{branch} --tags'"
    end
  end
end

