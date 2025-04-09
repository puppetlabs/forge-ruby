require 'spec_helper'
require 'uri'

RSpec.describe PuppetForge do
  describe 'host attribute' do
    after do
      PuppetForge.host = PuppetForge::DEFAULT_FORGE_HOST
    end

    it 'adds a trailing slash if not present' do
      PuppetForge.host = 'http://example.com'

      expect(PuppetForge.host[-1, 1]).to eq '/'
    end

    it 'coerces non-String values if possible' do
      PuppetForge.host = URI.parse('http://example.com')

      expect(PuppetForge.host).to be_a String
      expect(PuppetForge.host[-1, 1]).to eq '/'
    end
  end
end
