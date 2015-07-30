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

  context "::where" do
    context "finds matching resources" do

      it "only returns releases that match the query" do
        releases = PuppetForge::V3::Release.where(:module => 'puppetforgegemtesting-thorin')

        expect(releases).to be_a(PuppetForge::V3::Base::PaginatedCollection)

        expect(releases.first.version).to eq("0.0.2")
        expect(releases[1].version).to eq("0.0.1")

      end

      it "returns a paginated response" do
        releases = PuppetForge::V3::Release.where(:module => 'puppetforgegemtesting-thorin', :limit => 1)

        expect(releases.limit).to eq(1)
        expect(releases.total).to eq(2)

        expect(releases.next).not_to be_nil
      end

    end

    context "does not find matching resources" do
      it "returns an empty PaginatedCollection" do
        releases = PuppetForge::V3::Release.where(:module => 'puppetforgegemtesting-notamodule')

        expect(releases).to be_a(PuppetForge::V3::Base::PaginatedCollection)

        expect(releases.size).to eq(0)
        expect(releases.empty?).to be(true)
      end
    end
  end
end

