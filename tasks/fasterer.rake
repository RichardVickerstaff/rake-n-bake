begin
  require 'fasterer'

  namespace :bake do
    task :fasterer do
      RakeNBake::AssistantBaker.log_step 'Running Fasterer'
      system('fasterer')
    end
  end

rescue LoadError
  tasks = %w[ fasterer ]

  namespace :bake do
    tasks.map(&:to_sym).each do |t|
      desc 'fasterer is not available (gem not installed)'
      task t do
        RakeNBake::AssistantBaker.log_missing_gem 'fasterer'
        abort
      end
    end
  end
end
