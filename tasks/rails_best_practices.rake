begin
  require 'rails_best_practices'

  namespace :bake do
    desc 'a code metric tool to check the quality of rails code'
    task :rails_best_practices do
      RakeNBake::AssistantBaker.log_step 'Running Rails best practices'
      fail unless system('bundle exec rails_best_practices')
    end
  end

rescue LoadError
  namespace :bake do
    desc 'rails best practices is not available (gem not installed)'
    task :rails_best_practices do
      RakeNBake::AssistantBaker.log_missing_gem 'rails_best_practices'
      abort
    end
  end
end
