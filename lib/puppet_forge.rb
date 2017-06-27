require 'puppet_forge/version'
require 'gettext-setup'

module PuppetForge
  class << self
    attr_accessor :user_agent
    attr_reader :host

    def host=(new_host)
      new_host = new_host.to_s
      new_host << '/' unless new_host[-1] == '/'

      # TODO: maybe freeze this
      @host = new_host
    end
  end

  GettextSetup.initialize(File.absolute_path('../locales', File.dirname(__FILE__)))

  DEFAULT_FORGE_HOST = 'https://forgeapi.puppetlabs.com/'

  self.host = DEFAULT_FORGE_HOST

  require 'puppet_forge/tar'
  require 'puppet_forge/unpacker'
  require 'puppet_forge/v3'

  const_set :Metadata, PuppetForge::V3::Metadata

  const_set :User, PuppetForge::V3::User
  const_set :Module, PuppetForge::V3::Module
  const_set :Release, PuppetForge::V3::Release
end
