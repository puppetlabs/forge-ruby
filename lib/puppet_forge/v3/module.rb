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

    end
  end
end
