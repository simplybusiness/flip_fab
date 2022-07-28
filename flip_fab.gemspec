lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flip_fab/version'

Gem::Specification.new do |spec|
  spec.name          = 'flip_fab'
  spec.version       = FlipFab::VERSION
  spec.authors       = ['Simply Business']
  spec.email         = ['tech@simplybusiness.co.uk']
  spec.description   = 'A gem providing persistent, per-user feature flipping to Rack applications.'
  spec.summary       = 'A gem providing persistent, per-user feature flipping to Rack applications.'
  spec.homepage      = 'https://github.com/simplybusiness/flip_fab'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rack', '>=2.1.1'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rutabaga', '~> 3.0'
  spec.add_development_dependency 'simplycop', '~> 1.9'
  spec.add_development_dependency 'timecop', '~> 0.8'
end
