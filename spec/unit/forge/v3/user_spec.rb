require 'spec_helper'

describe PuppetForge::V3::User do
  before do
    stub_api_for(PuppetForge::V3::User) do |api|
      stub_fixture(api, :get, '/v3/users/puppetlabs')
      stub_fixture(api, :get, '/v3/users/absent')
    end
  end

  describe '::find' do
    let(:user) { PuppetForge::V3::User.find('puppetlabs') }
    let(:missing_user) { PuppetForge::V3::User.find('absent') }

    it 'can find users that exist' do
      user.username.should == 'puppetlabs'
    end

    it 'returns nil for non-existent users' do
      missing_user.should be_nil
    end
  end

  describe '#modules' do
    before do
      stub_api_for(PuppetForge::V3::Module) do |api|
        stub_fixture(api, :get, '/v3/modules?owner=puppetlabs')
      end
    end

    let(:user) { PuppetForge::V3::User.find('puppetlabs') }

    it 'should return a PaginatedCollection' do
      expect(user.modules).to be_a PuppetForge::V3::Base::PaginatedCollection
    end

    it 'should only return modules for the current user' do
      module_owners = user.modules.map(&:owner)
      expect(module_owners.group_by(&:username).keys).to eql(['puppetlabs'])
    end
  end

  describe 'instance properies' do
    let(:user) { PuppetForge::V3::User.find('puppetlabs') }

    example 'are easily accessible' do
      expect(user.created_at).to_not be nil
    end
  end
end
