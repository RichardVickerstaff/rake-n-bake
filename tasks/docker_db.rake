begin
  require_relative '../lib/docker_db'
  require_relative '../lib/assistant_baker'

  DDB = RakeNBake::DockerDb.new

  namespace :bake do
    namespace :docker_db do

      desc 'Write an example docker_db config file'
      task :example_config do
        DDB.write_example_config
      end

      desc 'Build the docker image for all databases'
      task :build do
        RakeNBake::AssistantBaker.log_step 'Building Docker container'
        DDB.build_image
      end

      DDB.db_config['environments'].each do |env_name, env_details|

        desc "Start the #{env_name} DB container"
        task "start_#{env_name}".to_sym do
          RakeNBake::AssistantBaker.log_step 'Starting #{env_name} DB'
          DDB.start_db env_name
        end

        desc "Stop the #{env_name} DB container"
        task "stop_#{env_name}".to_sym do
          RakeNBake::AssistantBaker.log_step "Stopping #{env_name} DB"
          DDB.stop_db env_name
        end

        desc "Restart the #{env_name} DB container"
        task "restart_#{env_name}".to_sym do
          RakeNBake::AssistantBaker.log_step "Restarting #{env_name} DB"
          DDB.restart_db env_name
        end
      end
    end
  end

rescue LoadError

  namespace :bake do
    namespace :docker_db do
      %w[ start stop restart start_dev start_test stop_dev stop_test restart_dev restart_test build prepare_test_db example_config].map(&:to_sym).each do |t|
        desc 'docker_db rake tasks are not available (gem not installed)'
        task t do
          RakeNBake::AssistantBaker.log_missing_gem 'Docker API', 'docker-api'
          abort
        end
      end
    end
  end
end
