begin
  namespace :bake do
    namespace :yarn do
      desc 'Check coverage from Cucumber'
      task :check do
        RakeNBake::Baker.log_step 'Running yarn check'
        check = system('yarn check --integrity')

        if check
          RakeNBake::Baker.log_passed 'Yarn us up to date'
        else
          puts
          RakeNBake::Baker.log_warn 'please run  "yarn install"'
          raise
        end
      end

      desc 'Check coverage from Cucumber'
      task :test do
        RakeNBake::Baker.log_step 'Running yarn test'
        check = system('yarn test')

        if check
          RakeNBake::Baker.log_passed 'All tests passed'
        else
          puts
          RakeNBake::Baker.log_warn 'Fail'
          raise
        end
      end
    end
  end
end
