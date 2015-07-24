require 'spec_helper'

describe PuppetForge::V3::Release do
  before do

    class PuppetForge::V3::Base
      class << self
        def faraday_api
          @faraday_api = Faraday.new ({ :url => "#{PuppetForge.host}/", :ssl => { :verify => false } }) do |c|
            c.response :json, :content_type => 'application/json'
            c.adapter Faraday.default_adapter
          end

          @faraday_api
        end
      end
    end

    PuppetForge.host = "https://forge-aio01-petest.puppetlabs.com/"

  end

  context "#find" do
    context "when the release exists," do

      it "find returns a PuppetForge::V3::Release." do
        mod = PuppetForge::V3::Release.find('puppetforgegemtesting-thorin-0.0.1')

        expect(mod).to be_a(PuppetForge::V3::Release)
      end

      it "it exposes the API information." do
        mod = PuppetForge::V3::Release.find('puppetforgegemtesting-thorin-0.0.1')

        expect(mod).to respond_to(:uri)

        expect(mod.uri).to be_a(String)
      end

    end

    context "when the release doesn't exist," do

      it "find returns nil." do
        mod = PuppetForge::V3::Release.find('puppetforgegemtesting-bilbo-0.0.1')

        expect(mod).to be_nil
      end

    end

  end
end

