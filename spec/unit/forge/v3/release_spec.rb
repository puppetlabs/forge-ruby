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

      context 'when PuppetForge.host has a path prefix' do
        around(:each) do |spec|
          old_host = PuppetForge.host
          PuppetForge.host = 'http://example.com/forge/api/'

          spec.run

          PuppetForge.host = old_host
        end

        it 'includes path prefix in download url' do
          expect(release.download_url).to eql('http://example.com/forge/api/v3/files/puppetlabs-apache-0.0.1.tar.gz')
        end
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

      context 'when response is 403' do
        it "raises PuppetForge::ReleaseForbidden" do
          mock_conn = instance_double("PuppetForge::V3::Connection", :url_prefix => PuppetForge.host)
          allow(described_class).to receive(:conn).and_return(mock_conn)

          expect(mock_conn).to receive(:get).and_raise(Faraday::ClientError.new("403", {:status => 403, :body => ({:message => "Forbidden"}.to_json)}))

          expect { release.download(Pathname.new(tarball)) }.to raise_error(PuppetForge::ReleaseForbidden)
        end
      end

      context 'when connection fails' do
        it "re-raises original error" do
          mock_conn = instance_double("PuppetForge::V3::Connection", :url_prefix => PuppetForge.host)
          allow(described_class).to receive(:conn).and_return(mock_conn)

          expect(mock_conn).to receive(:get).and_raise(Faraday::ConnectionFailed.new("connection failed"))

          expect { release.download(Pathname.new(tarball)) }.to raise_error(Faraday::ConnectionFailed, /connection failed/)
        end
      end
    end

    describe '#verify' do
      let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }
      let(:tarball) { "#{PROJECT_ROOT}/spec/tmp/module.tgz" }
      let(:allow_md5) { true }

      before(:each) do
        FileUtils.rm tarball rescue nil
        release.download(Pathname.new(tarball))
      end

      after(:each) { FileUtils.rm tarball rescue nil }

      context 'file_sha256 is available' do
        before(:each) do
          allow(release).to receive(:file_sha256).and_return("810ff2fb242a5dee4220f2cb0e6a519891fb67f2f828a6cab4ef8894633b1f50")
        end

        let(:mock_sha256) { double(Digest::SHA256, hexdigest: release.file_sha256) }

        it 'only verifies sha-256 checksum' do
          expect(Digest::SHA256).to receive(:file).and_return(mock_sha256)
          expect(Digest::MD5).not_to receive(:file)

          release.verify(tarball, allow_md5)
        end
      end

      context 'file_sha256 is not available' do
        let(:mock_md5) { double(Digest::MD5, hexdigest: release.file_md5) }

        it 'only verfies the md5 checksum' do
          expect(Digest::SHA256).not_to receive(:file)
          expect(Digest::MD5).to receive(:file).and_return(mock_md5)

          release.verify(tarball, allow_md5)
        end
      end

      context 'when allow_md5=false' do
        let(:allow_md5) { false }

        context 'file_sha256 is not available' do
          it 'raises an appropriate error' do
            expect(Digest::SHA256).not_to receive(:file)
            expect(Digest::MD5).not_to receive(:file)

            expect { release.verify(tarball, allow_md5) }.to raise_error(PuppetForge::Error, /cannot verify module release.*md5.*forbidden/i)
          end
        end
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
