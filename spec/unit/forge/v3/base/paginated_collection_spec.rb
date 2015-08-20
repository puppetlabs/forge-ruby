require 'spec_helper'

describe PuppetForge::V3::Base::PaginatedCollection do
  let(:klass) do
    allow(PuppetForge::V3::Base).to receive(:get_collection) do |url|
      data = {
        '/v3/collection'        => [ { :data => :A }, { :data => :B }, { :data => :C } ],
        '/v3/collection?page=2' => [ { :data => :D }, { :data => :E }, { :data => :F } ],
        '/v3/collection?page=3' => [ { :data => :G }, { :data => :H } ],
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

      PuppetForge::V3::Base::PaginatedCollection.new(PuppetForge::V3::Base, data[url], meta[url], {})
    end

    PuppetForge::V3::Base
  end

  subject { klass.get_collection('/v3/collection') }

  def collect_data(paginated)
    paginated.to_a.collect do |x|
      x.data
    end
  end

  it '#all returns self for backwards compatibility.' do
    paginated = subject.all

    expect(paginated).to eq(subject)
  end

  it 'maps to a single page of the collection' do
    expect(collect_data(subject)).to eql([ :A, :B, :C ])
  end

  it 'knows the size of the entire collection' do
    expect(subject.total).to be 8
  end

  it 'contains only a subset of the entire collection' do
    expect(subject.size).to be 3
  end

  it 'enables page navigation' do
    expect(subject.next).to_not be_empty
    expect(collect_data(subject.next)).to_not eql(collect_data(subject))
    expect(collect_data(subject.next.previous)).to eql(collect_data(subject))
  end

  it 'exposes the pagination metadata' do
    expect(subject.limit).to be subject.size
  end

  it 'exposes previous_url and next_url' do
    expected = subject.next_url
    expect(subject.next.next.previous_url).to eql(expected)
  end

  describe '#unpaginated' do
    it 'provides an iterator over the entire collection' do
      expected = [ :A, :B, :C, :D, :E, :F, :G, :H ]
      actual = subject.unpaginated.to_a.collect do |x|
        expect(x).to be_a(klass)
        x.data
      end

      expect(actual).to eql(expected)
    end

    it "provides a full iterator regardless of which page it's started on" do
      expected = [ :A, :B, :C, :D, :E, :F, :G, :H ]

      actual = subject.next.next.unpaginated.to_a.collect do |x|
        expect(x).to be_a(klass)
        x.data
      end
      expect(actual).to eql(expected)
    end
  end
end
