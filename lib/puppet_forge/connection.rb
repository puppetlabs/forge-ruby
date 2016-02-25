require 'puppet_forge/connection/connection_failure'

require 'faraday'
require 'faraday_middleware'
require 'puppet_forge/middleware/symbolify_json'

module PuppetForge
  # Provide a common mixin for adding a HTTP connection to classes.
  #
  # This module provides a common method for creating HTTP connections as well
  # as reusing a single connection object between multiple classes. Including
  # classes can invoke #conn to get a reasonably configured HTTP connection.
  # Connection objects can be passed with the #conn= method.
  #
  # @example
  #   class HTTPThing
  #     include PuppetForge::Connection
  #   end
  #   thing = HTTPThing.new
  #   thing.conn = thing.make_connection('https://non-standard-forge.site')
  #
  # @api private
  module Connection

    attr_writer :conn

    USER_AGENT = "#{PuppetForge.user_agent} PuppetForge.gem/#{PuppetForge::VERSION} Faraday/#{Faraday::VERSION} Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_PLATFORM})".strip

    def self.authorization=(token)
      @authorization = token
    end

    def self.authorization
      @authorization
    end

    # @param reset_connection [Boolean] flag to create a new connection every time this is called
    # @param opts [Hash] Hash of connection options for Faraday
    # @return [Faraday::Connection] An existing Faraday connection if one was
    #   already set, otherwise a new Faraday connection.
    def conn(reset_connection = nil, opts = {})
      if reset_connection
        default_connection(opts)
      else
        @conn ||= default_connection(opts)
      end
    end

    # @param opts [Hash] Hash of connection options for Faraday
    def default_connection(opts = {})

      begin
        # Use Typhoeus if available.
        Gem::Specification.find_by_name('typhoeus', '~> 0.6')
        require 'typhoeus/adapters/faraday'
        adapter = :typhoeus
      rescue Gem::LoadError
        adapter = Faraday.default_adapter
      end

      make_connection(PuppetForge.host, [adapter], opts)
    end
    module_function :default_connection

    # Generate a new Faraday connection for the given URL.
    #
    # @param url [String] the base URL for this connection
    # @param opts [Hash] Hash of connection options for Faraday
    # @return [Faraday::Connection]
    def make_connection(url, adapter_args = nil, opts = {})
      adapter_args ||= [Faraday.default_adapter]
      options = { :headers => { :user_agent => USER_AGENT } }.merge(opts)

      if token = PuppetForge::Connection.authorization
        options[:headers][:authorization] = token
      end

      Faraday.new(url, options) do |builder|
        builder.use PuppetForge::Middleware::SymbolifyJson
        builder.response(:json, :content_type => /\bjson$/)
        builder.response(:raise_error)
        builder.use(:connection_failure)

        builder.adapter(*adapter_args)
      end
    end
    module_function :make_connection
  end
end
