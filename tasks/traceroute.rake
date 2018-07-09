if defined? Rails
  begin
    require 'traceroute'

    namespace :bake do
      task :traceroute do
        RakeNBake::Baker.log_step 'Running Traceroute'
        Rake::Task['traceroute'].invoke
      end
    end

  rescue LoadError
    tasks = %w[ traceroute ]

    namespace :bake do
      tasks.map(&:to_sym).each do |t|
        desc 'Traceroute is not available (gem not installed)'
        task t do
          RakeNBake::Baker.log_missing_gem 'traceroute'
          abort
        end
      end
    end
  end
else
  tasks = %w[ traceroute ]

  namespace :bake do
    tasks.map(&:to_sym).each do |t|
      desc 'Traceroute is not available Rails is required'
      task t do
        RakeNBake::Baker.log_warn 'Traceroute requires rails'
        abort
      end
    end
  end
end
