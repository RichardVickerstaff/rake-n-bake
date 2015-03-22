begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:"bake:rspec") do |t|
    t.verbose = false
    RakeNBake::AssistantBaker.log_step 'Running specs'
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
