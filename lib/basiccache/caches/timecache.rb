##
# Extends BasicCache to add a time-based cache
module BasicCache
  ##
  # Timecache item struct, timestamp and value

  TimeCacheItem = Struct.new(:stamp, :value)

  ##
  # Time-based cache object
  class TimeCache < Cache
    attr_reader :lifetime

    ##
    # Generate an empty store, with a default lifetime of 60 seconds

    def initialize(params = {})
      params = { store: params } unless params.is_a? Hash
      @lifetime = params.fetch :lifetime, 60
      super
    end

    ##
    # Return the size of the cache (don't include expired entries)

    def size
      @store.keys.count { |k| Time.now - @store[k].stamp < @lifetime }
    end

    ##
    # Return a value from the cache, or calculate it and store it
    # Recalculate if the cached value has expired

    def cache(key = nil)
      key ||= BasicCache.caller_name
      key = key.to_sym
      if include? key
        @store[key].value
      else
        value = yield
        @store[key] = TimeCacheItem.new Time.now, value
        value
      end
    end

    ##
    # Check if a value is cached and not expired

    def include?(key = nil)
      key ||= BasicCache.caller_name
      key = key.to_sym
      @store.include?(key) && Time.now - @store[key].stamp < @lifetime
    end

    ##
    # Retrieve a value

    def [](key = nil)
      super.value
    end

    ##
    # Remove a value, or clear the cache

    def clear!(key = nil)
      resp = super
      resp.class == TimeCacheItem ? resp.value : resp
    end

    ##
    # Prune expired keys

    def prune
      @store.keys.reject { |k| include? k }.map { |k| clear!(k) && k }
    end
  end
end
