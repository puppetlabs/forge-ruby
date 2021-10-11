Gem::Specification.new do |spec|
  spec.name          = "forge-ruby"
  spec.version       = "9002.0"
  spec.authors       = ["Puppet Labs"]
  spec.email         = ["forge-team+api@puppetlabs.com"]
  spec.summary       = "Convenience gem to prevent brandjacking for the puppet_forge gem."
  spec.description   = "Convenience gem to prevent brandjacking for the puppet_forge gem."
  spec.homepage      = "https://github.com/puppetlabs/forge-ruby"
  spec.license       = "Apache-2.0"

  spec.add_dependency "puppet_forge"

  spec.post_install_message = "Please install the puppet_forge gem instead."
end

