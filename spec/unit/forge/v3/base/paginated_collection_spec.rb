require 'spec_helper'

describe PuppetForge::V3::Base::PaginatedCollection do
  let(:klass) do
    Class.new do
      def self.get_collection(url)
        data = {
          '/v3/collection'        => [ :A, :B, :C ],
          '/v3/collection?page=2' => [ :D, :E, :F ],
          '/v3/collection?page=3' => [ :G, :H ],
        }

        meta = {
          '/v3/collection' => {
            :limit    => 3,
            :offset   => 0,
            :first    => '/v3/collection',
            :previous => nil,
            :current  => '/v3/collection',
            :next     => '/v3/collection?page=2',
            :total    => 8,
          },
          '/v3/collection?page=2' => {
            :limit    => 3,
            :offset   => 0,
            :first    => '/v3/collection',
            :previous => '/v3/collection',
            :current  => '/v3/collection?page=2',
            :next     => '/v3/collection?page=3',
            :total    => 8,
          },
          '/v3/collection?page=3' => {
            :limit    => 3,
            :offset   => 0,
            :first    => '/v3/collection',
            :previous => '/v3/collection?page=2',
            :current  => '/v3/collection?page=3',
            :next     => nil,
            :total    => 8,
          },
        }

        PuppetForge::V3::Base::PaginatedCollection.new(self, data[url], meta[url], {})
      end
    end
  end

  subject { klass.get_collection('/v3/collection') }

  it 'maps to a single page of the collection' do
    expect(subject.to_a).to eql([ :A, :B, :C ])
  end

  it 'knows the size of the entire collection' do
    expect(subject.total).to be 8
  end

  it 'contains only a subset of the entire collection' do
    expect(subject.size).to be 3
  end

  it 'enables page navigation' do
    expect(subject.next).to_not be_empty
    expect(subject.next.to_a).to_not eql(subject.to_a)
    expect(subject.next.previous.to_a).to eql(subject.to_a)
  end

  it 'exposes the pagination metadata' do
    expect(subject.metadata[:limit]).to be subject.size
  end

  it 'exposes previous_url and next_url' do
    expected = subject.next_url
    expect(subject.next.next.previous_url).to eql(expected)
  end

  describe '#unpaginated' do
    it 'provides an iterator over the entire collection' do
      expected = [ :A, :B, :C, :D, :E, :F, :G, :H ]
      expect(subject.unpaginated.to_a).to eql(expected)
    end

    it "provides a full iterator regardless of which page it's started on" do
      expected = [ :A, :B, :C, :D, :E, :F, :G, :H ]
      expect(subject.next.next.unpaginated.to_a).to eql(expected)
    end
  end
end
