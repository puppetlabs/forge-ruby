require 'spec_helper'

describe PuppetForge::V3::Base do
  context 'connection management' do
    before(:each) do
      PuppetForge::Connection.authorization = nil
      PuppetForge::Connection.proxy = nil
      described_class.conn = nil
    end

    after(:each) do
      PuppetForge::Connection.authorization = nil
      PuppetForge::Connection.proxy = nil
      described_class.conn = nil
    end

    describe 'setting authorization value after a connection is created' do
      it 'should reset connection' do
        old_conn = described_class.conn

        PuppetForge::Connection.authorization = 'post-init auth value'
        new_conn = described_class.conn

        expect(new_conn).to_not eq(old_conn)
        expect(new_conn.headers).to include(:authorization => 'post-init auth value')
      end
    end

    describe 'setting proxy value after a connection is created' do
      it 'should reset connection' do
        old_conn = described_class.conn

        PuppetForge::Connection.proxy = 'http://proxy.example.com:8888'
        new_conn = described_class.conn

        expect(new_conn).to_not eq(old_conn)
        expect(new_conn.proxy).to_not be_nil
        expect(new_conn.proxy.uri.to_s).to eq('http://proxy.example.com:8888')
      end
    end
  end

  describe '::new_collection' do
    it 'should handle responses with no results' do
      response_data = { data: {}, errors: "Something bad happened!" }

      expect(PuppetForge::V3::Base.new_collection(response_data)).to eq([])
    end

    it 'should handle responses with no pagination info' do
      response_data = { data: {}, errors: "Something bad happened!" }

      collection = PuppetForge::V3::Base.new_collection(response_data)

      expect(collection.limit).to eq(20)
      expect(collection.offset).to eq(0)
      expect(collection.total).to eq(0)
    end
  end
end
