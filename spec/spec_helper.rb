require 'simplecov'
require 'timecop'
require 'tempfile'
require 'codeclimate-test-reporter'
require 'aruba/rspec'

CodeClimate::TestReporter.start

def production_code
  spec = caller[0][/spec.+\.rb/]
  './'+ spec.gsub('_spec','').gsub(/spec/, 'lib')
end

SimpleCov.start do
  add_filter '/vendor/'
  add_filter '/spec/'
  coverage_dir 'log/coverage/spec'
end

RSpec.configure do |config|
  config.include ArubaDoubles

  config.before :each do
    Aruba::RSpec.setup
  end

  config.after :each do
    Aruba::RSpec.teardown
  end
end
