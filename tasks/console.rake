begin
  require "bundler/gem_tasks"

  task :console do
    require 'pry'

    def reload!
      files = $LOADED_FEATURES.select { |feat| feat =~ /\/gem_name\// }
      files.each { |file| load file }
    end

    ARGV.clear
    Pry.start
  end

rescue LoadError

  namespace :bake do
    namespace :console do
      %w[console].map(&:to_sym).each do |t|
        desc 'Console rake tasks are not available (gem not installed)'
        task t do
          RakeNBake::AssistantBaker.log_missing_gem 'pry'
          abort
        end
      end
    end
  end

end
