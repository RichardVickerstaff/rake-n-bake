require 'bundler/audit/cli'

namespace :bake do
  desc 'Check Gemfile.lock for security issues'
  task :bundler_audit do
    Bundler::Audit::CLI.start
  end
end
