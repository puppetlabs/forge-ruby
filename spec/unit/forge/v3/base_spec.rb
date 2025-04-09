require 'spec_helper'

describe PuppetForge::V3::Base do
  context 'connection management' do
    before do
      PuppetForge::Connection.authorization = nil
      PuppetForge::Connection.proxy = nil
      described_class.conn = nil
    end

    after do
      PuppetForge::Connection.authorization = nil
      PuppetForge::Connection.proxy = nil
      described_class.conn = nil
    end

    describe 'setting authorization value after a connection is created' do
      it 'resets connection' do
        old_conn = described_class.conn

        PuppetForge::Connection.authorization = 'post-init auth value'
        new_conn = described_class.conn

        expect(new_conn).not_to eq(old_conn)
        expect(new_conn.headers).to include(authorization: 'post-init auth value')
      end
    end

    describe 'setting proxy value after a connection is created' do
      it 'resets connection' do
        old_conn = described_class.conn

        PuppetForge::Connection.proxy = 'http://proxy.example.com:8888'
        new_conn = described_class.conn

        expect(new_conn).not_to eq(old_conn)
        expect(new_conn.proxy).not_to be_nil
        expect(new_conn.proxy.uri.to_s).to eq('http://proxy.example.com:8888')
      end
    end
  end

  describe '::new_collection' do
    it 'handles responses with no results' do
      response_data = { data: {}, errors: 'Something bad happened!' }

      expect(PuppetForge::V3::Base.new_collection(response_data)).to eq([])
    end

    it 'handles responses with no pagination info' do
      response_data = { data: {}, errors: 'Something bad happened!' }

      collection = PuppetForge::V3::Base.new_collection(response_data)

      expect(collection.limit).to eq(20)
      expect(collection.offset).to eq(0)
      expect(collection.total).to eq(0)
    end
  end

  describe 'the host url setting' do
    context 'without a path prefix' do
      before do
        PuppetForge::V3::Base.lru_cache.clear # We test the cache later, so clear it now
        @orig_host = PuppetForge.host
        PuppetForge.host = 'https://api.example.com'

        # Trigger connection reset
        PuppetForge::V3::Base.conn = PuppetForge::Connection.default_connection
      end

      after do
        PuppetForge.host = @orig_host

        # Trigger connection reset
        PuppetForge::V3::Base.conn = PuppetForge::Connection.default_connection
      end

      it 'works' do
        stub_api_for(PuppetForge::V3::Base) do |stubs|
          stub_fixture(stubs, :get, '/v3/bases/puppet')
        end

        base = PuppetForge::V3::Base.find 'puppet'
        expect(base.username).to eq('foo')
      end

      it 'caches responses' do
        stub_api_for(PuppetForge::V3::Base, lru_cache: true) do |stubs|
          stub_fixture(stubs, :get, '/v3/bases/puppet')
        end
        allow(PuppetForge::V3::Base.lru_cache).to receive(:put).and_call_original
        allow(PuppetForge::V3::Base.lru_cache).to receive(:get).and_call_original

        PuppetForge::V3::Base.find 'puppet'
        PuppetForge::V3::Base.find 'puppet'
        PuppetForge::V3::Base.find 'puppet'
        expect(PuppetForge::V3::Base.lru_cache).to have_received(:put).once
        expect(PuppetForge::V3::Base.lru_cache).to have_received(:get).exactly(3).times
      end
    end

    context 'with a path prefix' do
      before do
        PuppetForge::V3::Base.lru_cache.clear # We test the cache later, so clear it now
        @orig_host = PuppetForge.host
        PuppetForge.host = 'https://api.example.com/uri/prefix'

        # Trigger connection reset
        PuppetForge::V3::Base.conn = PuppetForge::Connection.default_connection
      end

      after do
        PuppetForge.host = @orig_host

        # Trigger connection reset
        PuppetForge::V3::Base.conn = PuppetForge::Connection.default_connection
      end

      it 'works' do
        stub_api_for(PuppetForge::V3::Base, PuppetForge.host) do |stubs|
          stub_fixture(stubs, :get, '/uri/prefix/v3/bases/puppet')
        end

        base = PuppetForge::V3::Base.find 'puppet'
        expect(base.username).to eq('bar')
      end

      it 'caches responses' do
        stub_api_for(PuppetForge::V3::Base, PuppetForge.host, lru_cache: true) do |stubs|
          stub_fixture(stubs, :get, '/uri/prefix/v3/bases/puppet')
        end
        allow(PuppetForge::V3::Base.lru_cache).to receive(:put).and_call_original
        allow(PuppetForge::V3::Base.lru_cache).to receive(:get).and_call_original

        PuppetForge::V3::Base.find 'puppet'
        PuppetForge::V3::Base.find 'puppet'
        PuppetForge::V3::Base.find 'puppet'
        expect(PuppetForge::V3::Base.lru_cache).to have_received(:put).once
        expect(PuppetForge::V3::Base.lru_cache).to have_received(:get).exactly(3).times
      end
    end
  end
end
