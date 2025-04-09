require 'spec_helper'

# The adapter NetHttp must be required before the SocketError (used below) is accessible
require 'faraday/adapter/net_http'

describe PuppetForge::Connection::ConnectionFailure do
  subject do
    Faraday.new('https://my-site.url/some-path') do |builder|
      builder.use(:connection_failure)

      builder.adapter :test do |stub|
        stub.get('/connectfail') do
          raise Faraday::ConnectionFailed.new(SocketError.new('getaddrinfo: Name or service not known'), :hi)
        end
        stub.get('/timeout') { raise Faraday::TimeoutError, 'request timed out' }
      end
    end
  end

  it 'includes the base URL in the error message' do
    expect do
      subject.get('/connectfail')
    end.to raise_error(Faraday::ConnectionFailed, %r{unable to connect to.*/connectfail.*name or service not known}i)
  end

  it 'logs for timeout errors' do
    expect do
      subject.get('/timeout')
    end.to raise_error(Faraday::ConnectionFailed, %r{unable to connect to.*/timeout.*request timed out}i)
  end

  it 'includes the proxy host in the error message when set' do
    if subject.respond_to?(:proxy=)
      subject.proxy = 'https://some-unreachable.proxy:3128'
    else
      subject.proxy('https://some-unreachable.proxy:3128')
    end

    expect do
      subject.get('/connectfail')
    end.to raise_error(Faraday::ConnectionFailed,
                       %r{unable to connect to.*using proxy.*/connectfail.*name or service not known}i)
  end
end
