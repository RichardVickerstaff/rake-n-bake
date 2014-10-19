require 'simplecov'
require 'timecop'
require 'tempfile'

SimpleCov.start do
  add_filter '/vendor/'
  add_filter '/spec/'
  coverage_dir 'log/coverage/spec'
end

require_relative '../lib/rake_rack'
