require 'spec_helper'

describe PuppetForge::V3::User do
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

      it "find returns nil." do
        user = PuppetForge::V3::User.find('notauser')
        expect(user).to be_nil
      end

    end
  end
end

