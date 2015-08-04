require 'spec_helper'

describe PuppetForge::V3::Release do
  before do
    PuppetForge.host = "https://forge-aio01-petest.puppetlabs.com/"
    PuppetForge::V3::Module.conn = PuppetForge::V3::Module.make_connection(PuppetForge.host, nil, {:ssl => {:verify => false} })
    PuppetForge::V3::Release.conn = PuppetForge::V3::Release.make_connection(PuppetForge.host, nil, {:ssl => {:verify => false} })
  end

  context "#find" do
    context "when the release exists," do

      it "find returns a PuppetForge::V3::Release." do
        release = PuppetForge::V3::Release.find('puppetforgegemtesting-thorin-0.0.1')

        expect(release).to be_a(PuppetForge::V3::Release)
      end

      it "it exposes the API information." do
        release = PuppetForge::V3::Release.find('puppetforgegemtesting-thorin-0.0.1')

        expect(release).to respond_to(:uri)

        expect(release.uri).to be_a(String)
      end

    end

    context "when the release doesn't exist," do
      let (:release) { PuppetForge::V3::Release.find('puppetforgegemtesting-bilbo-0.0.1') }

      it "find returns nil." do
        expect { release }.to raise_error(Faraday::ResourceNotFound)
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

