require 'spec_helper'
require 'fileutils'

describe PuppetForge::V3::Release do
  before do
    stub_api_for(PuppetForge::V3::Release) do |stubs|
      stub_fixture(stubs, :get, '/v3/releases/puppetlabs-apache-0.0.1')
      stub_fixture(stubs, :get, '/v3/releases/absent-apache-0.0.1')
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

    before do
      stub_api_for(PuppetForge::V3::Module) do |stubs|
        stub_fixture(stubs, :get, '/v3/modules/puppetlabs-apache')
      end
    end

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

    before do
      stub_api_for(PuppetForge::V3::Release) do |stubs|
        stub_fixture(stubs, :get, '/v3/releases/puppetlabs-apache-0.0.1')
      end
    end

    it 'handles an API response that does not include a scheme and host' do
      release.file_uri = '/v3/files/puppetlabs-apache-0.0.1.tar.gz'
      expect(release.download_url).to eql(PuppetForge.host + '/v3/files/puppetlabs-apache-0.0.1.tar.gz')
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
    before do
      stub_api_for(PuppetForge::V3::Release) do |stubs|
        stub_fixture(stubs, :get, '/v3/releases/puppetlabs-apache-0.0.1')
        stub_fixture(stubs, :get, '/v3/files/puppetlabs-apache-0.0.1.tar.gz')
      end
    end

    it 'downloads the file to the specified location' do
      expect(File.exist?(tarball)).to be false
      release.download(Pathname.new(tarball))
      expect(File.exist?(tarball)).to be true
    end
  end

  describe '#metadata' do
    let(:release) { PuppetForge::V3::Release.find('puppetlabs-apache-0.0.1') }

    before do
      stub_api_for(PuppetForge::V3::Module) do |stubs|
        stub_fixture(stubs, :get, '/v3/modules/puppetlabs-apache')
      end

      stub_api_for(PuppetForge::V3::Release) do |stubs|
        stub_fixture(stubs, :get, '/v3/releases/puppetlabs-apache-0.0.1')
        stub_fixture(stubs, :get, '/v3/releases?module=puppetlabs-apache')
      end
    end

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
