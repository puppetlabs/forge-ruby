require 'her'
require 'her/lazy_accessors'
require 'her/lazy_relations'

require 'puppet_forge/middleware/json_for_her'
require 'puppet_forge/v3/base/paginated_collection'

module PuppetForge
  module V3

    # Acts as the base class for all PuppetForge::V3::* models. This class provides
    # some overrides of behaviors from Her, in addition to convenience methods
    # and abstractions of common behavior.
    #
    # @api private
    class Base
      include Her::Model
      include Her::LazyAccessors
      include Her::LazyRelations

      use_api begin
        begin
          # Use Typhoeus if available.
          Gem::Specification.find_by_name('typhoeus', '~> 0.6')
          require 'typhoeus/adapters/faraday'
          adapter = Faraday::Adapter::Typhoeus
        rescue Gem::LoadError
          adapter = Faraday::Adapter::NetHttp
        end

        Her::API.new :url => "#{PuppetForge.host}/v3/" do |c|
          c.use PuppetForge::Middleware::JSONForHer
          c.use adapter
        end
      end

      class << self
        # Overrides Her::Model#request to allow end users to dynamically update
        # both the Forge host being communicated with and the user agent string.
        #
        # @api private
        # @api her
        # @see Her::Model#request
        # @see PuppetForge.host
        # @see PuppetForge.user_agent
        def request(*args)
          unless her_api.base_uri =~ /^#{PuppetForge.host}/
            her_api.connection.url_prefix = "#{PuppetForge.host}/v3/"
          end

          her_api.connection.headers[:user_agent] = %W[
            #{PuppetForge.user_agent}
            PuppetForge.gem/#{PuppetForge::VERSION}
            Her/#{Her::VERSION}
            Faraday/#{Faraday::VERSION}
            Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_PLATFORM})
          ].join(' ').strip

          super
        end

        # Overrides Her::Model#new_collection with custom logic for handling the
        # paginated collections produced by the Forge API. These collections are
        # then wrapped in a {PaginatedCollection}, which enables navigation of
        # the paginated dataset.
        #
        # @api private
        # @api her
        # @param parsed_data [Hash<(:data, :errors)>] the parsed response data
        # @return [PaginatedCollection] the collection
        def new_collection(parsed_data)
          col = super :data =>     parsed_data[:data][:results],
                      :metadata => parsed_data[:data][:pagination],
                      :errors =>   parsed_data[:errors]

          PaginatedCollection.new(self, col.to_a, col.metadata, col.errors)
        end
      end

      # FIXME: We should provide an actual unique identifier.
      primary_key :slug
      store_metadata :_metadata
      after_initialize do
        attributes[:slug] ||= uri[/[^\/]+$/]
      end

      # Since our data is primarily URI based rather than ID based, we should
      # use our URIs as the request_path whenever possible.
      #
      # @api private
      # @api her
      # @see Her::Model::Paths#request_path
      def request_path(*args)
        if has_attribute? :uri then uri else super end
      end
    end
  end
end
