require 'spec_helper'

describe PuppetForge::LruCache do
  it 'creates a cache key from a list of strings' do
    expect { subject.class.new_key('foo', 'bar', 'baz') }.not_to raise_error 
  end

  it 'creates a new instance' do
    expect { PuppetForge::LruCache.new(1) }.not_to raise_error
  end

  it 'raises an error if max_size is not a positive integer' do
    expect { PuppetForge::LruCache.new(-1) }.to raise_error(ArgumentError)
    expect { PuppetForge::LruCache.new(0) }.to raise_error(ArgumentError)
    expect { PuppetForge::LruCache.new(1.5) }.to raise_error(ArgumentError)
  end

  it 'defaults to a max_size of 30' do
    expect(PuppetForge::LruCache.new.max_size).to eq(30)
  end

  it 'allows max_size to be set via the max_size parameter' do
    expect(PuppetForge::LruCache.new(42).max_size).to eq(42)
  end

  it 'provides a #get method' do
    expect(PuppetForge::LruCache.new).to respond_to(:get)
  end

  it 'provides a #put method' do
    expect(PuppetForge::LruCache.new).to respond_to(:put)
  end

  it 'provides a #clear method' do
    expect(PuppetForge::LruCache.new).to respond_to(:clear)
  end

  context 'with environment variables' do
    around(:each) do |example|
      @old_max_size = ENV['PUPPET_FORGE_MAX_CACHE_SIZE']
      ENV['PUPPET_FORGE_MAX_CACHE_SIZE'] = '42'
      example.run
      ENV['PUPPET_FORGE_MAX_CACHE_SIZE'] = @old_max_size
    end

    it 'uses the value of the PUPPET_FORGE_MAX_CACHE_SIZE environment variable if present' do
      expect(PuppetForge::LruCache.new.max_size).to eq(42)
    end
  end

  context '#get' do
    it 'returns nil if the key is not present in the cache' do
      expect(PuppetForge::LruCache.new.get('foo')).to be_nil
    end

    it 'returns the cached value for the given key' do
      cache = PuppetForge::LruCache.new
      cache.put('foo', 'bar')
      expect(cache.get('foo')).to eq('bar')
    end

    it 'moves the key to the front of the LRU list' do
      cache = PuppetForge::LruCache.new
      cache.put('foo', 'bar')
      cache.put('baz', 'qux')
      cache.get('foo')
      expect(cache.send(:lru)).to eq(['foo', 'baz'])
    end

    # The below test is non-deterministic but I'm not sure how to unit
    # test thread-safety.
    # it 'is thread-safe' do
    #   cache = PuppetForge::LruCache.new
    #   cache.put('foo', 'bar')
    #   cache.put('baz', 'qux')
    #   threads = []
    #   threads << Thread.new { 100.times { cache.get('foo') } }
    #   threads << Thread.new { 100.times { cache.get('baz') } }
    #   threads.each(&:join)
    #   expect(cache.send(:lru)).to eq(['baz', 'foo'])
    # end
  end

  context '#put' do
    it 'adds the key to the front of the LRU list' do
      cache = PuppetForge::LruCache.new
      cache.put('foo', 'bar')
      expect(cache.send(:lru)).to eq(['foo'])
    end

    it 'adds the value to the cache' do
      cache = PuppetForge::LruCache.new
      cache.put('foo', 'bar')
      expect(cache.send(:cache)).to eq({ 'foo' => 'bar' })
    end

    it 'removes the least recently used item if the cache is full' do
      cache = PuppetForge::LruCache.new(2)
      cache.put('foo', 'bar')
      cache.put('baz', 'qux')
      cache.put('quux', 'corge')
      expect(cache.send(:lru)).to eq(['quux', 'baz'])
    end

    # The below test is non-deterministic but I'm not sure how to unit
    # test thread-safety.
    # it 'is thread-safe' do
    #   cache = PuppetForge::LruCache.new
    #   threads = []
    #   threads << Thread.new { 100.times { cache.put('foo', 'bar') } }
    #   threads << Thread.new { 100.times { cache.put('baz', 'qux') } }
    #   threads.each(&:join)
    #   expect(cache.send(:lru)).to eq(['baz', 'foo'])
    # end
  end

  context '#clear' do
    it 'clears the cache' do
      cache = PuppetForge::LruCache.new
      cache.put('foo', 'bar')
      cache.put('baz', 'qux')
      cache.clear
      expect(cache.send(:lru).empty?).to be_truthy
      expect(cache.send(:cache).empty?).to be_truthy
    end
  end
end
