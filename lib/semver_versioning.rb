require 'semver'
class RakeRack
  class SemverVersioning
    def self.current_version
      if File.exist? SemVer.file_name
        SemVer.find
      else
        version = SemVer.new
        version.save SemVer.file_name
        version
      end
    end

    def self.inc_major
      v = current_version
      v.major = v.major.to_i + 1
      v.minor = '0'
      v.patch = '0'
      v.save
    end

    def self.inc_minor
      v = current_version
      v.minor = v.minor.to_i + 1
      v.patch = '0'
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

    def self.tag
      v = current_version.to_s
      `git add .semver && git commit -m 'Increment version to #{v}' && git tag #{v}`
      branch = `git symbolic-ref HEAD`[%r{.*/(.*)}, 1]
      puts "To push the new tag, use 'git push origin #{branch} --tags'"
    end
  end
end

