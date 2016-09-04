require 'docker'
require 'json'

module RakeNBake
  class DockerDb

    CONFIG_PATH = './docker_db.json'
    LOGGER = RakeNBake::AssistantBaker

    def db_config
      return $CONFIG unless $CONFIG.nil?
      if File.exists?(CONFIG_PATH)
        $CONFIG = JSON.parse(File.read(CONFIG_PATH))
      else
        LOGGER.log_warn "No docker_db config file found at #{CONFIG_PATH}, so cannot continue"
        LOGGER.log_warn "Check the path, or run `rake bake:docker_db:example_config` to write an example config file"
        abort
      end
    end

    def write_example_config
      path = CONFIG_PATH + '.example'
      example_config = {
        "docker_build_dir" => "dev/database-dockerfile",
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
      LOGGER.log_passed "Example config written to #{path}. Copy to #{CONFIG_PATH} and edit it"
    end

    def build_image
      image_name = db_config["image_name"]
      if image_exists?
        LOGGER.log_warn "Docker already has an image called #{image_name}, remove it with 'docker rm #{image_name}' and run this again if you want to force recreation" and fail
      end
      LOGGER.log_step "Building docker image"
      image = Docker::Image.build_from_dir(db_config['docker_build_dir'])
      image.tag('repo' => image_name, 'tag' => 'latest')
    end

    def build_container env
      image = db_config["image_name"]
      config = db_env(env)
      exposed_ports = config["ports"].each_with_object({}){|(guest, _host), out| out["#{guest}/tcp"] = {} }
      port_bindings = config["ports"].each_with_object({}){|(guest,  host), out| out["#{guest}/tcp"] = [{ "HostPort" => "#{host}" }] }
      LOGGER.log_step("Building container '#{config["name"]}'")
      Docker::Container.create(
        {
          'name' => config[:name],
          'Image' => image,
          'ExposedPorts' => exposed_ports ,
          'PortBindings' => port_bindings
        }
      )
    end

    def start_db env
      build_image unless image_exists?
      container = get_container_for(env) || build_container(env)
      container.start
    end

    def stop_db env
      config = db_env(env)
      container = Docker::Container.get( config.fetch("name") ) rescue nil
      if container
        container.kill
        container.remove
      end
    end

    def get_container_for env
      config = db_env(env)
      name = config["name"]
      Docker::Container.get(name) rescue nil
    end

    def restart_db env
      stop_db env
      sleep 2
      start_db env
      wait_for_db_to_start env
    end

    private def image_name
      db_config["image_name"]
    end

    private def db_env env
      db_config.fetch("environments").fetch(env.to_s)
    end

    private def image_exists?
      Docker::Image.exist? image_name
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
      LOGGER.log_step 'Checking that the DB is running'
      restart_if_needed env
      puts "OK"
      puts
      LOGGER.log_step 'Resetting DB'
      system("bundle exec rake db:reset RAILS_ENV=#{rails_env}")
      puts
    end

  end
end
