module Rake::Version
  def self.current_history
    File.read "history.rdoc"
  end

  def self.latest_version
    latest_version_string = current_history[/== ([\d\.]*)/, 1] || "0.0.0"
    @latest_version ||= latest_version_string.split(".").map(&:to_i)
    def @latest_version.to_s
      join "."
    end
    @latest_version
  end

  def self.update_to version
    add_history_header version
    commit version
    tag version
    branch = `git symbolic-ref HEAD`[%r{.*/(.*)}, 1]
    puts "To push the new tag, use 'git push origin #{branch} --tags'"
  end

  def self.add_history_header version
    history = current_history
    File.open "history.rdoc", "w" do |f|
      f.puts "== #{version} (#{Time.now.strftime "%d %B %Y"})"
      f.puts
      f.print history
    end
    puts "Added version to history.rdoc"
  end

  def self.commit version
    `git commit history.rdoc -m'increment version to #{version}'`
    puts "Committed change"
  end

  def self.tag version
    `git tag #{version}`
    puts "Tagged with #{version}"
  end
end

desc "Display the latest version (from history.rdoc)"
task :"rake_rack:version" do
  puts "Latest version is #{Rake::Version.latest_version}"
end

namespace :rake_rack do
  namespace :version do
    namespace :increment do
      desc "Increment the major version in history.rdoc (eg 1.2.3 => 2.0.0)"
      task :major do
        new_version = Rake::Version.latest_version
        new_version[0] += 1
        new_version[1,2] = 0, 0
        Rake::Version.update_to new_version
      end

      desc "Increment the minor version in history.rdoc (eg 1.2.3 => 1.3.0)"
      task :minor do
        new_version = Rake::Version.latest_version
        new_version[1] += 1
        new_version[2] = 0
        Rake::Version.update_to new_version
      end

      desc "Increment the patch version in history.rdoc (eg 1.2.3 => 1.2.4)"
      task :patch do
        new_version = Rake::Version.latest_version
        new_version[2] += 1
        Rake::Version.update_to new_version
      end
    end
  end
end
