
module PuppetForge
  class Tar
    require 'puppet_forge/tar/mini'

    def self.instance
      Mini.new
    end
  end
end
