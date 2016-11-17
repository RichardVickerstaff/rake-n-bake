require 'simplecov'
require 'timecop'
require 'tempfile'
require 'codeclimate-test-reporter'
require 'aruba/rspec'

require 'simplecov'
SimpleCov.start

def production_code
  spec = caller[0][/spec.+\.rb/]
  './' + spec.gsub('_spec', '').gsub(/spec/, 'lib')
end

def project_root_file name
  File.join(File.dirname(__FILE__), '..', name)
end

def backup_file_name(name)
  project_root_file(name) + '.orig'
end

def backup_file name
  file = project_root_file(name)
  backup = backup_file_name(name)
  FileUtils.mv file, backup if File.exist?(file)
end

def restore_file name
  file = project_root_file(name)
  backup = backup_file_name(name)
  FileUtils.mv backup, file if File.exist?(backup)
end

def remove_file name
  FileUtils.rm project_root_file(name), force: true
end

SEMVER_FILES = ['.semver', 'history.rdoc', 'CHANGELOG.md'].freeze

RSpec.configure do |config|
  config.include ArubaDoubles

  config.before :suite do
    Aruba::RSpec.setup
    SEMVER_FILES.map { |f| backup_file f }
  end

  config.after :suite do
    SEMVER_FILES.map { |f| restore_file f }
    Aruba::RSpec.teardown
  end
end

SimpleCov.start do
  add_filter '/vendor/'
  add_filter '/spec/'
  coverage_dir 'log/coverage/spec'
end
