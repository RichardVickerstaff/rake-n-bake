begin
  require 'brakeman'

  namespace :bake do

    desc "Run Brakeman"
    task :brakeman, :output_files do |t, args|
      RakeNBake::Baker.log_step 'Running Brakeman'

      files = args[:output_files].split(' ') if args[:output_files]
      Brakeman.run :app_path => ".", :output_files => files, :print_report => true
    end
  end

rescue LoadError
  tasks = %w[ brakeman ]

  namespace :bake do
    tasks.map(&:to_sym).each do |t|
      desc 'brakeman is not available (gem not installed)'
      task t do
        RakeNBake::Baker.log_missing_gem 'brakeman'
        abort
      end
    end
  end
end
