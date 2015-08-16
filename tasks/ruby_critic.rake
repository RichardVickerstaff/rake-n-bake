begin
  require "rubycritic"

  namespace :bake do
    task :rubycritic do
      RakeNBake::AssistantBaker.log_step 'Running rubycritic'
      system('rubycritic')
    end
  end

rescue LoadError
  tasks = %w[ rubycritic ]

  namespace :bake do
    tasks.map(&:to_sym).each do |t|
      desc 'rubycritic is not available (gem not installed)'
      task t do
        RakeNBake::AssistantBaker.log_missing_gem 'rubycritic'
        abort
      end
    end
  end
end
