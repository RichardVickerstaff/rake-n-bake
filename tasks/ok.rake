require 'term/ansicolor'

namespace :rake_rack do
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

  task :ok_rainbow do
    puts
    print "  ",           "   ",            "    ",            "                  ".on_red,     "    ",            "   ",            "  ",           "\n"
    print "  ",           "   ",            "    ".on_red,     "                  ".on_yellow,  "    ".on_red,     "   ",            "  ",           "\n"
    print "  ",           "   ".on_red,     "    ".on_yellow,  "                  ".on_green,   "    ".on_yellow,  "   ".on_red,     "  ",           "\n"
    print "  ".on_red,    "   ".on_yellow,  "    ".on_green,   "                  ".on_blue,    "    ".on_green,   "   ".on_yellow,  "  ".on_red,    "\n"
    print "  ".on_yellow, "   ".on_green,   "    ".on_blue,    "                  ".on_magenta, "    ".on_blue,    "   ".on_green,   "  ".on_yellow, "\n"
    print "  ".on_green,  "   ".on_blue,    "    ".on_magenta, "                  ",            "    ".on_magenta, "   ".on_blue,    "  ".on_green,  "\n"
    print "  ".on_blue,   "   ".on_magenta, "    ",            " ALL TESTS PASSED".bold.green,  "     ".green,     "   ".on_magenta, "  ".on_blue,   "\n"
    puts
  end
end
