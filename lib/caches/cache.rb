##
# Define the basic cache and default store objects

module BasicCache
  ##
  # Set default Store type

  DEFAULT_STORE = BasicCache::Store
  
  ##
  # Cache object, maintains a key/value store

  class Cache
    attr_reader :store

    ##
    # Generate an empty store

    def initialize(params = {})
      params = { store: params } unless params.is_a? Hash
      @store = params.fetch(:store) { DEFAULT_STORE.new }
    end

    ##
    # Return the size of the cache

    def size
      @store.size
    end

    ##
    # If the key is cached, return it.
    # If not, run the code, cache the result, and return it

    def cache(key = nil, &code)
      key ||= BasicCache.caller_name
      @store[key.to_sym] ||= code.call
    end

    ##
    # Check if a value is cached
    # (just a wrapper, designed to be redefined by subclasses)

    def include?(key = nil)
      key ||= BasicCache.caller_name
      @store.include? key.to_sym
    end

    ##
    # Retrieve cached value

    def [](key = nil)
      key ||= BasicCache.caller_name
      fail KeyError, 'Key not cached' unless include? key.to_sym
      @store[key.to_sym]
    end

    ##
    # Empty out either the given key or the full store

    def clear!(key = nil)
      key.nil? ? @store.clear : @store.delete(key.to_sym)
    end

    ##
    # Prunes invalid/expired keys (a noop for the basic cache)

    def prune
    end
  end
end
