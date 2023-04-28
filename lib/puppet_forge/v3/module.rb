require 'puppet_forge/v3/base'
require 'puppet_forge/v3/user'
require 'puppet_forge/v3/release'

module PuppetForge
  module V3

    # Models a Puppet Module hosted on the Forge.
    class Module < Base
      lazy :owner, 'User'
      lazy :current_release, 'Release'
      lazy_collection :releases, 'Release'

      def self.find(slug)
        super
      rescue Faraday::ResourceNotFound
        raise PuppetForge::ModuleNotFound, "Module #{slug} not found"
      end
    end
  end
end
