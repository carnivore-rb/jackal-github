$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'jackal-github/version'
Gem::Specification.new do |s|
  s.name = 'jackal-github'
  s.version = Jackal::Github::VERSION.version
  s.summary = 'Message processing helper'
  s.author = 'Chris Roberts'
  s.email = 'code@chrisroberts.org'
  s.homepage = 'https://github.com/carnivore-rb/jackal-github'
  s.description = 'GitHub payload event helper'
  s.require_path = 'lib'
  s.license = 'Apache 2.0'
  s.add_runtime_dependency 'jackal', '>= 0.3.10', '< 1.0.0'
  s.add_development_dependency 'carnivore-http'
  s.files = Dir['lib/**/*'] + %w(jackal-github.gemspec README.md CHANGELOG.md CONTRIBUTING.md LICENSE)
end
