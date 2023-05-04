require 'digest'

module PuppetForge
  # Implements a simple LRU cache. This is used internally by the
  # {PuppetForge::V3::Base} class to cache API responses.
  class LruCache
    # Takes a list of strings (or objects that respond to #to_s) and
    # returns a SHA256 hash of the strings joined with colons. This is
    # a convenience method for generating cache keys. Cache keys do not
    # have to be SHA256 hashes, but they must be unique.
    def self.new_key(*string_args)
      Digest::SHA256.hexdigest(string_args.map(&:to_s).join(':'))
    end

    # @return [Integer] the maximum number of items to cache.
    attr_reader :max_size

    # @param max_size [Integer] the maximum number of items to cache. This can
    #   be overridden by setting the PUPPET_FORGE_MAX_CACHE_SIZE environment
    #   variable.
    def initialize(max_size = 30)
      raise ArgumentError, "max_size must be a positive integer" unless max_size.is_a?(Integer) && max_size > 0

      @max_size = ENV['PUPPET_FORGE_MAX_CACHE_SIZE'] ? ENV['PUPPET_FORGE_MAX_CACHE_SIZE'].to_i : max_size
      @cache = {}
      @lru = []
      @semaphore = Mutex.new
    end

    # Retrieves a value from the cache.
    # @param key [Object] the key to look up in the cache
    # @return [Object] the cached value for the given key, or nil if
    #   the key is not present in the cache.
    def get(key)
      if cache.key?(key)
        semaphore.synchronize do
          # If the key is present, move it to the front of the LRU
          # list.
          lru.delete(key)
          lru.unshift(key)
        end
        cache[key]
      end
    end

    # Adds a value to the cache.
    # @param key [Object] the key to add to the cache
    # @param value [Object] the value to add to the cache
    def put(key, value)
      semaphore.synchronize do
        if cache.key?(key)
          # If the key is already present, delete it from the LRU list.
          lru.delete(key)
        elsif cache.size >= max_size
          # If the cache is full, remove the least recently used item.
          cache.delete(lru.pop)
        end
        # Add the key to the front of the LRU list and add the value
        # to the cache.
        lru.unshift(key)
        cache[key] = value
      end
    end

    # Clears the cache.
    def clear
      semaphore.synchronize do
        cache.clear
        lru.clear
      end
    end

    private

    # Makes testing easier as these can be accessed directly with #send.
    attr_reader :cache, :lru, :semaphore
  end
end
