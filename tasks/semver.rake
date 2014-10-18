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

      desc 'Add a prerelease version'
      task :prerelease do
        RakeRack::SemverVersioning.prerelease "something"
        RakeRack::SemverVersioning.tag
      end

      desc 'Increment major version and add a prerelease version'
      task :inc_prerelease do
        RakeRack::SemverVersioning.inc_prerelease 'something'
        RakeRack::SemverVersioning.tag
      end

      desc 'Remove prerelease version'
      task :release do
        RakeRack::SemverVersioning.release
        RakeRack::SemverVersioning.tag
      end
    end
  end
rescue LoadError
  $stderr.puts "Error: Semver not avaialble"
end
