module BasicCache
  ##
  # Time-based cache object

  class TimeCache < Cache
    attr_reader :lifetime

    ##
    # Generate an empty store, with a default lifetime of 60 seconds

    def initialize(lifetime = 60)
      @lifetime = lifetime
      @cache_item = Struct.new(:stamp, :value)
      super()
    end

    ##
    # If the key is cached but expired, clear it

    def cache(key = nil, &code)
      key ||= BasicCache.caller_name
      key = key.to_sym
      # rubocop:disable AndOr
      unless @store.include? key and Time.now - @store[key].stamp < @lifetime
        @store[key] = @cache_item.new(Time.now, code.call)
      end
      # rubocop:enable AndOr
      @store[key].value
    end

    ##
    # Check if a value is cached and not expired

    def include?(key = nil)
      key ||= BasicCache.caller_name
      key = key.to_sym
      # rubocop:disable AndOr
      @store.include? key and Time.now - @store[key].stamp < @lifetime
      # rubocop:enable AndOr
    end

    def [](key = nil)
      super.value
    end

    ##
    # Return the size of the cache (don't include expired entries)
    # By default, purges expired entries while iterating

    def size(purge = true)
      valid = @store.select { |k, v| Time.now - v.stamp < @lifetime }
      @store = valid if purge
      valid.size
    end
  end
end
