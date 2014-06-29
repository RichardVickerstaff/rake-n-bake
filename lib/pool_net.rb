require 'rake'

dir = File.dirname(__FILE__)
dir.gsub!('lib', 'tasks')
Dir.glob("#{dir}/*.rake").each { |r| import r}
