# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet_forge/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet_forge"
  spec.version       = PuppetForge::VERSION
  spec.authors       = ["Puppet Labs"]
  spec.email         = ["forge-team+api@puppetlabs.com"]
  spec.summary       = "Access and manipulate the Puppet Forge API from Ruby."
  spec.homepage      = "https://github.com/puppetlabs/forge-ruby"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_runtime_dependency "faraday", "~> 0.9.0"
  spec.add_runtime_dependency "faraday_middleware", "~> 0.9.0"
  spec.add_dependency 'semantic_puppet', '~> 0.1.0'
  spec.add_dependency 'minitar'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "cane"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet"
end
