require 'spec_helper'

describe PuppetForge::V3::Base do
  describe '::new_collection' do
    it 'should handle responses with no results' do
      response_data = { data: {}, errors: "Something bad happened!" }

      PuppetForge::V3::Base.new_collection(response_data).should == []
    end

    it 'should handle responses with no pagination info' do
      response_data = { data: {}, errors: "Something bad happened!" }

      collection = PuppetForge::V3::Base.new_collection(response_data)

      collection.limit.should == 10
      collection.offset.should == 0
      collection.total.should == 0
    end
  end
end
