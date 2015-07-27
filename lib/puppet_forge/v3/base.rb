require 'puppet_forge/v3/base/paginated_collection'
require 'faraday'
require 'faraday_middleware'

module PuppetForge
  module V3

    # Acts as the base class for all PuppetForge::V3::* models.
    #
    # @api private
    class Base

      def initialize(json_response)
        @attributes = json_response
        orm_resp_item json_response
      end

      def orm_resp_item(json_response)
        json_response.each do |key, value|
          unless respond_to? key
            define_singleton_method(key) { @attributes[key] }
            define_singleton_method("#{key}=") { |val| @attributes[key] = val }
          end
        end
      end

      class << self

        def faraday_api
          # Initialize faraday_api if it has not been
          if @faraday_api.nil?
            begin
              # Use Typhoeus if available.
              Gem::Specification.find_by_name('typhoeus', '~> 0.6')
              require 'typhoeus/adapters/faraday'
              adapter = Faraday::Adapter::Typhoeus
            rescue Gem::LoadError
              adapter = Faraday.default_adapter
            end

            @faraday_api = Faraday.new :url => "#{PuppetForge.host}" do |c|
              c.response :json, :content_type => 'application/json'
              c.adapter adapter
            end
          end

          @faraday_api
        end

        # @private
        def request(resource, item = nil, params = {})
          unless faraday_api.url_prefix =~ /^#{PuppetForge.host}/
            faraday_api.url_prefix = "#{PuppetForge.host}"
          end

          faraday_api.headers["User-Agent"] = %W[
            #{PuppetForge.user_agent}
            PuppetForge.gem/#{PuppetForge::VERSION}
            Faraday/#{Faraday::VERSION}
            Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_PLATFORM})
          ].join(' ').strip

          if item.nil?
            uri_path = "/v3/#{resource}"
          else
            uri_path = "/v3/#{resource}/#{item}"
          end

          faraday_api.get uri_path, params
        end

        def find(slug)
          return nil if slug.nil?

          resp = request("#{self.name.split("::").last.downcase}s", slug)

          if resp.status >= 400 || !resp.body['errors'].nil?
            nil
          else
            self.new(resp.body)
          end
        end

        def where(params)
          resp = request("#{self.name.split("::").last.downcase}s", nil, params)

          new_collection(resp)
        end

        def get_collection(uri_path)
          resource, params = split_uri_path uri_path
          resp = request(resource, nil, params)

          new_collection(resp)
        end

        # @private
        def split_uri_path(uri_path)
          all, resource, params = /(?:\/v3\/)([^\/]+)(?:\?)(.*)/.match(uri_path).to_a

          params = params.split('&')

          param_hash = Hash.new
          params.each do |param|
            key, val = param.split('=')
            param_hash[key] = val
          end

          [resource, param_hash]
        end

        # @private
        def new_collection(faraday_resp)
          return PaginatedCollection.new(self) unless faraday_resp[:errors].nil?
          PaginatedCollection.new(self, faraday_resp.body['results'], faraday_resp.body['pagination'], nil)
        end
      end
    end
  end
end
