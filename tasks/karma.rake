namespace :rake_rack do
  desc "Run JavaScript specs with Karma"
  task :karma do
    project_root = File.join(File.dirname(__FILE__), '../..')
    karma = File.join(project_root, 'node_modules', 'karma', 'bin', 'karma')
    File.exists?(karma) or fail "Karma not installed - did you run `npm install`?"

    system "#{karma} start #{project_root}/spec/javascripts/karma.conf.js --single-run" or fail
  end
end
