require 'semantic_puppet'

module PuppetForge
  class Util
    def self.version_valid?(version)
        return SemanticPuppet::Version.valid?(version)
    end
  end
end
