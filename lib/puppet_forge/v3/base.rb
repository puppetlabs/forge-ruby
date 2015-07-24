require 'faraday'
require 'faraday_middleware'

module PuppetForge
  module V3

    # Acts as the base class for all PuppetForge::V3::* models.
    #
    # @api private
    class Base

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

            @faraday_api = Faraday.new :url => "#{PuppetForge.host}/v3/" do |c|
              c.response :json, :content_type => 'application/json'
              c.adapter adapter
            end
          end

          @faraday_api
        end

        # @private
        def request(resource, item = nil, params = {})
          unless faraday_api.url_prefix =~ /^#{PuppetForge.host}/
            faraday_api.url_prefix = "#{PuppetForge.host}/v3/"
          end

          faraday_api.headers["User-Agent"] = %W[
            #{PuppetForge.user_agent}
            PuppetForge.gem/#{PuppetForge::VERSION}
            Faraday/#{Faraday::VERSION}
            Ruby/#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL} (#{RUBY_PLATFORM})
          ].join(' ').strip

          if item.nil?
            uri_path = resource
          else
            uri_path = "#{resource}/#{item}"
          end

          faraday_api.get uri_path, params
        end

        def find(slug)
          request("#{self.name.split("::").last.downcase}s", slug)
        end

        def where(params)
          request("#{self.name.split("::").last.downcase}s", nil, params)
        end
      end
    end
  end
end
