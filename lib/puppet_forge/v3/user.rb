require 'puppet_forge/v3/base'
require 'puppet_forge/v3/module'

module PuppetForge
  module V3

    # Models a Forge user's account.
    class User < Base

      include PuppetForge::LazyAccessors

      # Returns a collection of Modules owned by the user.
      #
      # @note Because there is no related module data in the record, we can't
      #       use a {#lazy_collection} here.
      #
      # @return [PaginatedCollection<Module>] the modules owned by this user
      def modules
        Module.where(:owner => username)
      end
    end
  end
end
