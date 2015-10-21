begin
  require 'bundler/audit/cli'

  namespace :bake do
    desc 'Check Gemfile.lock for security issues'
    task :'bundle-audit' do
      RakeNBake::AssistantBaker.log_step 'Checking gems for known security warnings'
      exit 1 unless system('bundle exec bundle-audit')
    end
  end

rescue LoadError

  tasks = %w[bundle-audit].map(&:to_sym)

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
