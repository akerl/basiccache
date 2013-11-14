##
# This module provides a simple key/value cache for storing computation results

module BasicCache
  VERSION = '0.0.13'

  class << self
    ##
    # Insert a helper .new() method for creating a new Cache object

    def new(*args)
      self::Cache.new(*args)
    end
  end

  ##
  # If we're using 2.0.0+, caller_locations is available and is much faster.
  # If not, fall back to caller
  # These methods return the name of the calling function 2 levels up
  # This allows them to return the name of whatever called Cache.cache()

  if Kernel.respond_to? 'caller_locations'
    def self.get_caller
      caller_locations(2, 1).first.label
    end
  else
    def self.get_caller
      caller[1][/`([^']*)'/, 1]
    end
  end

  ##
  # Cache object, maintains a key/value store

  class Cache
    attr_reader :store

    ##
    # Generate an empty store

    def initialize
      @store = {}
    end

    ##
    # Empty out either the given key or the full store

    def clear!(key = nil)
      key.nil? ? @store.clear : @store.delete(key)
    end

    ##
    # If the key is cached, return it.
    # If not, run the code, cache the result, and return it

    def cache(key = nil, &code)
      key ||= BasicCache.get_caller
      @store[key.to_sym] ||= code.call
    end

    ##
    # Return the size of the cache

    def size
      @store.length
    end

    ##
    # Check if a value is cached
    # (just a wrapper, designed to be redefined by subclasses)

    def include?(key = nil)
      key ||= BasicCache.get_caller
      @store.include? key.to_sym
    end
  end

  ##
  # Time-based cache object

  class TimeCache < Cache
    attr_reader :lifetime

    ##
    # Generate an empty store, with a default lifetime of 60 seconds

    def initialize(lifetime = 30)
      @lifetime = lifetime
      @cache_item = Struct.new(:stamp, :value)
      super()
    end

    ##
    # If the key is cached but expired, clear it

    def cache(key = nil, &code)
      key ||= BasicCache.get_caller
      key = key.to_sym
      unless @store.include? key and Time.now - @store[key].stamp < @lifetime
        @store[key] = @cache_item.new(Time.now, code.call)
      end
      @store[key].value
    end

    ##
    # Check if a value is cached and not expired

    def include?(key = nil)
      key ||= BasicCache.get_caller
      key = key.to_sym
      @store.include? key and Time.now - @store[key].stamp < @lifetime
    end
  end
end

