require 'puppet_forge/connection'
require 'puppet_forge/v3/base/paginated_collection'
require 'puppet_forge/error'

require 'puppet_forge/lazy_accessors'
require 'puppet_forge/lazy_relations'

module PuppetForge
  module V3

    # Acts as the base class for all PuppetForge::V3::* models.
    #
    # @api private
    class Base
      include PuppetForge::LazyAccessors
      include PuppetForge::LazyRelations

      def initialize(json_response)
        @attributes = json_response
        orm_resp_item json_response
      end

      def orm_resp_item(json_response)
        json_response.each do |key, value|
          unless respond_to? key
            define_singleton_method("#{key}") { @attributes[key] }
            define_singleton_method("#{key}=") { |val| @attributes[key] = val }
          end
        end
      end

      # @return true if attribute exists, false otherwise
      #
      def has_attribute?(attr)
        @attributes.has_key?(:"#{attr}")
      end

      def attribute(name)
        @attributes[:"#{name}"]
      end

      def attributes
        @attributes
      end

      class << self

        include PuppetForge::Connection

        API_VERSION = "v3"

        def api_version
          API_VERSION
        end

        # @private
        def request(resource, item = nil, params = {}, reset_connection = false, conn_opts = {})
          conn(reset_connection, conn_opts) if reset_connection
          unless conn.url_prefix =~ /^#{PuppetForge.host}/
            conn.url_prefix = "#{PuppetForge.host}"
          end

          if item.nil?
            uri_path = "v3/#{resource}"
          else
            uri_path = "v3/#{resource}/#{item}"
          end

          PuppetForge::V3::Base.conn.get uri_path, params
        end

        # @private
        def find_request(slug, reset_connection = false, conn_opts = {})
          return nil if slug.nil?

          resp = request("#{self.name.split("::").last.downcase}s", slug, {}, reset_connection, conn_opts)

          self.new(resp.body)
        end

        def find(slug)
          find_request(slug)
        end

        def find_stateless(slug, conn_opts = {})
          find_request(slug, true, conn_opts)
        end

        # @private
        def where_request(params, reset_connection = false, conn_opts = {})
          resp = request("#{self.name.split("::").last.downcase}s", nil, params, reset_connection, conn_opts)

          new_collection(resp)
        end

        def where(params)
          where_request(params)
        end

        def where_stateless(params, conn_opts = {})
          where_request(params, true, conn_opts)
        end

        # Return a paginated collection of all modules
        def all(params = {})
          where(params)
        end

        # Return a paginated collection of all modules
        def all_stateless(params = {}, conn_opts = {})
          where_stateless(params, conn_opts)
        end

        # @private
        def get_collection_request(uri_path, reset_connection = false, conn_opts = {})
          resource, params = split_uri_path uri_path
          resp = request(resource, nil, params, reset_connection, conn_opts)

          new_collection(resp)
        end

        def get_collection(uri_path)
          get_collection_request(uri_path)
        end

        def get_collection_stateless(uri_path, conn_opts)
          get_collection_request(uri_path, true, conn_opts)
        end

        # Faraday's Util#escape method will replace a '+' with '%2B' to prevent it being
        # interpreted as a space. For compatibility with the Forge API, we would like a '+'
        # to be interpreted as a space so they are changed to spaces here.
        def convert_plus_to_space(str)
          str.gsub(/[+]/, ' ')
        end

        # @private
        def split_uri_path(uri_path)
          all, resource, params = /(?:\/v3\/)([^\/]+)(?:\?)(.*)/.match(uri_path).to_a

          params = convert_plus_to_space(params).split('&')

          param_hash = Hash.new
          params.each do |param|
            key, val = param.split('=')
            param_hash[key] = val
          end

          [resource, param_hash]
        end

        # @private
        def new_collection(faraday_resp)
          if faraday_resp[:errors].nil?
            PaginatedCollection.new(self, faraday_resp.body[:results], faraday_resp.body[:pagination], nil)
          else
            PaginatedCollection.new(self)
          end
        end
      end
    end
  end
end
