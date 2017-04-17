require 'spec_helper'

describe PuppetForge::Connection do
  before(:each) do
    PuppetForge.host = "https://forgeapi.puppetlabs.com"
  end

  let(:test_conn) do
    PuppetForge::Connection
  end

  describe 'class methods' do
    subject { described_class }

    describe '#proxy=' do
      after(:each) do
        subject.proxy = nil
      end

      it "sets @proxy to value when passed non-empty string" do
        proxy = "http://proxy.example.com:3128"

        subject.proxy = proxy

        expect(subject.instance_variable_get(:@proxy)).to eq proxy
      end

      it "sets @proxy to nil when passed an empty string" do
        subject.proxy = ''

        expect(subject.instance_variable_get(:@proxy)).to be_nil
      end

      it "replaces existing @proxy value with nil when set to empty string" do
        subject.instance_variable_set(:@proxy, 'value')
        subject.proxy = ''

        expect(subject.instance_variable_get(:@proxy)).to be_nil
      end
    end

    describe '#accept_language=' do
      after(:each) do
        subject.accept_language = nil
      end

      it "sets @accept_language to value when passed non-empty string" do
        lang = "ja-JP"

        subject.accept_language = lang

        expect(subject.instance_variable_get(:@accept_language)).to eq lang
      end

      it "sets @accept_language to nil when passed an empty string" do
        subject.accept_language = ''

        expect(subject.instance_variable_get(:@accept_language)).to be_nil
      end

      it "replaces existing @accept_language value with nil when set to empty string" do
        subject.instance_variable_set(:@accept_language, 'value')
        subject.accept_language = ''

        expect(subject.instance_variable_get(:@accept_language)).to be_nil
      end
    end
  end

  describe 'creating a new connection' do

    let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }

    subject { test_conn.make_connection('https://some.site/url', [:test, faraday_stubs]) }

    it 'parses response bodies with a JSON content-type into a hash' do
      faraday_stubs.get('/json') { [200, {'Content-Type' => 'application/json'}, '{"hello": "world"}'] }
      expect(subject.get('/json').body).to eq(:hello => 'world')
    end

    it 'returns the response body as-is when the content-type is not JSON' do
      faraday_stubs.get('/binary') { [200, {'Content-Type' => 'application/octet-stream'}, 'I am a big bucket of binary data'] }
      expect(subject.get('/binary').body).to eq('I am a big bucket of binary data')
    end

    it 'raises errors when the request has an error status code' do
      faraday_stubs.get('/error') { [503, {}, "The server caught fire and cannot service your request right now"] }

      expect {
        subject.get('/error')
      }.to raise_error(Faraday::ClientError, "the server responded with status 503")
    end

    context 'when an authorization value is provided' do
      before(:each) do
        allow(described_class).to receive(:authorization).and_return("auth-test value")
      end

      it 'sets authorization header on requests' do
        expect(subject.headers).to include(:authorization => "auth-test value")
      end
    end

    context 'when an accept language value is provided' do
      before(:each) do
        allow(described_class).to receive(:accept_language).and_return("ja-JP")
      end

      it 'sets accept-language header on requests' do
        expect(subject.headers).to include('Accept-Language' => "ja-JP")
      end
    end
  end

  describe 'creating a default connection' do
    it 'creates a connection with the PuppetForge host' do
      conn = test_conn.default_connection
      expect(conn.url_prefix.to_s).to eq 'https://forgeapi.puppetlabs.com/'
    end
  end
end
