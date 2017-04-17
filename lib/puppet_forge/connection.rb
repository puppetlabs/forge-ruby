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

      # RK-229 Specific Workaround
      # Capture instance specific proxy setting if defined.
      if defined?(PuppetForge::V3::Base)
        if old_conn = PuppetForge::V3::Base.instance_variable_get(:@conn)
          self.proxy = old_conn.proxy.uri.to_s if old_conn.proxy
        end
      end
    end

    def self.authorization
      @authorization
    end

    def self.proxy=(url)
      url = nil if url.respond_to?(:empty?) && url.empty?
      @proxy = url
    end

    def self.proxy
      @proxy
    end

    def self.accept_language=(lang)
      lang = nil if lang.respond_to?(:empty?) && lang.empty?
      @accept_language = lang
    end

    def self.accept_language
      @accept_language
    end

    # @param reset_connection [Boolean] flag to create a new connection every time this is called
    # @param opts [Hash] Hash of connection options for Faraday
    # @return [Faraday::Connection] An existing Faraday connection if one was
    #   already set, otherwise a new Faraday connection.
    def conn(reset_connection = nil, opts = {})
      new_auth = @conn && @conn.headers['Authorization'] != PuppetForge::Connection.authorization
      new_proxy = @conn && ((@conn.proxy.nil? && PuppetForge::Connection.proxy) || (@conn.proxy && @conn.proxy.uri.to_s != PuppetForge::Connection.proxy))
      new_lang = @conn && @conn.headers['Accept-Language'] != PuppetForge::Connection.accept_language

      if reset_connection || new_auth || new_proxy || new_lang
        default_connection(opts)
      else
        @conn ||= default_connection(opts)
      end
    end

    # @param opts [Hash] Hash of connection options for Faraday
    def default_connection(opts = {})

      begin
        # Use Typhoeus if available.
        Gem::Specification.find_by_name('typhoeus', '~> 1.0.1')
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

      if lang = PuppetForge::Connection.accept_language
        options[:headers]['Accept-Language'] = lang
      end

      if proxy = PuppetForge::Connection.proxy
        options[:proxy] = proxy
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
