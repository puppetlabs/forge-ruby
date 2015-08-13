require 'spec_helper'

describe PuppetForge::Middleware::SymbolifyJson do
  let(:basic_array) { [1, "two", 3] }
  let(:basic_hash) { { "id" => 1, "data" => "x" } }
  let(:symbolified_hash) { { :id => 1, :data => "x" } }
  let(:internal_hash) { { :id => 2, :data => basic_hash } }

  let(:hash_with_array) { { "id" => 3, "data" => basic_array } }
  let(:array_with_hash) { [1, "two", basic_hash] }

  let(:complex_array) { [array_with_hash, hash_with_array] }
  let(:complex_hash) { { "id" => 4, "data" => [complex_array, basic_array], "more_data" => hash_with_array } }
  let(:complex_request) { { "id" => 5, "data" => complex_hash } }

  let(:middleware) { described_class.new() }

  context "#process_array" do
    it "doesn't change an array with no array or hash inside" do
      processed_array = middleware.process_array(basic_array)
      expect(processed_array).to eql( [1, "two", 3] )
    end

    it "changes all keys of a hash inside the array" do
      processed_array = middleware.process_array(array_with_hash)
      expect(processed_array).to eql( [ 1, "two", { :id => 1, :data => "x" } ] )
    end
  end

  context "#process_hash" do
    it "changes all keys that respond to :to_sym into Symbols and doesn't change values." do
      processed_hash = middleware.process_hash(basic_hash)
      expect(processed_hash).to eql( { :id => 1, :data => "x" } )
    end

    it "doesn't change keys that don't respond to :to_sym" do
      processed_hash = middleware.process_hash(basic_hash.merge({ 1 => 2 }))
      expect(processed_hash).to eql( { :id => 1, :data => "x", 1 => 2 } )
    end

    it "can process a hash that is already symbolified" do
      processed_hash = middleware.process_hash(symbolified_hash)
      expect(processed_hash).to eql( { :id => 1, :data => "x" })
    end

    it "can process a hash with a hash inside of it" do
      processed_hash = middleware.process_hash(internal_hash)
      expect(processed_hash).to eql( {:id => 2, :data => { :id => 1, :data => "x" } })
    end

    it "can process a hash with an array inside of it" do
      processed_hash = middleware.process_hash(hash_with_array)
      expect(processed_hash).to eql( { :id => 3, :data => [1, "two", 3] } ) 
    end

    it "can handle extensively nested arrays and hashes" do
      processed_hash = middleware.process_hash(complex_request)
      expect(processed_hash).to eql( { :id => 5, :data => { :id => 4 , :data=>[ [ [1, "two", { :id => 1, :data => "x" } ], { :id=>3, :data => [1, "two", 3] } ], [1, "two", 3] ], :more_data => { :id => 3, :data => [1, "two", 3] } } } )
    end
  end

end

