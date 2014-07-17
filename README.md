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

ToDo
----
1. Add a list of all the rake tasks to the Readme
2. Add a cucumber rake task
