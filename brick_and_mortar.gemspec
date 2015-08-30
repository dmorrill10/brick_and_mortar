# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'brick_and_mortar/version'

Gem::Specification.new do |spec|
  spec.name          = 'brick_and_mortar'
  spec.version       = BrickAndMortar::VERSION
  spec.authors       = ['Dustin Morrill']
  spec.email         = ['dmorrill10@gmail.com']
  spec.summary       = 'BrickAndMortar: A Solid Foundation for Software Projects'
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'git'
  spec.add_dependency 'rubyzip'
  spec.add_dependency 'contextual_exceptions'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'simplecov'
end