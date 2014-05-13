require 'bundler/setup'
require 'backports/1.9.1/enumerator/new' if RUBY_VERSION == '1.8.7'

require "puppet_forge/version"

require 'typhoeus/adapters/faraday'

module PuppetForge
  class << self
    attr_accessor :user_agent
    attr_accessor :host
  end

  self.host = 'https://forgeapi.puppetlabs.com'

  require 'puppet_forge/v3'

  const_set :User, PuppetForge::V3::User
  const_set :Module, PuppetForge::V3::Module
  const_set :Release, PuppetForge::V3::Release
end
