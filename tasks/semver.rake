begin
  require_relative '../lib/semver_versioning'
  namespace :bake do
    namespace :semver do

      desc "Display the latest version (from .semver)"
      task :version do
        RakeNBake::SemverVersioning.current_version
      end

      desc 'Increment major version in .semver (eg 1.2.3 => 2.0.0)'
      task :major do
        RakeNBake::SemverVersioning.inc_major
        RakeNBake::SemverVersioning.update_history_file
        RakeNBake::SemverVersioning.tag
      end

      desc 'Increment minor version in .semver (eg 1.2.3 => 1.3.0)'
      task :minor do
        RakeNBake::SemverVersioning.inc_minor
        RakeNBake::SemverVersioning.update_history_file
        RakeNBake::SemverVersioning.tag
      end

      desc 'Increment patch version in .semver (eg 1.2.3 => 1.2.4)'
      task :patch do
        RakeNBake::SemverVersioning.inc_patch
        RakeNBake::SemverVersioning.update_history_file
        RakeNBake::SemverVersioning.tag
      end

      desc 'Add or modify the current prerelease version (eg 1.2.3-rc1 => 1.2.3-rc2'
      task :prerelease, [:version] do |task, args|
        version = args[:version] || fail("Invalid usage: rake bake:semver:prerelase['release name']")
        RakeNBake::SemverVersioning.prerelease version
        RakeNBake::SemverVersioning.update_history_file
        RakeNBake::SemverVersioning.tag
      end

      desc 'Increment major version and add a prerelease version (eg 1.2.3 => 2.0.0-rc1)'
      task :inc_prerelease, [:version] do |task, args|
        version = args[:version] || fail("Invalid usage: rake bake:semver:inc_prerelase['release name']")
        RakeNBake::SemverVersioning.inc_prerelease version
        RakeNBake::SemverVersioning.update_history_file
        RakeNBake::SemverVersioning.tag
      end

      desc 'Remove prerelease version (eg 1.2.3-rc2 => 1.2.3)'
      task :release do
        RakeNBake::SemverVersioning.release
        RakeNBake::SemverVersioning.update_history_file
        RakeNBake::SemverVersioning.tag
      end
    end
  end

rescue LoadError

  tasks = %w[version major minor patch prerelease inc_prerelease release].map(&:to_sym)

  namespace :bake do
    namespace :semver do
      tasks.each do |t|
        desc 'SemVer rake tasks are not available (gem not installed)'
        task t do
          $stdout.puts "This task is not available because the SemVer2 gem is not installed."
          $stderr.puts "Try adding \"gem 'semver2'\" to your Gemfile or run `gem semver2 rspec` and try again."
          abort
        end
      end
    end
  end

end
