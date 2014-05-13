module PuppetForge

  # Namespace for Faraday middleware used by this project.
  module Middleware

    # This middleware transforms the incoming JSON data into the format
    # expected by Her, but does so only conditionally, based on the incoming
    # content type. This allows the model's simple Her connection to be used to
    # download non-JSON content without blowing up.
    #
    # @private
    class JSONForHer < Her::Middleware::DefaultParseJSON

      # Overrides Her::Middleware::DefaultParseJSON#parse with a way to bypass
      # the default handling of a :metadata key – we want metadata to be handled
      # lazily, just like every other attribute, and we don't use the :metadata
      # key the way they expect us to.
      #
      # @see Her::Middleware::DefaultParseJSON#parse
      def parse(body)
        json = parse_json(body)
        errors = json.delete(:errors) || {}
        return { :data => json, :errors => errors, :metadata => {} }
      end

      # Overrides Her::Middleware::DefaultParseJSON#on_complete with a bail-out
      # plan - if the content-type is non-JSON, the JSON processing is skipped.
      #
      # @see Her::Middleware::DefaultParseJSON#on_complete
      def on_complete(env)
        env[:response] ||= env[:response_headers] # Faraday forward compatibility with 0.9.x
        return env unless env[:response]['content-type'] =~ /\bjson($|;)/
        super
      end
    end
  end
end
