require 'spec_helper'

describe PuppetForge::V3::Module do
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
    context "when the user exists," do

      it "find returns a PuppetForge::V3::Module." do
        mod = PuppetForge::V3::Module.find('puppetforgegemtesting-thorin')

        expect(mod).to be_a(PuppetForge::V3::Module)
      end

      it "it exposes the API information." do
        mod = PuppetForge::V3::Module.find('puppetforgegemtesting-thorin')

        expect(mod).to respond_to(:uri)
        expect(mod).to respond_to(:owner)
        expect(mod).to respond_to(:current_release)
        expect(mod).to respond_to(:releases)

        expect(mod.uri).to be_a(String)
        expect(mod.owner).to be_a(PuppetForge::V3::User)
        expect(mod.current_release).to be_a(PuppetForge::V3::Release)
        expect(mod.releases.first).to be_a(PuppetForge::V3::Release)
      end

    end

    context "when the module doesn't exist," do

      it "find returns nil." do
        mod = PuppetForge::V3::Module.find('puppetforgegemtesting-bilbo')

        expect(mod).to be_nil
      end

    end

  end
end

