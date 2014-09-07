require 'simplecov'
require 'timecop'
require 'tempfile'

SimpleCov.start do
  add_filter '/vendor/'
  coverage_dir 'log/coverage/spec'
end

require_relative '../lib/rake_rack'
