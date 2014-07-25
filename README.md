RakeRack
========
[![Build Status](https://travis-ci.org/RichardVickerstaff/rake_rack.svg?branch=master)](https://travis-ci.org/RichardVickerstaff/rake_rack)
[![Gem Version](https://badge.fury.io/rb/rake_rack.svg)](http://badge.fury.io/rb/rake_rack)
Common rake tasks I use a lot
-----------------------------------------

PoolNet is a collection of rake tasks myself and other commanly use on our projects.
They have been extracted into a gem to allow them to easily be reused.

Installation
------------
* Install the gem or add `gem "rake_rack"` to your Gemfile.

Usage
-----
RakeRack is made up of many rake tasks, add `require "rake_rack"` to the top of your default.rake file to gain access to them.
You can then call them like you would any other rake task.

All tasks are namespaced with `:rake_rack` to prevent clashing with other tasks

### :code_quality
#### :all
Runs `[:trailing_spaces, :shoulds, :debugger, :pry, :console_log]` tasks. It does not run `:time_check`
##### :trailing_spaces
Check for trailing spaces in `[spec, features, lib, app, factories, db]`.
##### :shoulds
Check for legacy 'it "should blah"' style specs
##### :debugger
Check for debugger statements in `[lib, app, spec, features]`.
##### :pry
Check for binding.pry statements in `[lib, app, spec, features]`.
##### :console_log
Check for console.log statements in `app/assets/javascripys`.
##### :time_check
Check for `Time.now` statements in `[lib, app]` (Time.zone.now is more reliable for servers wanting to use UTC).
This check is NOT part of :all as `Time.zone.now` is an ActiveSupport method.

### :coverage
#### :check_specs
Look at SimpleCov results for spec coverage in `log/coverage/spec` and fail the build if not 100%
#### :check_cucumber
Look at SimpleCov results for Cucumber coverage in `log/coverage/features` and fail the build if not 100%

### :ok
Run this task last to print `***** ALL TESTS PASSED *****` showing you rake has passed.

ToDo
----
1. Add a list of all the rake tasks to the Readme
2. Add a cucumber rake task
