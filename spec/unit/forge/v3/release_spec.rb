require 'spec_helper'
require 'fileutils'

describe PuppetForge::V3::Release do
  context 'connection management' do
    before(:each) do
      PuppetForge::Connection.authorization = nil
      PuppetForge::Connection.proxy = nil
      described_class.conn = PuppetForge::V3::Base.conn(true)
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

  context 'with stubbed connection' do
    before do
      stub_api_for(PuppetForge::V3::Base) do |stubs|
        stub_fixture(stubs, :get, '/v3/releases/puppetlabs-apache-0.0.1')
        stub_fixture(stubs, :get, '/v3/releases/absent-apache-0.0.1')
        stub_fixture(stubs, :get, '/v3/files/puppetlabs-apache-0.0.1.tar.gz')
        stub_fixture(stubs, :get, '/v3/modules/puppetlabs-apache')
        stub_fixture(stubs, :get, '/v3/releases?module=puppetlabs-apache')
      end
    end

    describe '::find' do
      let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }
      let(:missing_release) { PuppetForge::V3::Release.find('absent-apache-0.0.1') }

      it 'can find releases that exist' do
        expect(release.version).to eql('0.0.1')
      end

      it 'raises Faraday::ResourceNotFound for non-existent releases' do
        expect { missing_release }.to raise_error(Faraday::ResourceNotFound)
      end
    end

    describe '#module' do
      let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }

      it 'exposes the related module as a property' do
        expect(release.module).to_not be nil
      end

      it 'grants access to module attributes without an API call' do
        expect(PuppetForge::V3::Module).not_to receive(:request)
        expect(release.module.name).to eql('apache')
      end

      it 'transparently makes API calls for other attributes' do
        expect(PuppetForge::V3::Module).to receive(:request).once.and_call_original
        expect(release.module.created_at).to_not be nil
      end
    end

    describe '#download_url' do
      let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }

      it 'handles an API response that does not include a scheme and host' do
        release.file_uri = '/v3/files/puppetlabs-apache-0.0.1.tar.gz'
        uri_with_host = URI.join(PuppetForge.host, '/v3/files/puppetlabs-apache-0.0.1.tar.gz').to_s
        expect(release.download_url).to eql(uri_with_host)
      end

      it 'handles an API response that includes a scheme and host' do
        release.file_uri = 'https://example.com/v3/files/puppetlabs-apache-0.0.1.tar.gz'
        expect(release.download_url).to eql('https://example.com/v3/files/puppetlabs-apache-0.0.1.tar.gz')
      end
    end

    describe '#download' do
      let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }
      let(:tarball) { "#{PROJECT_ROOT}/spec/tmp/module.tgz" }

      before { FileUtils.rm tarball rescue nil }
      after  { FileUtils.rm tarball rescue nil }

      it 'downloads the file to the specified location' do
        expect(File.exist?(tarball)).to be false
        release.download(Pathname.new(tarball))
        expect(File.exist?(tarball)).to be true
      end
    end

    describe '#metadata' do
      let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }

      it 'is lazy and repeatable' do
        3.times do
          expect(release.module.releases.last.metadata).to_not be_nil
        end
      end
    end

    describe 'instance properies' do
      let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }

      example 'are easily accessible' do
        expect(release.created_at).to_not be nil
      end
    end
  end
end
