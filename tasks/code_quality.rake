namespace :bake do
  namespace :code_quality do
    desc 'Deprecated - Runs all code quality checks'
    task :all do
      RakeNBake::Baker.log_warn "This has been deprecated, use the rubocop task instead"
    end

    desc 'Deprecated - check for trailing spaces'
    task :trailing_spaces do
      RakeNBake::Baker.log_warn "This has been deprecated, use the rubocop task instead"
    end

    desc %(Deprecated - check for legacy 'it "should blah"' style specs)
    task :shoulds do
      RakeNBake::Baker.log_warn "This has been deprecated, use the rubocop task instead"
    end

    desc 'Deprecated - check for debugger statements'
    task :debugger do
      RakeNBake::Baker.log_warn "This has been deprecated, use the rubocop task instead"
    end

    desc 'Deprecated - check for binding.pry statements'
    task :pry do
      RakeNBake::Baker.log_warn "This has been deprecated, use the rubocop task instead"
    end

    desc 'Deprecated - check for console.log'
    task :console_log do
      RakeNBake::Baker.log_warn "This has been deprecated, use the rubocop task instead"
    end

    desc 'Deprecated - check for Time.now; should use Time.now.utc or Time.current'
    task :time_check do
      RakeNBake::Baker.log_warn "This has been deprecated, use the rubocop task instead"
    end
  end
end
