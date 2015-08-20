require 'spec_helper'

describe PuppetForge::V3::User do
  before do
    PuppetForge.host = "https://forge-aio01-petest.puppetlabs.com/"
    PuppetForge::V3::Base.conn = PuppetForge::Connection.make_connection(PuppetForge.host, nil, {:ssl => {:verify => false} })
  end

  context "#find" do
    context "when the user exists," do

      it "find returns a PuppetForge::V3::User." do
        user = PuppetForge::V3::User.find('puppetforgegemtesting')
        expect(user).to be_a(PuppetForge::V3::User)
      end

      it "it exposes the API information." do
        user = PuppetForge::V3::User.find('puppetforgegemtesting')

        expect(user).to respond_to(:uri)
        expect(user).to respond_to(:modules)

        expect(user.uri).to be_a(String)
        expect(user.modules).to be_a(PuppetForge::V3::Base::PaginatedCollection)
      end

    end

    context "when the user doesn't exists," do
      let (:user) { PuppetForge::V3::User.find('notauser') }

      it "find returns nil." do
        expect { user }.to raise_error(Faraday::ResourceNotFound)
      end

    end
  end

  context "::where" do
    context "finds matching resources" do

      it "returns sorted users" do
        users = PuppetForge::V3::User.where(:sort_by => 'releases')

        expect(users).to be_a(PuppetForge::V3::Base::PaginatedCollection)

        previous_releases = users.first.release_count
        users.each do |user|
          expect(user.release_count).to be <= previous_releases
          previous_releases = user.release_count
        end

      end

      it "returns a paginated response" do
        users = PuppetForge::V3::User.where(:limit => 1)

        expect(users.limit).to eq(1)

        2.times do
          expect(users).not_to be_nil
          users = users.next
        end
      end

    end

  end
end

