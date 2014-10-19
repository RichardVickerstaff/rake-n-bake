require 'bundler/audit/cli'

namespace :rake_rack do
  desc 'Check Gemfile.lock for security issues'
  task :bundler_audit do
    Bundler::Audit::CLI.start
  end
end
