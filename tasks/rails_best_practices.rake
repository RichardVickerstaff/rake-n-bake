begin
  require 'rails_best_practices'

  namespace :bake do
    desc 'A code metric tool to check the quality of rails code'
    task :rails_best_practices do
      RakeNBake::AssistantBaker.log_step 'Running Rails Best Practices'
      fail unless system('bundle exec rails_best_practices')
    end
  end

rescue LoadError
  namespace :bake do
    desc 'Rails Best Practices is not available (gem not installed)'
    task :rails_best_practices do
      $stdout.puts 'This task is not avaialble because the Rails Best Practices gem is not installed'
      $stderr.puts "Try adding \"gem 'rails_best_practices'\" to your Gemfile and try again"
    end
  end
end
