begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:"bake:rspec") do |t|
    t.verbose = false
    RakeNBake::AssistantBaker.log_step 'Running specs'
  end

  RSPEC_SUBDIRS = %w[integration features requests]

  RSPEC_SUBDIRS.each do |subdir|
    RSpec::Core::RakeTask.new(:"bake:rspec:#{subdir}") do |t|
      t.verbose = false
      t.pattern = "spec/#{subdir}/**/*_spec.rb"
      RakeNBake::AssistantBaker.log_step "Running #{subdir} specs"
    end
  end

  RSpec::Core::RakeTask.new(:"bake:rspec:unit") do |t|
    t.verbose = false
    file_list = FileList['spec/**/*_spec.rb']
    RSPEC_SUBDIRS.each do |subdir|
      file_list = file_list.exclude "spec/#{subdir}/**/*_spec.rb"
    end
    t.pattern = file_list
    RakeNBake::AssistantBaker.log_step 'Running unit specs'
  end

  RSpec::Core::RakeTask.new(:"bake:rspec:tag", :tag) do |t, task_args|
    t.verbose = false
    t.rspec_opts = "--tag #{task_args[:tag]}"
    RakeNBake::AssistantBaker.log_step "Running specs tagged #{task_args[:tag]}"
  end

  RSpec::Core::RakeTask.new(:"bake:rspec_test_prepare" => :"test:prepare") do |t|
    t.verbose = false
  end

rescue LoadError

  namespace :bake do
    %w[rspec rspec_test_prepare].map(&:to_sym).each do |t|
      desc 'RSpec rake tasks are not available (gem not installed)'
      task t do
        RakeNBake::AssistantBaker.log_missing_gem 'rspec', 'RSpec'
        abort
      end
    end
  end

end
