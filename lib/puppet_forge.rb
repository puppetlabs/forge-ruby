require 'puppet_forge/version'

module PuppetForge
  class << self
    attr_accessor :user_agent
    attr_accessor :host
  end

  self.host = 'https://forgeapi.puppetlabs.com'

  require 'puppet_forge/tar'
  require 'puppet_forge/unpacker'
  require 'puppet_forge/v3'

  const_set :Metadata, PuppetForge::V3::Metadata

  const_set :User, PuppetForge::V3::User
  const_set :Module, PuppetForge::V3::Module
  const_set :Release, PuppetForge::V3::Release
end
