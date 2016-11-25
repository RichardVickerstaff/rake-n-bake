require 'term/ansicolor'

namespace :bake do
  C = Term::ANSIColor

  desc 'Print the "ALL TESTS PASSED" message'
  task :ok do
    puts
    print [
      C.bold,
      C.red,     "*",
      C.yellow,  "*",
      C.green,   "*",
      C.blue,    "*",
      C.magenta, "*",
      C.green,   " ALL TESTS PASSED ",
      C.magenta, "*",
      C.blue,    "*",
      C.green,   "*",
      C.yellow,  "*",
      C.red,     "*",
      C.clear
    ].join
    puts
  end

  desc 'Print the "ALL TESTS PASSED" message WITH A SWEET RAINBOW!!!'
  task :ok_rainbow do
    title = "ALL TESTS PASSED"
    sement_size = %w[ - -- --- ----- ----------- ----- --- -- - ]
    rows = [
      [ :clear,  :clear,   :clear,   :clear,   :red,     :clear,   :clear,   :clear,   :clear  ],
      [ :clear,  :clear,   :clear,   :red,     :yellow,  :red,     :clear,   :clear,   :clear  ],
      [ :clear,  :clear,   :red,     :yellow,  :green,   :yellow,  :red,     :clear,   :clear  ],
      [ :clear,  :red,     :yellow,  :green,   :blue,    :green,   :yellow,  :red,     :clear  ],
      [ :red,    :yellow,  :green,   :blue,    :magenta, :blue,    :green,   :yellow,  :red    ],
      [ :yellow, :green,   :blue,    :magenta, :clear,   :magenta, :blue,    :green,   :yellow ],
      [ :green,  :blue,    :magenta, :clear,   :clear,   :clear,   :magenta, :blue,    :green  ],
      [ :blue,   :magenta, :text,    :text,    :text,    :text,    title,    :magenta, :blue   ],
    ]

    puts
    rows.each do |row|
      text_block_length = 0
      sement_size.zip(row).each do |size, colour|
        string = size.gsub('-',' ')
        case colour
        when :clear
          print C.clear(string)
        when :text
          text_block_length += size.length
        when String
          text_block_length += size.length
          print C.bold, C.green(colour.center(text_block_length)), C.clear
        else
          cmd = "on_#{colour}".to_sym
          print C.send(cmd, string)
        end
      end
      puts
    end
    puts C.reset
  end

  begin
    require 'terminal-notifier'

    desc 'Show the test complete message using Terminal Notifier'
    task :ok_term_notifier do
      dir_name = File.basename(Dir.getwd)
      TerminalNotifier.notify('All tests passed!', title: "#{dir_name} build complete!", group: dir_name, app_icon: 'Ruby' )
    end

  rescue LoadError
    tasks = %w[ ok_term_notifier ]

    tasks.map(&:to_sym).each do |t|
      desc 'Terminal Notifier is not available (gem not installed)'
      task t do
        RakeNBake::Baker.log_missing_gem 'terminal-notifier'
        abort
      end
    end
  end
end
