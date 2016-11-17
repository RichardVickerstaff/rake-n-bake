begin
  require 'rubocop'

  namespace :bake do
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new

    task :rubocop_announce do
      RakeNBake::Baker.log_step "Running Rubocop"
    end

    task :rubocop => :rubocop_announce
  end

rescue LoadError
  tasks = %w[ rubocop ]

  namespace :bake do
    tasks.map(&:to_sym).each do |t|
      desc 'rubocop is not available (gem not installed)'
      task t do
        RakeNBake::Baker.log_missing_gem 'rubocop'
        abort
      end
    end
  end
end
