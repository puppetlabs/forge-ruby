require 'json'

module PuppetForge
  class Error < RuntimeError
    attr_accessor :original

    def initialize(message, original = nil)
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
      super("Attempt to install file into #{@entry_path.inspect} under #{@directory.inspect}")
    end

    def multiline
      <<~MSG.strip
        Could not install package
          Package attempted to install file into
          #{@entry_path.inspect} under #{@directory.inspect}.
      MSG
    end
  end

  class ErrorWithDetail < PuppetForge::Error
    def self.from_response(response)
      body = JSON.parse(response[:body])

      message = body['message']
      if body.key?('errors') && !body['errors']&.empty?
        message << "\nThe following errors were returned from the server:\n - #{body['errors'].join("\n - ")}"
      end

      new(message)
    end
  end

  class FileNotFound < PuppetForge::Error
  end

  class ModuleNotFound < PuppetForge::Error
  end

  class ReleaseNotFound < PuppetForge::Error
  end

  class ReleaseForbidden < PuppetForge::ErrorWithDetail
  end

  class ReleaseBadContent < PuppetForge::ErrorWithDetail
  end
end
