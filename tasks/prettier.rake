# frozen_string_literal: true

begin
  namespace :bake do
    desc 'Format the code'
    task :prettier do
      RakeNBake::Baker.log_step 'Running Prettier'
      format = system('prettier')

      if format
        RakeNBake::Baker.log_passed 'Formatting complete'
      else
        puts
        RakeNBake::Baker.log_warn 'Please run "yarn install"'
        raise
      end
    end
  end
end
