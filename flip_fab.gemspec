# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flip_fab/version'

gem_version = if ENV['GEM_PRE_RELEASE'].nil? || ENV['GEM_PRE_RELEASE'].empty?
  FlipFab::VERSION
else
  "#{FlipFab::VERSION}.#{ENV['GEM_PRE_RELEASE']}"
end

Gem::Specification.new do |spec|
  spec.name          = 'flip_fab'
  spec.version       = gem_version
  spec.authors       = ['Simply Business']
  spec.email         = ['tech@simplybusiness.co.uk']
  spec.description   = 'A gem providing persistent, per-user feature flipping to Rack applications.'
  spec.summary       = 'A gem providing persistent, per-user feature flipping to Rack applications.'
  spec.homepage      = 'https://github.com/simplybusiness/flip_fab'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'http://gemstash.simplybusiness.io/private'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rack', '~> 2.0'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rutabaga', '~> 2.1'
  spec.add_development_dependency 'timecop', '~> 0.8'
  spec.add_development_dependency 'rubocop', '~> 0.46'
end
