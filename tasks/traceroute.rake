begin
  require 'traceroute'

  namespace :bake do
    Rake::Task["traceroute"].invoke
  end

rescue LoadError
  tasks = %w[ traceroute ]

  namespace :bake do
    tasks.map(&:to_sym).each do |t|
      desc 'Traceroute is not available (gem not installed)'
      task t do
        RakeNBake::AssistantBaker.log_missing_gem 'traceroute'
        abort
      end
    end
  end
end
