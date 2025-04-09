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
        errmsg = format('Unable to connect to %<scheme>s://%<host>s', scheme: baseurl.scheme, host: baseurl.host)
        if proxy = env[:request][:proxy]
          errmsg << (format(' (using proxy %<proxy>s)', proxy: proxy.uri.to_s))
        end
        errmsg << (format(' (for request %<path_query>s): %<message>s', message: e.message,
                                                                        path_query: baseurl.request_uri))
        m = Faraday::ConnectionFailed.new(errmsg)
        m.set_backtrace(e.backtrace)
        raise m
      end
    end
  end
end

Faraday::Middleware.register_middleware(connection_failure: PuppetForge::Connection::ConnectionFailure)
