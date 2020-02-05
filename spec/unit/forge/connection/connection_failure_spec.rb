require 'spec_helper'

# The adapter NetHttp must be required before the SocketError (used below) is accessible
require 'faraday/adapter/net_http'

describe PuppetForge::Connection::ConnectionFailure do

  subject do
    Faraday.new('https://my-site.url/some-path') do |builder|
      builder.use(:connection_failure)

      builder.adapter :test do |stub|
        stub.get('/connectfail') { raise Faraday::ConnectionFailed.new(SocketError.new("getaddrinfo: Name or service not known"), :hi) }
        stub.get('/timeout') { raise Faraday::TimeoutError, "request timed out" }
      end
    end
  end

  it "includes the base URL in the error message" do
    expect {
      subject.get('/connectfail')
    }.to raise_error(Faraday::ConnectionFailed, /unable to connect to.*\/connectfail.*name or service not known/i)
  end

  it "logs for timeout errors" do
    expect {
      subject.get('/timeout')
    }.to raise_error(Faraday::ConnectionFailed, /unable to connect to.*\/timeout.*request timed out/i)
  end

  it "includes the proxy host in the error message when set" do
    if subject.respond_to?(:proxy=)
      subject.proxy = 'https://some-unreachable.proxy:3128'
    else
      subject.proxy('https://some-unreachable.proxy:3128')
    end

    expect {
      subject.get('/connectfail')
    }.to raise_error(Faraday::ConnectionFailed, /unable to connect to.*using proxy.*\/connectfail.*name or service not known/i)
  end
end
