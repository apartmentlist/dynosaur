# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynosaur/version'

Gem::Specification.new do |spec|
  spec.name          = 'dynosaur'
  spec.version       = Dynosaur::VERSION
  spec.authors       = ['Tom Collier']
  spec.email         = ['collier@apartmentlist.com']
  spec.license       = 'MIT'

  spec.summary = 'Run a rake task in a separate process (locally or on Heroku)'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f =~ %r{^(spec)/} }

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'platform-api', '>= 2.0', '< 2.4'
  spec.add_runtime_dependency 'sys-proctable', '>= 0.9', '< 2.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry-byebug', '~> 3'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3'
end
