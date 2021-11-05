require 'faraday'

module PuppetForge
  module Connection
    # Wrap Faraday connection failures to include the host and optional proxy
    # in use for the failed connection.
    class ConnectionFailure < Faraday::Middleware
      def call(env)
        @app.call(env)
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
        baseurl = env[:url].dup
        errmsg = "Unable to connect to %{scheme}://%{host}" % { scheme: baseurl.scheme, host: baseurl.host }
        if proxy = env[:request][:proxy]
          errmsg << " (using proxy %{proxy})" % { proxy: proxy.uri.to_s }
        end
        errmsg << " (for request %{path_query}): %{message}" % { message: e.message, path_query: baseurl.request_uri }
        m = Faraday::ConnectionFailed.new(errmsg)
        m.set_backtrace(e.backtrace)
        raise m
      end
    end
  end
end

Faraday::Middleware.register_middleware(:connection_failure => lambda { PuppetForge::Connection::ConnectionFailure })
