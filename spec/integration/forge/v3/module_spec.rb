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

  context "::find" do
    context "when the user exists" do
      let (:mod) { PuppetForge::V3::Module.find('puppetforgegemtesting-thorin') }

      it "returns a PuppetForge::V3::Module." do
        expect(mod).to be_a(PuppetForge::V3::Module)
      end

      it "exposes the API information." do
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

    context "when the module doesn't exist" do
      let (:mod) { PuppetForge::V3::Module.find('puppetforgegemtesting-thorin') }

      it "find returns nil." do
        mod = PuppetForge::V3::Module.find('puppetforgegemtesting-bilbo')

        expect(mod).to be_nil
      end

    end

  end

  context "::where" do
    context "finds matching resources" do

      it "only returns modules that match the query" do
        modules = PuppetForge::V3::Module.where(:owner => 'puppetforgegemtesting')

        expect(modules).to be_a(PuppetForge::V3::Base::PaginatedCollection)
        modules.each do |mod|
          expect(mod.owner.username).to eq('puppetforgegemtesting')
        end

      end

      it "returns a paginated response" do
        modules = PuppetForge::V3::Module.where(:owner => 'puppetforgegemtesting', :limit => 1)

        expect(modules.limit).to eq(1)
        expect(modules.total).to eq(2)

        expect(modules.next).not_to be_nil
      end

    end

    context "does not find matching resources" do
      it "returns an empty PaginatedCollection" do
        modules = PuppetForge::V3::Module.where(:owner => 'absentuser')

        expect(modules).to be_a(PuppetForge::V3::Base::PaginatedCollection)

        expect(modules.size).to eq(0)
        expect(modules.empty?).to be(true)
      end
    end
  end
end

