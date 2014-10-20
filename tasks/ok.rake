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
    puts
    print C.clear(    "  "),  C.clear(     "   "),  C.clear(     "    "),       C.on_red(    "                  "), C.clear(     "    "), C.clear(     "   "), C.clear(     "  "),"\n"
    print C.clear(    "  "),  C.clear(     "   "),  C.on_red(    "    "),       C.on_yellow( "                  "), C.on_red(    "    "), C.clear(     "   "), C.clear(     "  "),"\n"
    print C.clear(    "  "),  C.on_red(    "   "),  C.on_yellow( "    "),       C.on_green(  "                  "), C.on_yellow( "    "), C.on_red(    "   "), C.clear(     "  "),"\n"
    print C.on_red(   "  "),  C.on_yellow( "   "),  C.on_green(  "    "),       C.on_blue(   "                  "), C.on_green(  "    "), C.on_yellow( "   "), C.on_red(    "  "),"\n"
    print C.on_yellow("  "),  C.on_green(  "   "),  C.on_blue(   "    "),       C.on_magenta("                  "), C.on_blue(   "    "), C.on_green(  "   "), C.on_yellow( "  "),"\n"
    print C.on_green( "  "),  C.on_blue(   "   "),  C.on_magenta("    "),       C.clear(     "                  "), C.on_magenta("    "), C.on_blue(   "   "), C.on_green(  "  "),"\n"
    print C.on_blue(  "  "),  C.on_magenta("   "),  C.clear(     "    "), C.bold, C.green(   " ALL TESTS PASSED "), C.clear(     "    "), C.on_magenta("   "), C.on_blue(   "  "),"\n"
    puts C.reset
  end
end
