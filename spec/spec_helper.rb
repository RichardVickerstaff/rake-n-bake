require 'simplecov'
require 'timecop'
require 'tempfile'

def production_code
  spec = caller[0][/spec.+\.rb/]
  './'+ spec.gsub('_spec','').gsub(/spec/, 'lib')
end

SimpleCov.start do
  add_filter '/vendor/'
  add_filter '/spec/'
  coverage_dir 'log/coverage/spec'
end
