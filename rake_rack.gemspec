# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rake_rack"
  spec.version       = '0.2.0'
  spec.authors       = ["Richard Vickerstaff"]
  spec.email         = ["m3akq@btinternet.com"]
  spec.description   = "A set of rake tasks I commonly use - Formerly known as pool_net"
  spec.summary       = "A set of rake tasks I commonly use"
  spec.homepage      = "https://github.com/RichardVickerstaff/rake_rack"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib","tasks"]

  spec.add_runtime_dependency "rake", "~> 10"
  spec.add_runtime_dependency "rspec", "~> 3.0"
end
