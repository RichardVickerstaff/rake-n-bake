begin
  require 'bundler/audit/cli'

  namespace :bake do
    desc 'Check Gemfile.lock for security issues'
    task :bundler_audit do
      RakeNBake::AssistantBaker.log_step 'Checking gems for known security warnings'
      Bundler::Audit::CLI.start
    end
  end

rescue LoadError

  tasks = %w[bundler_audit].map(&:to_sym)

  namespace :bake do
    tasks.each do |t|
      desc "This task is not available"
      task t do
        RakeNBake::AssistantBaker.log_missing_gem 'bundler-audit'
        abort
      end
    end
  end
end
