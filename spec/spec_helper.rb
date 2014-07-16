require 'simplecov'
require 'pry-byebug'
require 'timecop'


SimpleCov.start do
  coverage_dir 'log/coverage/spec'
end

require_relative '../lib/rake_rack'
