begin
  require 'semver'
  namespace :rake_rack do
    namespace :semver do

      desc "Display the latest version (form .semver)"
      task :version do
        RakeRack::SemverVersioning.latest_version
        RakeRack::SemverVersioning.tag
      end

      desc 'Increment major version in .semver (eg 1.2.3 => 2.0.0)'
      task :major do
        RakeRack::SemverVersioning.inc_major
        RakeRack::SemverVersioning.tag
      end

      desc 'Increment minor version in .semver (eg 1.2.3 => 1.3.0)'
      task :minor do
        RakeRack::SemverVersioning.inc_minor
        RakeRack::SemverVersioning.tag
      end

      desc 'Increment patch version in .semver (eg 1.2.3 => 2.0.0)'
      task :patch do
        RakeRack::SemverVersioning.inc_patch
        RakeRack::SemverVersioning.tag
      end

      desc 'Add or modify the current prerelease version (eg 1.2.3 => 1.2.3-rc1'
      task :prerelease, [:version] do |task, args|
        version = args[:version] || fail("Invalid usage: rake rake_rack:semver:prerelase['release name']")
        RakeRack::SemverVersioning.prerelease version
        RakeRack::SemverVersioning.tag
      end

      desc 'Increment major version and add a prerelease version (eg 1.2.3-rc1 => 1.2.3-rc2)'
      task :inc_prerelease, [:version] do |task, args|
        version = args[:version] || fail("Invalid usage: rake rake_rack:semver:inc_prerelase['release name']")
        RakeRack::SemverVersioning.inc_prerelease version
        RakeRack::SemverVersioning.tag
      end

      desc 'Remove prerelease version (eg 1.2.3-rc2 => 1.2.3)'
      task :release do
        RakeRack::SemverVersioning.release
        RakeRack::SemverVersioning.tag
      end
    end
  end
rescue LoadError
  $stderr.puts "Error: Semver not avaialble"
end
