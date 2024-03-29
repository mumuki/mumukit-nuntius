# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
config = File.expand_path('../config', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$LOAD_PATH.unshift(config) unless $LOAD_PATH.include?(config)
require 'mumukit/nuntius/version'

Gem::Specification.new do |spec|
  spec.name          = "mumukit-nuntius"
  spec.version       = Mumukit::Nuntius::VERSION
  spec.authors       = ["Franco Bulgarelli"]
  spec.email         = ["franco@mumuki.org"]
  spec.summary       = 'Library for working with rabbit queues'
  spec.homepage      = 'http://github.com/mumuki/mumukit-nuntius'
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/**'] + Dir['config/**']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib', 'config']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'mumukit-core', '~> 1.19'
  spec.add_dependency 'bunny', '~> 2.3'

  spec.required_ruby_version = '>= 3.0'
end
