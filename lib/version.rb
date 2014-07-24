class RakeRack
  class Version
    HISTORY_FILE = "history.rdoc"
    def self.current_history history_file
      unless File.exists? history_file
         File.open history_file, "w" do |f|
           f.puts "== 0.0.0 (#{Time.now.strftime "%d %B %Y"})"
         end
      end
      File.read history_file
    end

    def self.latest_version
      latest_version_string = current_history(HISTORY_FILE)[/== ([\d\.]*)/, 1] || "0.0.0"
      @latest_version ||= latest_version_string.split(".").map(&:to_i)
      def @latest_version.to_s
        join "."
      end
      @latest_version
    end

    def self.update_to version
      add_history_header version
      update_gem version if gem?
      commit version
      tag version
      branch = `git symbolic-ref HEAD`[%r{.*/(.*)}, 1]
      puts "To push the new tag, use 'git push origin #{branch} --tags'"
    end

    def self.add_history_header(version, history_file = HISTORY_FILE)
      history = current_history history_file
      File.open history_file, "w" do |f|
        f.puts "== #{version} (#{Time.now.strftime "%d %B %Y"})"
        f.puts
        f.print history
      end
      puts "Added version to history.rdoc"
    end

    def self.update_gem version
      path = Dir.glob('*.gemspec').first
      text = File.read path
      File.open(path, "w") do |file|
        file.puts text.sub(/(.*version\s*=\s*)(['|"].*['|"])/, "\\1'#{version}'")
      end
      puts "Added version to .gemfile"
    end

    def self.commit version
      `git add . && git commit -m 'increment version to #{version}'`
      puts "Committed change"
    end

    def self.tag version
      `git tag #{version}`
      puts "Tagged with #{version}"
    end

    def self.gem?
      !Dir.glob('*.gemspec').empty?
    end
  end
end
