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
        if proxy = env[:request][:proxy]
          errmsg = _("Unable to connect to %{scheme}://%{host} (using proxy %{proxy}) (for request %{path_query})") % {
            scheme: baseurl.scheme,
            host: baseurl.host,
            proxy: proxy.uri.to_s,
            path_query: baseurl.request_uri,
          }
        else
          errmsg = _("Unable to connect to %{scheme}://%{host} (for request %{path_query})") % {
            scheme: baseurl.scheme,
            host: baseurl.host,
            path_query: baseurl.request_uri,
          }
        end
        errmsg << ": #{e.message}"
        m = Faraday::ConnectionFailed.new(errmsg)
        m.set_backtrace(e.backtrace)
        raise m
      end
    end
  end
end

Faraday::Middleware.register_middleware(:connection_failure => lambda { PuppetForge::Connection::ConnectionFailure })
