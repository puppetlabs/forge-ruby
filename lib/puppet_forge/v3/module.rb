require 'puppet_forge/v3/base'
require 'puppet_forge/v3/user'
require 'puppet_forge/v3/release'

module PuppetForge
  module V3

    # Models a Puppet Module hosted on the Forge.
    class Module < Base
      def initialize(json_response)
        @owner_info = json_response['owner']
        @current_release = Release.new(json_response['current_release'])

        super
      end

      def owner
        @owner ||= User.find(@owner_info['username'])
        @owner
      end

      def current_release
        @current_release
      end

      def releases
        @releases ||= Release.where(:module => slug)

        @releases
      end
    end
  end
end
