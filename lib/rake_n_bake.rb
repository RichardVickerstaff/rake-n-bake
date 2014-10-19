$:.unshift File.dirname(__FILE__)

require 'rake'

lib = File.expand_path("../lib", File.dirname(__FILE__))
Dir.glob("#{lib}/*.rb").each{|l| require l}

dir = File.expand_path("../tasks", File.dirname(__FILE__))
Dir.glob("#{dir}/*.rake").each { |r| import r}
