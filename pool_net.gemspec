# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "pool_net"
  spec.version       = '0.0.1'
  spec.authors       = ["Richard Vickerstaff"]
  spec.email         = ["m3akq@btinternet.com.com"]
  spec.description   = "A set of rake tasks I commonly use"
  spec.summary       = "A set of rake tasks I commonly use"
  spec.homepage      = "https://github.com/RichardVickerstaff/pool_net"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib","tasks"]
end
