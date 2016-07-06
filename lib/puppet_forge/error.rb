require 'json'

module PuppetForge
  class Error < RuntimeError
    attr_accessor :original
    def initialize(message, original=nil)
      super(message)
      @original = original
    end
  end

  class ExecutionFailure < PuppetForge::Error
  end

  class InvalidPathInPackageError < PuppetForge::Error
    def initialize(options)
      @entry_path = options[:entry_path]
      @directory  = options[:directory]
      super _("Attempt to install file into %{path} under %{directory}") % {path: @entry_path.inspect, directory: @directory.inspect}
    end

    def multiline
      _("Could not install package\n  Package attempted to install file into\n  %{path} under %{directory}.") % {path: @entry_path.inspect, directory: @directory.inspect}
    end
  end

  class ModuleNotFound < PuppetForge::Error
  end

  class ReleaseNotFound < PuppetForge::Error
  end

  class ReleaseForbidden < PuppetForge::Error
    def self.from_response(response)
      body = JSON.parse(response[:body])
      new(body["message"])
    end
  end
end
