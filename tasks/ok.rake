namespace :rake_rack do
  require 'term/ansicolor'
  include Term::ANSIColor

  task :ok do
    puts
    print [
      "*".bold.red,
      "*".bold.yellow,
      "*".bold.green,
      "*".bold.blue,
      "*".bold.magenta,
      " ALL TESTS PASSED ".bold.green,
      "*".bold.magenta,
      "*".bold.blue,
      "*".bold.green,
      "*".bold.yellow,
      "*".bold.red,
    ].join
    puts
  end

end
