namespace :code_quality do
  desc 'Runs all code quality checks'
  task :all => [:trailing_spaces, :shoulds, :debugger, :pry, :console_log, :time_check]

  desc 'check for trailing spaces'
  task :trailing_spaces do
    grep_for_trailing_space %w{spec features lib app factories db}
  end

  desc %(check for legacy 'it "should blah"' style specs)
  task :shoulds do
    grep_for_shoulds %w{spec}
  end

  desc 'check for debugger statements'
  task :debugger do
    grep_for_debugger %w{lib app spec features}
  end

  desc 'check for binding.pry statements'
  task :pry do
    grep_for_pry %w{lib app spec features}
  end

  desc 'check for console.log'
  task :console_log do
    grep_for_console_log %w{app/assets/javascripts }
  end

  desc 'check for Time.now should use Time.zone.now'
  task :time_check do
    grep_for_time_now %w{app lib}
  end

  def grep_for_trailing_space *file_patterns
    grep '^.*[[:space:]]+$', file_patterns, 'trailing spaces', ['*.yml', '*.csv']
  end

  def grep_for_shoulds *file_patterns
    grep '^[[:space:]]*it "should.*$',
      file_patterns,
      'it block description starting with should'
  end

  def grep_for_pry *file_patterns
    grep 'binding.pry',
      file_patterns,
      'binding.pry statement found',
      %w[common_spec_helper.rb code_quality.rake]
  end

  def grep_for_debugger *file_patterns
    grep 'debugger',
      file_patterns,
      'debugger statement found',
      %w[common_spec_helper.rb code_quality.rake angular.js]
  end

  def grep_for_console_log *file_patterns
    grep 'console.log',
      file_patterns,
      'console.log statement found',
      %w[angular.js jquery.flot-0.8.1.js]
  end

  def grep_for_time_now *file_patterns
    grep "Time.now",
      file_patterns,
      "Time.now found, use Time.zone.now to prevent timezone conflicts",
      %w{*.rake}
  end

  def grep regex, file_patterns, error_message, exclude_patterns=[], perl_regex=false
    files_found = ""
    command = "grep -r -n --binary-files=without-match '#{regex}' #{file_patterns.join(' ')}"
    exclude_patterns.each do |exclude_pattern|
      command << " --exclude '#{exclude_pattern}'"
    end
    command << (perl_regex ? ' -P' : ' -E')
    files_found << `#{command}`
    abort("#{error_message} found:\n#{files_found}") unless files_found.empty?
  end
end
