begin
  require 'docker'
  require 'json'

  IMAGE_NAME = 'oracle-xe'
  CONFIG = {
    dev:   { name: 'sh24-db-dev',  ports: {22 => 49160, 1521 => 49161, 8080 => 49162}, rails_env: 'development' },
    test:  { name: 'sh24-db-test', ports: {22 => 49260, 1521 => 49261, 8080 => 49262}, rails_env: 'test' }
  }

  DB_READY_LOG_MESSAGE = "\u0001\u0000\u0000\u0000\u0000\u0000\u0000\u001EStarting Oracle Net Listener.\n\u0001\u0000\u0000\u0000\u0000\u0000\u00007Starting Oracle Database 11g Express Edition instance.\n\u0001\u0000\u0000\u0000\u0000\u0000\u0000\u0001\n"
  DB_DOCKERFILE = 'dev/oracle-xe-docker'

  CONFIG_PATH = './docker_db.rake'

  def db_config
    if File.exists?(CONFIG_PATH)
      JSON.parse(File.read(CONFIG_PATH))
    else
      RakeNBake::AssistantBaker::log_warn "No docker_db config file found at #{CONFIG_PATH}, so cannot continue"
      RakeNBake::AssistantBaker::log_warn "Check the path, or run `rake bake:docker_db:example_config` to write an example config file"
      abort
    end
  end

  def write_example_config
    path = CONFIG_PATH + '.example'
    example_config = {
      "db_dockerfile" => "dev/database-dockerfile",
      "image_name" => "my_docker_image",
      "db_ready_log_message" => 'Database listening',
      "environments" => {
        "dev" => {
          "name" => "my-project-dev-db",
          "ports" => { 22 => 49100, 1521 => 49101 },
          "rails_env" => 'development'
        },
        "test" => {
          "name" => "my-project-test-db",
          "ports" => { 22 => 49200, 1521 => 49201 },
          "rails_env" => 'development'
        },
      },
    }
    json_config = JSON.pretty_generate(example_config)
    File.write(path, json_config)
    path
  end

  def build_container
    image = Docker::Image.build_from_dir(DB_DOCKERFILE)
    image.tag('repo' => IMAGE_NAME, 'tag' => 'latest')
  end

  def start_db env
    config = db_config.fetch( env.to_sym )
    exposed_ports = config[:ports].each_with_object({}){|(guest, _host), out| out["#{guest}/tcp"] = {} } 
    port_bindings = config[:ports].each_with_object({}){|(guest,  host), out| out["#{guest}/tcp"] = [{ "HostPort" => "#{host}" }] }
    container = Docker::Container.create(
      {
        'name' => config[:name],
        'Image' => IMAGE_NAME,
        'ExposedPorts' => exposed_ports ,
        'PortBindings' => port_bindings
      }
    )
    container.start
  end

  def stop_db env
    config = db_config.fetch( env.to_sym )
    container = Docker::Container.get( config.fetch(:name) ) rescue nil
    if container
      container.kill
      container.remove
    end
  end

  def get_container_for env
    config = db_config.fetch( env.to_sym )
    name = config[:name]
    Docker::Container.get(name) rescue nil
  end

  def restart_db env
    stop_db env
    sleep 2
    start_db env
    wait_for_db_to_start env
  end

  def container_ready? env
    container_running?(env) && db_listening?(env)
  end

  def container_running? env
    container = get_container_for(env)
    container && container.json["State"]["Running"]
  end

  def db_listening? env
    container = get_container_for env
    container.logs(stdout: true).include? DB_READY_LOG_MESSAGE
  end

  def wait_for_db_to_start env
    name = db_config.fetch( env.to_sym ).fetch(:name)
    i = 0
    sleepy_time = 0.1
    spin = ['\\', '|', '/', '-']
    loop do
      spinr = spin[i % spin.length]
      print "\rWaiting for DB to start inside contained '#{name}' #{spinr} "

      if db_listening?(env)
        puts "\b\b Done!"
        break
      end

      i += 1
      sleep sleepy_time
    end
  end

  def restart_if_needed env
    restart_db(env) unless container_ready?(env)
  end

  def prepare_db env
    rails_env = db_config.fetch( env.to_sym ).fetch(:rails_env)
    RakeNBake::AssistantBaker.log_step 'Checking that the DB is running'
    restart_if_needed env
    puts "OK"
    puts
    RakeNBake::AssistantBaker.log_step 'Resetting DB'
    system("bundle exec rake db:reset RAILS_ENV=#{rails_env}")
    puts
  end

  namespace :bake do
  namespace :docker_db do
    desc 'Start the dev DB container'
    task :start_dev do
      RakeNBake::AssistantBaker.log_step 'Starting dev DB'
      start_db :dev
    end

    desc 'Stop the dev DB container'
    task :stop_dev do
      RakeNBake::AssistantBaker.log_step 'Stopping dev DB'
      stop_db :dev
    end

    desc 'Restart the dev DB container'
    task :restart_dev do
      RakeNBake::AssistantBaker.log_step 'Restarting dev DB'
      restart_db :dev
    end

    desc 'Start the test DB container'
    task :start_test do
      RakeNBake::AssistantBaker.log_step 'Start test DB'
      start_db :test
    end

    desc 'Stop the test DB container'
    task :stop_test do
      RakeNBake::AssistantBaker.log_step 'Stop test DB'
      stop_db :test
    end

    desc 'Restart the test DB container'
    task :restart_test do
      RakeNBake::AssistantBaker.log_step 'Restarting test DB'
      restart_db :test
    end

    desc 'Start both dev and test DB containers'
    task :start do
      RakeNBake::AssistantBaker.log_step 'Starting both dev and test containers'
      start_db :dev
      start_db :test
    end

    desc 'Stop both dev and test DB containers'
    task :stop do
      RakeNBake::AssistantBaker.log_step 'Stopping both dev and test containers'
      stop_db :dev
      stop_db :test
    end

    desc 'Restart both dev and test DB containers'
    task :restart do
      RakeNBake::AssistantBaker.log_step 'Restarting both dev and test containers'
      stop_db :dev
      stop_db :test
      sleep 2
      start_db :dev
      start_db :test
      wait_for_db_to_start :dev
      wait_for_db_to_start :test
    end

    desc 'Check the test DB is running and start it if needs be'
    task :prepare_test do
      prepare_db(:test)
    end

    desc 'Build the docker image for all databases'
    task :build do
      RakeNBake::AssistantBaker.log_step 'Building Docker container'
      build_container
    end

    desc 'Write an example docker_db config file'
    task :example_config do
      RakeNBake::AssistantBaker.log_step "Writing example docker_db.yaml"
      path = write_example_config
      RakeNBake::AssistantBaker.log_passed "Example config written to #{path}"
    end
  end
  end

rescue LoadError

  namespace :bake do
    namespace :docker_db do
      %w[ start stop restart start_dev start_test stop_dev stop_test restart_dev restart_test build prepare_test_db example_config].map(&:to_sym).each do |t|
        desc 'docker_db rake tasks are not available (gem not installed)'
        task t do
          RakeNBake::AssistantBaker.log_missing_gem 'Docker API', 'docker'
          abort
        end
      end
    end
  end
end
