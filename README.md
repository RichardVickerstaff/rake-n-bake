Rake-n-Bake
===========

Commonly used Rake tasks
------------------------
...collected together and baked to perfection, ready to serve!


[![Build Status](https://travis-ci.org/RichardVickerstaff/rake-n-bake.svg?branch=master)](https://travis-ci.org/RichardVickerstaff/rake-n-bake)
[![Gem Version](https://badge.fury.io/rb/rake-n-bake.svg)](http://badge.fury.io/rb/rake-n-bake)
[![Code Climate](https://codeclimate.com/github/RichardVickerstaff/rake-n-bake/badges/gpa.svg)](https://codeclimate.com/github/RichardVickerstaff/rake-n-bake)

Rake-n-Bake is a collection of widely applicable Rake tasks used on many projects.
They have been extracted into a gem to allow them to easily be reused and maintained.

Rake-n-Bake tasks are used on the project itself, so you can always take a peek at our [Rakefile](https://github.com/RichardVickerstaff/rake-n-bake/blob/master/Rakefile) or the [tasks themselves](https://github.com/RichardVickerstaff/rake-n-bake/tree/master/tasks) to work out what is going on

Installation
------------
Either:
  - Add `gem "rake-n-bake"` to your Gemfile and run bundle install.

or

  - Run `gem install rake-n-bake`

Usage
-----
  1. Add `require "rake-n-bake"` to your Rakefile
  2. Call the tasks that you want, just as with your usual Rake tasks (examples below!).

  For example:

```ruby
require "rake-n-bake"

task :default => %i[
  clean
  bake:rubocop
  bake:rspec
  bake:coverage:check_specs
  bake:bundle-audit
  bake:rubycritic
  bake:ok_rainbow
]

```

Tasks
-----
Tasks are namespaced under `:bake` to prevent clashes. For example, the `:ok` task is called by invoking `:bake:ok`

For a definitive list, run `rake -D` to see all Rake tasks.
You could also see only the Rake-n-Bake tasks by running `rake -D | grep -A3 'bake'`.

Below are some highlights of the tasks added.
Each can be invoked with `rake bake<task name>`, for example `rake bake:brakeman`

### :brakeman
Run [Brakeman](http://brakemanscanner.org/) to look for security issues on a Rails project

### :bundle-audit
Check the current Gemfile.lock for gem versions with known security issues, courtesy of [Bundler Audit](https://github.com/rubysec/bundler-audit#readme)

### :check_external_dependencies
Check that each command in the `@external_dependencies` array is present on the system path (and fails the task if it isn't)
For example:
  ```ruby
  @external_dependencies = ['ruby', 'postgres', 'foo']
  ```
You can also use the underlying checker object by creating an instance of `RakeNBake::DependencyChecker` with your array of dependencies and calling `#check` or `#missing` on it.

### :coverage
#### :check_specs
Look at SimpleCov results for spec coverage in `log/coverage/spec` and fail the build if not 100%
#### :check_cucumber
Look at SimpleCov results for Cucumber coverage in `log/coverage/features` and fail the build if not 100%

### :fasterer
Run the [fasterer](https://github.com/DamirSvrtan/fasterer) tool to spot performance improvements in your code

### :ok
Useful at the end of any Rake tasks which test your application, it prints `***** ALL TESTS PASSED *****`.

### :ok_rainbow
Run this task last to print a more magical version of `:ok`

### :rails_best_practices
Run this task to run the [Rails Best Practices](https://github.com/railsbp/rails_best_practices) metrics against your Rails project.

### :rspec
Run all the tests in the spec directory with rspec
#### :rspec:unit
Run all the specs not in a features or integration directory
#### :rspec:integration
Run all the specs in the integration directory
#### :rspec:requests
Run all the specs in the requests directory
#### :rspec:features
Run all the specs in the features directory
#### :rspec:tag[mytag]
Run all the specs tagged using `mytag: true`

### :rubocop
Runs [Rubocop](https://github.com/bbatsov/rubocop) over the project and lists violations/warnings

### :rubycritic
Runs the [RubyCritic](https://github.com/whitesmith/rubycritic) tool and generates a report about the health of your code

### :traceroute
Runs [Traceroute](https://rubygems.org/gems/traceroute), a tool for finding unused routes within [Rails](http://rubyonrails.org/) apps

### :yarn
#### :check
Runs the yarn integrity check [Yarn](https://yarnpkg.com/lang/en/docs/cli/check/)
#### :test
Runs the yarn test

Handy Tips for new tasks
------------------------
- All tasks loaded by `lib/rake_n_bake.rb` will have access to the `RakeNBake::Baker`. This is intended for truely common things, like logging out when a particular step runs or passes.

Contributing
------------
  1. Make a fork
  2. Make your changes!
    a. Namespace new tasks under `:bake`
    b. Namespace new helpers under `RakeNBake`
  3. Push your changes to your fork
  4. Create a Pull Request
