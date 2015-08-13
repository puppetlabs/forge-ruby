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

        # @private
        def request(resource, item = nil, params = {})
          unless conn.url_prefix =~ /^#{PuppetForge.host}/
            conn.url_prefix = "#{PuppetForge.host}"
          end


          if item.nil?
            uri_path = "/v3/#{resource}"
          else
            uri_path = "/v3/#{resource}/#{item}"
          end

          conn.get uri_path, params
        end

        def find(slug)
          return nil if slug.nil?

          resp = request("#{self.name.split("::").last.downcase}s", slug)

          self.new(resp.body)
        end

        def where(params)
          resp = request("#{self.name.split("::").last.downcase}s", nil, params)

          new_collection(resp)
        end

        # Return a paginated collection of all modules
        def all(params = {})
          where(params)
        end

        def get_collection(uri_path)
          resource, params = split_uri_path uri_path
          resp = request(resource, nil, params)

          new_collection(resp)
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
