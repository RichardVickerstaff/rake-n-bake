begin
  require 'bundler/audit/cli'

  namespace :bake do
    desc 'Check Gemfile.lock for security issues'
    task :bundler_audit do
      Bundler::Audit::CLI.start
    end
  end

rescue LoadError

  tasks = %i[bundler_audit]

  namespace :bake do
    tasks.each do |t|
      desc "This task is not available"
      task t do
        $stderr.puts "This task is not available because '#{missing}' is not available."
        $stderr.puts "Try adding \"gem 'bundler-audit'\" to your Gemfile or run `gem install bundler-audit` and try again."
        abort
      end
    end
  end
end
