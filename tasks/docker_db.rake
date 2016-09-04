begin
  require_relative '../lib/docker_db'
  require_relative '../lib/assistant_baker'

  DDB = RakeNBake::DockerDb.new

  namespace :bake do
    namespace :docker_db do

      desc 'Start the dev DB container'
      task :start_dev do
        RakeNBake::AssistantBaker.log_step 'Starting dev DB'
        DDB.start_db :dev
      end

      desc 'Stop the dev DB container'
      task :stop_dev do
        RakeNBake::AssistantBaker.log_step 'Stopping dev DB'
        DDB.stop_db :dev
      end

      desc 'Restart the dev DB container'
      task :restart_dev do
        RakeNBake::AssistantBaker.log_step 'Restarting dev DB'
        DDB.restart_db :dev
      end

      desc 'Start the test DB container'
      task :start_test do
        RakeNBake::AssistantBaker.log_step 'Start test DB'
        DDB.start_db :test
      end

      desc 'Stop the test DB container'
      task :stop_test do
        RakeNBake::AssistantBaker.log_step 'Stop test DB'
        DDB.stop_db :test
      end

      desc 'Restart the test DB container'
      task :restart_test do
        RakeNBake::AssistantBaker.log_step 'Restarting test DB'
        DDB.restart_db :test
      end

      desc 'Start both dev and test DB containers'
      task :start do
        RakeNBake::AssistantBaker.log_step 'Starting both dev and test containers'
        DDB.start_db :dev
        DDB.start_db :test
      end

      desc 'Stop both dev and test DB containers'
      task :stop do
        RakeNBake::AssistantBaker.log_step 'Stopping both dev and test containers'
        DDB.stop_db :dev
        DDB.stop_db :test
      end

      desc 'Restart both dev and test DB containers'
      task :restart do
        RakeNBake::AssistantBaker.log_step 'Restarting both dev and test containers'
        DDB.stop_db :dev
        DDB.stop_db :test
        sleep 2
        DDB.start_db :dev
        DDB.start_db :test
        DDB.wait_for_db_to_start :dev
        DDB.wait_for_db_to_start :test
      end

      desc 'Check the test DB is running and start it if needs be'
      task :prepare_test do
        DDB.prepare_db(:test)
      end

      desc 'Build the docker image for all databases'
      task :build do
        RakeNBake::AssistantBaker.log_step 'Building Docker container'
        DDB.build_image
      end

      desc 'Write an example docker_db config file'
      task :example_config do
        DDB.write_example_config
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
