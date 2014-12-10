# coding: utf-8
require File.expand_path('../lib/version', __FILE__)
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rake-n-bake"
  spec.version       = RakeNBake::VERSION
  spec.authors       = ["Richard Vickerstaff", "Adam Whittingham"]
  spec.email         = ["m3akq@btinternet.com", "adam.whittingham@gmail.com"]
  spec.description   = "Common rake tasks, baked to perfection and ready to serve!"
  spec.summary       = "Common rake tasks, baked to perfection and ready to serve!"
  spec.homepage      = "https://github.com/RichardVickerstaff/rake-n-bake"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib","tasks"]

  spec.add_runtime_dependency "rake", "~> 10"
  spec.add_runtime_dependency "term-ansicolor", "~> 1.3"
end
