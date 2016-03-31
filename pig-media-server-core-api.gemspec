# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pig-media-server-core-api/version'

Gem::Specification.new do |spec|
  spec.name          = "pig-media-server-core-api"
  spec.version       = PigMediaServerCoreAPI::VERSION
  spec.authors       = ["ssig33"]
  spec.email         = ["mail@ssig33.com"]

  spec.summary       = %q{Pig Media Server Core API}
  spec.description   = %q{Pig Media Server Core API}
  spec.homepage      = "http://github.com/ssig33/pig-media-server"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = %w(pig-media-server-core-api)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.licenses = ["MIT"]


  spec.add_dependency 'rroonga'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'unicorn'
  spec.add_dependency 'pit'
  spec.add_dependency 'sewell'
  spec.add_dependency 'pony'
  spec.add_dependency 'builder'
  spec.add_dependency 'thor'
  spec.add_dependency 'haml'
  spec.add_dependency 'activesupport'
end
