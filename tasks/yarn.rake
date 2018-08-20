begin
  namespace :bake do
    namespace :yarn do
      task :check do
        RakeNBake::Baker.log_step 'Running yarn check'
        check = system('yarn check --integrity')

        if check
          RakeNBake::Baker.log_passed 'Yarn us up to date'
        else
          puts
          RakeNBake::Baker.log_warn 'please run  "yarn install"'
          fail
        end
      end
    end
  end
end
