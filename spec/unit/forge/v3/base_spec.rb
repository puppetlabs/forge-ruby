require 'spec_helper'

describe PuppetForge::V3::Base do
  describe '::new_collection' do
    it 'should handle responses with no results' do
      response_data = { data: {}, errors: "Something bad happened!" }

      expect(PuppetForge::V3::Base.new_collection(response_data)).to eq([])
    end

    it 'should handle responses with no pagination info' do
      response_data = { data: {}, errors: "Something bad happened!" }

      collection = PuppetForge::V3::Base.new_collection(response_data)

      expect(collection.limit).to eq(20)
      expect(collection.offset).to eq(0)
      expect(collection.total).to eq(0)
    end
  end
end
